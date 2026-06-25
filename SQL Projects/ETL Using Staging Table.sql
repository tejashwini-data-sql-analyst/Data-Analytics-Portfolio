-- CUSTOMERS STAGING + ORIGINAL TABLE
create table temp_customers (
cust_id int primary key,
cust_name varchar(150),
cust_mobile text,
email varchar(150),
login_by_aap varchar(50),
gender varchar(15),
DOB date,
Anniverssary date,
dont_import int,
preferences varchar(50),
Loyalty_points int,
membership_status varchar(50),
last_date date,
modified_date date,
created_date date);
 
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
into table temp_customers
fields terminated by ','
lines terminated by '\r\n'
ignore 1 rows;

create table customers (
cust_id int primary key,
cust_name varchar(50),
cust_mobile text,
loging_by_aap varchar(50),
gender varchar(15),
preferences varchar(50),
loyalty_points int,
membership_status varchar(50));

insert into customers (
cust_id ,
cust_name ,
cust_mobile ,
loging_by_aap ,
gender ,
preferences,
loyalty_points,
membership_status)
select cust_id ,
cust_name ,
cust_mobile ,
login_by_aap ,
gender ,
preferences,
loyalty_points,
membership_status
from temp_customers;

-- ORDERS STAGING + ORIGINAL TABLE
create table temp_orders (order_id int primary key, cust_id int, Restaurant_id int, order_date date, 
Total_amount int, Discount int, Final_amount int, status varchar(50), payment_method varchar(50),
order_source varchar(50), created_date date, modified_date date, order_status varchar(50),
payment_id varchar(50), delivery_time int, coupon_code varchar(50));

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
into table temp_orders
fields terminated by ','
lines terminated by '\r\n'
ignore 1 rows;

create table orders(
order_id int primary key, cust_id int, Restaurant_id int, order_date date, Total_amount int,
Discount int, Final_amount int, status varchar(50), payment_method varchar(50), order_source varchar(50),
order_status varchar(50), payment_id varchar(50) unique, delivery_time int);

insert into orders (
order_id , cust_id, Restaurant_id , order_date, Total_amount , Discount , Final_amount , status ,
payment_method , order_source , order_status , payment_id , delivery_time)
select order_id, cust_id, Restaurant_id, order_date, Total_amount, Discount, Final_amount, status,
payment_method, order_source, order_status, payment_id, delivery_time from temp_orders;

-- DELIVERY STAGING + ORIGINAL TABLE
create table temp_delivery (
delivery_id int,
order_id int,
delivery_agent_id int,
pickup_time datetime,
expected_delivery_time datetime,
actual_delivery_time datetime,
delivery_status varchar(50),
delivery_ratings int,
created_time date,
modified_time date);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/delivery.csv'
into table temp_delivery
fields terminated by ','
lines terminated by '\r\n'
ignore 1 rows;

create table delivery (
delivery_id int primary key,
order_id int unique,
delivery_agent_id int,
pickup_time datetime,
expected_delivery_time datetime,
actual_delivery_time datetime,
delivery_status varchar(50),
delivery_ratings int
);

insert into delivery (
delivery_id ,
order_id ,
delivery_agent_id ,
pickup_time ,
expected_delivery_time ,
actual_delivery_time ,
delivery_status ,
delivery_ratings)
select delivery_id ,
order_id ,
delivery_agent_id ,
pickup_time ,
expected_delivery_time ,
actual_delivery_time ,
delivery_status ,
delivery_ratings
from temp_delivery;

-- MENU STAGING + ORIGINAL TABLE
create table temp_menu(
MenuItem_ID int,
restaurant_id int,
item_name varchar(250),
category varchar(150),
price int,
calories int,
ingredients varchar(250),
preparation_time int,
created_date date,
modified_date date);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/menu.csv'
into table temp_menu
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

create table Menu(
MenuItem_ID int primary key,
restaurant_id int,
item_name varchar(250),
category varchar(150),
price int,
preparation_time int);

insert into menu(
MenuItem_ID ,
restaurant_id ,
item_name ,
category ,
price ,
preparation_time)
select MenuItem_ID ,
restaurant_id ,
item_name ,
category ,
price ,
preparation_time
from temp_menu;

-- RESTAURANT STAGING + ORIGINAL TABLE
create table temp_restaurant (
restaurant_id int primary key,
location varchar(50),
cuisine_type varchar(50),
average_ratings decimal(3,2),
total_review int,
created_date date,
modified_date date,
restaurant_name varchar(50),
delivery_fee decimal(4,2),
delivery_time int);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/restaurant.csv'
into table temp_restaurant
fields terminated by ','
lines terminated by '\r\n'
ignore 1 rows;

create table Restaurant(
restaurant_id int primary key,
location varchar(50),
cuisine_type varchar(50),
average_ratings decimal(3,2),
total_review int,
restaurant_name varchar(50),
delivery_fee decimal(4,2),
delivery_time int
);

insert into restaurant(
restaurant_id ,
location ,
cuisine_type ,
average_ratings ,
total_review ,
restaurant_name ,
delivery_fee ,
delivery_time 
)
select restaurant_id ,
location ,
cuisine_type ,
average_ratings ,
total_review ,
restaurant_name ,
delivery_fee ,
delivery_time
from temp_restaurant;

-- DELIVERYAGENT STAGING + ORIGINAL TABLE
create table delivery_agent(
Agent_id int primary key,
Agent_name varchar(50),
Agent_mobile text,
vehicle_type varchar(50),
Agent_rating decimal(3,2));

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/deliveryagent.csv'
into table temp_deliveryagent
fields terminated by ','
lines terminated by '\r\n'
ignore 1 rows;

-- CUSTOMER ADDRESS STAGING + ORIGINAL TABLE
create table customer_address (
cust_address_id int primary key,
cust_id int,
address varchar(500),
city varchar(20),
pincode int,
address_type varchar(20)
);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customeraddress.csv'
into table customer_address
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

-- LOGIN AUDIT STAGING + ORIGINAL TABLE
create table login_audit(
login_id int primary key,
cust_id int,
login_time datetime,
logout_time datetime,
login_method varchar(25));

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/auditlogin.csv'
into table login_audit
fields terminated by ','
lines terminated by '\r\n'
ignore 1 rows;

-- OPERATING HOURS STAGING + ORIGINAL TABLE
create table Operating_hours(
restaurant_id int primary key,
open_time time,
close_time time,
operating_24_hours varchar(10)
);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/OperatingHours.csv'
into table Operating_hours
fields terminated by ','
lines terminated by '\r\n'
ignore 1 rows;

-- PAYMENTS STAGING + ORIGINAL TABLE
create table payments(
payment_id varchar(20) primary key,
order_id varchar(20) unique,
cust_id int,
amount int,
payment_method varchar(50),
payment_status varchar(50),
payment_date date
);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/payments.csv'
into table payments
fields terminated by ','
lines terminated by '\r\n'
ignore 1 rows;

-- RATINGS STAGING + ORIGINAL TABLE
create table temp_ratings(
order_id varchar(50) primary key,
cust_id int,
restaurant_id int,
Ratings int,
Reviews varchar(500),
created_date date
);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ratings.csv'
into table temp_ratings
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

create table ratings (
rating_id varchar(50) primary key,
order_id varchar(50) unique,
cust_id int,
restaurant_id int,
Ratings int,
Reviews varchar(500));

insert into ratings (
rating_id ,
order_id ,
cust_id ,
restaurant_id ,
Ratings ,
Reviews 
)
select rating_id ,
order_id ,
cust_id ,
restaurant_id ,
Ratings ,
Reviews
from temp_ratings;


