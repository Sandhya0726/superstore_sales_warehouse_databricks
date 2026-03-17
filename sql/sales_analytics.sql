-- Descriptive analysis
-- 1. Total Sales and Profit
select  sum(sales) as total_sales, sum(profit) as total_profit from sales_fact;

-- 2. Total sales by region
select distinct a.market, sum(sales) as sales_by_region from market_dim a join sales_fact b 
on a.market_id=b.market_id group by a.market;

-- 3. Top 10 customers by sales
select a.customer_id, a.customer_name, sum(b.sales) as sales_by_customer from customer_dim a join sales_fact b
on a.customer_id=b.customer_id
group by a.customer_id, a.customer_name
order by sales_by_customer desc
limit 10;

-- 4. Sales by product Category
select a.category, sum(b.sales) as sales_by_product_category from product_dim a left join sales_fact b 
on a.product_id=b.product_id
group by a.category
order by sales_by_product_category desc;

-- Time Based Analysis
--5. Monthly Sales Trend 

select b.year, b.month, sum(a.sales) as monthly_sales from sales_fact a join date_dim b
on a.date_id_order_date=b.date_id
group by b.year,b.month
order by b.year,b.month;

-- 6. Quarterly Profit Trend
select b.year,b.quarter, sum(a.profit) from sales_fact a join date_dim b 
on a.date_id_order_date =b.date_id
group by b.year, b.quarter 
order by b.year, b.quarter;

-- Customer Segmentation/behavioral analysis
-- 7. sales by customer segment
-- cheking the unique segments
select distinct segment from customer_dim;

select a.segment, sum(b.sales) as sales_by_customer_segment from customer_dim a left join sales_fact b 
on a.customer_id=b.customer_id
group by a.segment
order by sales_by_customer_segment desc; 

-- 8 High value customers (top 20%)

with customer_sales as(
select a.customer_id, b.customer_name, sum(a.sales) as sales_by_customer from sales_fact a 
left join customer_dim b
on a.customer_id=b.customer_id 
group by a.customer_id, b.customer_name), 
ranked as(
select *, ntile(5) over(order by sales_by_customer desc) as bucket from customer_sales)
select * from ranked where bucket =1;  

-- Product Analysis 
-- 9. Top selling products

select a.product_id, a.product_name, sum(b.sales) as total_sales_by_products from product_dim a
join sales_fact b 
on a.product_id=b.product_id
group by a.product_id, a.product_name
order by total_sales_by_products desc limit 10;

-- 10. Sales by category and subcategory
select a.category,a.sub_category,sum(b.sales) as sales_by_category_subcategory from product_dim a join sales_fact b 
on a.product_id=b.product_id 
group by a.category,a.sub_category
order by sales_by_category_subcategory desc;

-- Profitability and discount analysis
-- 11. Profit vs. Discount Correlation 
select corr(discount,profit) from sales_fact;
-- -0.277 means there is negative relation ( as discount increases profit tends to decrease) 

-- 12. Average profit margin per product_category
select a.category, round(100.0*sum(b.profit)/sum(b.sales),2) as avg_profit_margin from product_dim a join sales_fact b 
on a.product_id=b.product_id
group by a.category;

-- Advanced Analysis/KPI's
-- 13. Year Over Year Growth(YOY)

select *, round(100.0*(curr_sales-prev_sales)/prev_sales,2) as YOY_Growth from(
select b.year
, sum(sales) as curr_sales,lag(sum(sales)) over(order by b.year) as prev_sales  from sales_fact a join date_dim b
on a.date_id_order_date=b.date_id
group by b.year)t;


-- 14. Customer RFM(Recency, Frequency and Monetary Analysis)
with rfm_base as(
select a.customer_id, max(b.order_date) as last_order_date,
count(order_id) as frequency,
sum(sales) as monetary
from customer_dim a join sales_fact b 
on a.customer_id=b.customer_id group by a.customer_id)
, rfm_calc as (
select *, datediff(day, last_order_date,(select max(order_date) from sales_fact)) as recency from rfm_base
), rfm_score as (
select *, ntile(5) over(order by recency desc) as r_score,
ntile(5) over(order by frequency desc) as f_score,
ntile(5) over(order by monetary desc) as m_score from rfm_calc
) select * from rfm_score;


-- 15. Region wise sales vs. profit efficiency
select b.region,sum(a.sales) as total_sales, sum(a.profit) as total_profit, 
sum(profit)/sum(sales) as profit_ratio from sales_fact a join market_dim b 
on a.market_id=b.market_id group by b.region
order by profit_ratio desc;
