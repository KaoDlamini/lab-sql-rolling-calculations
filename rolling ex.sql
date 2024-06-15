-- 1.Get number of monthly active customers.
select count(distinct(customer_id)) from sakila.rental

-- 2.Active users in the previous month.
with rentals_customer as (
select customer_id, 
		convert(rental_date,date) as rental_date,
		date_format(convert(rental_date,date), '%m') as month,
		date_format(convert(rental_date,date), '%Y') as year
	from sakila.rental
      order by customer_id
    )
    
select month,
		year,
        count(distinct(customer_id)) as Active_customers ,
        lag(count(distinct(customer_id))) over (order by month,year)as previous_month
from rentals_customer
group by month,year
    


-- 3.Percentage change in the number of active customers.
with rentals_customer as (
select customer_id, 
		convert(rental_date,date) as rental_date,
		date_format(convert(rental_date,date), '%m') as month,
		date_format(convert(rental_date,date), '%Y') as year
	from sakila.rental
      order by customer_id
    )
    
select month,
		year,
        count(distinct(customer_id)) as Active_customers ,
        lag(count(distinct(customer_id))) over (order by year,month)as previous_month,
       concat((((lag(count(distinct(customer_id))) over (order by year,month))- count(distinct(customer_id)))/ count(distinct(customer_id)))*100,"%") as Evolution
from rentals_customer
group by month,year
    
-- 4.Retained customers every month.

with rentals_customer as (
select customer_id, 
		convert(rental_date,date) as rental_date,
		date_format(convert(rental_date,date), '%m') as month,
		date_format(convert(rental_date,date), '%Y') as year
	from sakila.rental
    ) ,
    recurrent_customers as (select customer_id, 
										month,
                                        year,
                                        lag (year) over (partition by customer_id order by year,month) as prev_year,
                                        lag (month) over (partition by customer_id order by year,month) as prev_month
								from rentals_customer)

select year, month , count(customer_id) from recurrent_customers 
where month= prev_month+1 and year = prev_year
group by year, month

-- I AM NOT SURE I PROPERLY UNDERSTOOD THE QUESTION SO HERE IS MY SECOND ANSWER

with rentals_customer as (
select customer_id, 
		convert(rental_date,date) as rental_date,
		date_format(convert(rental_date,date), '%m') as month,
		date_format(convert(rental_date,date), '%Y') as year
	from sakila.rental
    ) ,
    recurrent_customers as (select customer_id, 
										month,
                                        year,
                                        lag (year) over (partition by customer_id order by year,month) as prev_year,
                                        lag (month) over (partition by customer_id order by year,month) as prev_month
								from rentals_customer)

select count(distinct((customer_id))) from recurrent_customers 
where year = '2005' and '2006' and month= '02'and'05' and '06'and'07'and '08'

