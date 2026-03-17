create database analytics_db;
use analytics_db;

create schema gold;
use schema gold;

create or replace table customer_dim (
customer_id integer not null,
customer_name varchar,
segment varchar,
country varchar,
state varchar,
constraint pk_customer_id primary key (customer_id)
);


create or replace table product_dim (
    product_id varchar not null,
    category varchar,
    sub_category varchar,
    product_name varchar,
    constraint pk_product_id primary key (product_id)
);


create or replace table market_dim (
    market_id integer not null,
    market varchar,
    region varchar,
    constraint pk_market_id primary key (market_id)
);


create or replace table orders_dim (
    order_id varchar not null,
    order_priority varchar,
    ship_mode varchar,
    constraint pk_order_id primary key (order_id)
);


create or replace table date_dim (
    date_id integer not null,
    date date,
    year integer,
    quarter integer,
    month integer,
    month_name varchar,
    week_of_year integer,
    day integer,
    day_name varchar,
    constraint pk_date_id primary key (date_id)
);


create or replace table sales_fact (
    order_id varchar,
    customer_id integer,
    order_date date,
    ship_date date,
    product_id varchar,
    market_id integer,
    sales number,
    quantity integer,
    discount number,
    profit number,
    shipping_cost number,
    date_id_order_date integer,
    date_id_ship_date integer
    );



