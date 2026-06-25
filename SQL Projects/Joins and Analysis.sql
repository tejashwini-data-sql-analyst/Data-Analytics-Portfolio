-- ORDERS + RESTAURANT TABLE
create view rest_order as (select o.*, r.restaurant_id, r.location, r.cuisine_type, r.average_ratings as Restaurant_Ratings, 
r.total_review as Restaurant_Review, r.restaurant_name, r.delivery_fee, r.delivery_time as Rest_delivery_time
from orders o join restaurant r on o.Restaurant_id = r.restaurant_id);

-- ORDERS + DELIVERY TABLE
create view order_delivery as (select o.*, d.delivery_id, d.delivery_agent_id, d.delivery_status, d.delivery_ratings 
from orders o join delivery d on o.order_id = d.delivery_id);

-- ORDERS + DELIVERY + CUSTOMERS TABLE
create view cust_delivery as (select o.*, d.delivery_id, d.delivery_agent_id, d.delivery_status, d.delivery_ratings,
c.loging_by_aap as Login_App, c.gender, c.preferences, c.loyalty_points, c.membership_status 
from orders o join delivery d on o.order_id = d.delivery_id
join customers c on o.cust_id = c.cust_id);

-- ONE TIME VS REPEATED CUSTOMERS ANALYSIS
create view one_time_analysis as with one_cust as (select count(order_id) One_time, cust_id, row_number() over()
 from churn_analysis group by cust_id having one_time = 1)
select cust_id, delivery_time, delivery_ratings, rest_ratings, rest_reviews, delivery_fee, rest_delivery_time from churn_analysis
where cust_id in (select cust_id from one_cust);
select * from one_time_analysis;
select count(distinct cust_id), Avg(delivery_time), avg(delivery_ratings), avg(rest_ratings), avg(rest_reviews), avg(delivery_fee), avg(rest_delivery_time)
from one_time_analysis;

create or replace view repeated_customer as (select count(cust_id) Repeated_cust from (select cust_id, count(order_id) 
from cust_delivery group by cust_id having count(order_id)>1) T1);
select * from repeated_cust;
select ROUND(AOV*AOF*REPEATED_CUST, 2) CLV from final;
select * from rest_order;
select * from restaurant;

with one_time_cust as (select count(order_id) Total_cust, cust_id from rest_order group by cust_id having Total_cust = 1)
select *, row_number() over() from rest_order where cust_id in (select cust_id from one_time_cust);

-- CHURN ANALYSIS VIEW
create view churn_Analysis2 as (select 'One_Time_customers' as customer_type, count(distinct cust_id) Cust_count, Avg(delivery_time) Avg_del_time, avg(delivery_ratings) Avg_Drating, 
avg(rest_ratings) Avg_rest_ratings, avg(rest_reviews) Avg_Rest_Review, avg(delivery_fee) Avg_Delfee, avg(rest_delivery_time) Avg_deltime
 from one_time_analysis
 Union all
 select 'Repeated_customers'as customer_type, count(distinct cust_id) RC, Avg(delivery_time) Avg_del_time_RC, avg(delivery_ratings) Avg_Drating_RC, 
 avg(rest_ratings) Avg_rest_ratings_RC, avg(rest_reviews) Avg_Rest_Review_RC, avg(delivery_fee) Avg_Delfee_RC, avg(rest_delivery_time) Avg_deltime_RC
 from repeated_cust);

create or replace view order_payment as (select o.cust_id as order_cust_id,o.order_id as orders_id, o.order_date, o.Final_amount, 
p.cust_id, p.amount as pay_amount, p.payment_date, payment_status
from orders o join payments p on o.payment_id = p.payment_id);

select cust_id, year(order_date), month(order_date), day(order_date), year(payment_date), month(payment_date), day(payment_date) 
from order_payment order by year(order_date),month(order_date), day(order_date);

select * from order_payment;

select 
case
    when payment_date >='2024-04-01' and payment_date <='2025-03-31' then 'FY2024-25'
    else 'Others'
end Revenue_year,
sum(pay_amount) Real_Revenue from order_payment 
group by Revenue_year;

select 
case
    when order_date >= '2024-04-01' and order_date <='2025-03-31'
    then 'FY2024-25'
    else 'Others'
end Revenue_year,
count(distinct orders_id) Total_orders from order_payment group by revenue_year;

select 
case
    when order_date >= '2024-04-01' and order_date <='2025-03-31'
    then 'FY2024-25'
    else 'Others'
end Revenue_year,
sum(pay_amount) Revenue from order_payment
where payment_status = 'Success' group by revenue_year;































