create or replace stage table_stage;


copy into customer_dim
from @table_stage/customer_dim.csv
file_format = (
    type = 'csv',
    skip_header = 1,
    field_optionally_enclosed_by = '"'
);


copy into product_dim
from @table_stage/product_dim.csv
file_format = (
    type = 'csv',
    skip_header = 1,
    field_optionally_enclosed_by = '"'
);

copy into orders_dim
from @table_stage/order_dim.csv
file_format = (
    type = 'csv',
    skip_header = 1,
    field_optionally_enclosed_by = '"'
);


copy into market_dim
from @table_stage/market_dim.csv
file_format = (
    type = 'csv',
    skip_header = 1,
    field_optionally_enclosed_by = '"'
);

copy into date_dim
from @table_stage/date_dim.csv
file_format = (
    type = 'csv',
    skip_header = 1,
    field_optionally_enclosed_by = '"'
);


copy into sales_fact
from @table_stage/sales_fact.csv
file_format = (
    type = 'csv',
    skip_header = 1,
    field_optionally_enclosed_by = '"'
);

select count(*) from sales_fact;
