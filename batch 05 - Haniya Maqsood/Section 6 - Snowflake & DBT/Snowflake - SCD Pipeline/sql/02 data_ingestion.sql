create or replace stage customer_ext_stage
  url='s3://scd-demo/'
  credentials=(aws_key_id='<access-key>' aws_secret_key='<secret-key>')
  file_format = CSV;
  
show stages;
list @customer_ext_stage;


create or replace pipe customer_s3_pipe
  auto_ingest = true
  as
  copy into customer_raw
  from @customer_ext_stage/customer_20210806183233.csv
  file_format = CSV
  ;
  
show pipes;
select SYSTEM$PIPE_STATUS('customer_s3_pipe');

select count(*) from customer_raw;

----------------- mine with cred
create storage integration s3_int type = external_stage storage_provider = s3 
enabled = true 
storage_aws_role_arn = 'arn:aws:iam::254265667532:role/snowflake_s3_role' 
storage_allowed_locations = ('s3://s3-scd-snowflake-us-west-2-tf/'); 

desc integration s3_int;

create or replace stage customer_ext_stage
  url='s3://s3-scd-snowflake-us-west-2-tf/'
  storage_integration = s3_int
  file_format = (type = 'CSV' skip_header = 1 field_optionally_enclosed_by = '"');
  
list @customer_ext_stage;

create or replace file format csv_format
  type = 'CSV'
  skip_header = 1
  field_optionally_enclosed_by = '"';

create or replace pipe customer_s3_pipe
  auto_ingest = true
  as
  copy into customer_raw
  from @customer_ext_stage
  file_format = csv_format;

show pipes;
select SYSTEM$PIPE_STATUS('customer_s3_pipe');

select count(*) from customer_raw;
select * from customer_raw limit 10;

