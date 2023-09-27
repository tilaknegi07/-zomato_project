drop table if exists  goldusers_signup;
CREATE TABLE goldusers_signup (
    userid integer,
    gold_signup_date date
);
INSERT INTO goldusers_signup (userid, gold_signup_date) 
VALUES 
    (1, '2017-09-22'),
    (3, '2017-04-21');
SELECT * FROM goldusers_signup;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    userid integer,
    signup_date date
);
INSERT INTO users (userid, signup_date) 
VALUES 
    (1, '2014-09-02'),
    (2, '2015-01-15'),
    (3, '2014-04-11');
	DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
    userid integer,
    created_date date,
    product_id integer
);

INSERT INTO sales (userid, created_date, product_id) 
VALUES 
    (1, '2017-04-19', 2),
    (3, '2019-12-18', 1),
    (2, '2020-07-20', 3),
    (1, '2019-10-23', 2),
    (1, '2018-03-19', 3),
    (3, '2016-12-20', 2),
    (1, '2016-11-09', 1),
    (1, '2016-05-20', 3),
    (2, '2017-09-24', 1),
    (1, '2017-03-11', 2),
    (1, '2016-03-11', 1),
    (3, '2016-11-10', 1),
    (3, '2017-12-07', 2),
    (3, '2016-12-15', 2),
    (2, '2017-11-08', 2),
    (2, '2018-09-10', 3);
drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);
select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

--1 what is total  amount each customers spent on zomato?
 select a.userid ,sum(b.price)as total_amount_spent from sales a
 inner join product b on
 a.product_id =b.product_id
 group by userid
 
 -- how many days each customer visited zomoto
 select userid, count(distinct created_date ) as no_of_days_visited from sales 
 group by userid
 -- what is first product purchased by the user 
 select * from
 (select * , rank()over( partition by userid order by created_date asc) from sales)a
 where rank =1
 
 -- what is most purchased item by customers and how many time it has been purchased

select  userid , count(product_id) as cte from sales where product_id=
(select  product_id  from sales group by product_id order by  count(product_id) desc 
 limit 1)
 group by userid
 
 -- which iten is most popular item for each customers
 select * from
 (select *, rank()over (partition by userid order by cte desc ) from
 (select userid, product_id,count(product_id)as cte from sales
 group by userid,product_id) a)b
 where rank=1
 
 -- which item was purchased first bt the customers after becoming they bcom a member
select b.* from 
( select c.* ,rank()over(partition by userid  order by created_date)from
( select a.userid, a.created_date,a.product_id,b.gold_signup_date from sales a
  inner join  goldusers_signup b on
  a.userid=b.userid
  where a. created_date> b.gold_signup_date)c)b
  where rank=1
  
 -- what item was puechased by the customer before becomming the member
  select b.* from 
( select c.* ,rank()over(partition by userid  order by created_date desc)from
( select a.userid, a.created_date,a.product_id,b.gold_signup_date from sales a
  inner join  goldusers_signup b on
  a.userid=b.userid
  where a. created_date< b.gold_signup_date)c)b
  where rank=1
  
  --what is the total order and amount sepent by the customer before becoming a member
 
 select userid ,count(created_date),sum(price) from
 (select c.*,d.price from
  (select a.userid, a.created_date,a.product_id,b.gold_signup_date from sales a
  inner join  goldusers_signup b on
  a.userid=b.userid
  where a. created_date< b.gold_signup_date) c
  inner join  product d on
  c.product_id=d.product_id)e
  group by userid

-- if buying each product generates point for ex 5rs=2 zomoto point and each product has different purchasing
  -- point for ex p1 5rs= 1 zomato point, p2 10rs= 5zomato point and p3 5rs =1 zomato point
    -- calculate the point collected by each cutomers and for which product most point has been give till now
 
 select userid,sum(total_points)*2.5 total_money_erned from
 (select e.*,cte/points as total_points from
 (select k.*,Case when product_id=1 then 5
  when product_id=2 then 2
  when product_id=3 then 5 else 0 end as points
  from
  (select c.userid,c.product_id ,sum(c.price) cte from
  (select a.userid ,a.product_id,b.price,b.product_name from sales a
  inner join product b on
  a.product_id=b.product_id)c
  group by c.userid,c.product_id)k)e)q
  group by userid
 
      
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  








