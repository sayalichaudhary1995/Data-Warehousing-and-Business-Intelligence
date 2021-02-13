/*1.1. Contribution of Countries & Cities (in hierarchy) by rental amount
Check it - is country and city different
*/

select sum(payment.amount) as 'rental amount' , city.city , country.country from payment 
join customer on payment.customer_id = customer.customer_id
join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id
group by city
order by  sum(payment.amount) ;

/*1.2. Rental amounts by countries for PG & PG-13 rated films 
*/

select sum(payment.amount) as 'rental amount' , country.country from payment 
join rental on rental.rental_id = payment.rental_id
join customer on rental.customer_id = customer.customer_id
join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id
join inventory on  rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
where film.rating IN ( 'PG' , 'PG-13')
group by country;


/*1.3. Top 20 cities by number of customers who rented 
Not sure - need to check it again
*/

select count(customer.customer_id) as 'customer_count' , city.city from customer 
join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
join rental on customer.customer_id = rental.customer_id
group by city.city
order by customer_count desc
limit 20;

/*1.4. Top 20 cities by number of customers who rented 
*/
select count(rental.rental_id) as 'rental_count' , city.city from rental
join customer on customer.customer_id = rental.customer_id 
join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
group by city.city
order by rental_count desc
limit 20;

/*1.5. Rank cities by average rental cost
*/
SELECT *, row_number() over () as 'Rank' FROM (select sum(payment.amount) / count(payment.rental_id) as 'average_amount' ,
city.city 
 from payment
join customer on customer.customer_id = payment.customer_id 
join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
group by city.city 
order by average_amount desc) A;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*2.1. Film categories by rental amount
*/
SELECT *, row_number() over () as 'Rank' FROM (
select category.name  , sum(payment.amount) as 'rental_amount' , count(rental.rental_id) as 'rental_quantity' from payment
join rental on payment.rental_id = rental.rental_id
join inventory on rental.inventory_id = inventory.inventory_id
join film_category on film_category.film_id = inventory.film_id
join category on category.category_id = film_category.category_id
group by category.name
order by rental_amount desc ) A ;


/*2.2. Film categories by rental amount
*/
SELECT *, row_number() over () as 'Rank' FROM (
select category.name  , sum(payment.amount) as 'rental_amount' from payment
join rental on payment.rental_id = rental.rental_id
join inventory on rental.inventory_id = inventory.inventory_id
join film_category on film_category.film_id = inventory.film_id
join category on category.category_id = film_category.category_id
group by category.name
order by rental_amount desc ) A ;

/*2.3. Film categories by rental amount
*/

SELECT *, row_number() over () as 'Rank' FROM (
select category.name  , sum(payment.amount) / count(rental.rental_id) as 'average_rental_amount' from payment
join rental on payment.rental_id = rental.rental_id
join inventory on rental.inventory_id = inventory.inventory_id
join film_category on film_category.film_id = inventory.film_id
join category on category.category_id = film_category.category_id
group by category.name
order by average_rental_amount desc ) A ;

/*2.4. Contribution of Film Categories by number of customers
*/
select category.name , count(customer.customer_id) as 'customer_count' from category
join film_category on category.category_id = film_category.category_id
join inventory on  film_category.film_id = inventory.film_id
join rental on rental.inventory_id = inventory.inventory_id
join customer on rental.customer_id = customer.customer_id
group by category.name;


/*2.5. Contribution of Film Categories by rental amount
*/
select category.name , sum(payment.amount) as 'Rental Amount'  from category
join film_category on category.category_id = film_category.category_id
join inventory on  film_category.film_id = inventory.film_id
join rental on rental.inventory_id = inventory.inventory_id
join payment on payment.rental_id = rental.rental_id
group by category.name;

----------------------------------------------------------------------------------------------------------------------------------------------
/*3.1. List Films with rental amount, rental quantity, rating, rental rate, replacement cost and category name 
*/


select  film.title , sum(payment.amount) 'rental_amount' , count(rental.rental_id) 'rental_quantity' , rating ,rental_rate , replacement_cost , category.name as 'category' from  film
join film_category on film.film_id = film_category.film_id
join category on film_category.category_id = category.category_id
join inventory on inventory.film_id = film.film_id
join rental on rental.inventory_id = inventory.inventory_id
join payment on payment.rental_id = rental.rental_id
group by film.title;

/*3.2. List top 10 Films by rental amount (ranked) 
*/

SELECT *, row_number() over () as 'Rank' FROM (
select  film.title , sum(payment.amount) 'rental_amount' from  film
join inventory on inventory.film_id = film.film_id
join rental on rental.inventory_id = inventory.inventory_id
join payment on payment.rental_id = rental.rental_id
group by film.title
order by rental_amount desc 
limit 10) A;

/*3.3. List top 20 Films by number of customers(ranked) 
*/
SELECT *, row_number() over () as 'Rank' FROM (
select  film.title , count(rental.customer_id) 'customer_count' from  film
join inventory on inventory.film_id = film.film_id
join rental on rental.inventory_id = inventory.inventory_id
group by film.title
order by customer_count desc 
limit 20 ) A;

/*3.4. List Films with the word “punk” in title with rental amount and number of customers 
*/
select title , sum(payment.amount) as 'rental_amount' , count(rental.customer_id) as 'number_of_customers' from film
join inventory on inventory.film_id = film.film_id
join rental on rental.inventory_id = inventory.inventory_id
join payment on payment.rental_id = rental.rental_id
where title like '%punk%'
group by title;

/*3.5. Contribution by rental amount for films with a documentary category
*/
select title , sum(payment.amount) as 'rental_amount'  from film
join inventory on inventory.film_id = film.film_id
join rental on rental.inventory_id = inventory.inventory_id
join payment on payment.rental_id = rental.rental_id
join film_category on film.film_id = film_category.film_id
join category on film_category.category_id = category.category_id
where category.name= 'documentary'
group by title;

------------------------------------------------------------------------------------------------------------------------------------------------------

/*4.1. List Customers (Last name, First Name) with rental amount, rental quantity, active status, country and city
*/

select concat(customer.last_name , ', ', customer.first_name)  as 'name' , count(rental.rental_id) as 'quantity',
sum(payment.amount) as 'rental_amount' , country.country , city.city , customer.active
from customer 
join rental on customer.customer_id = rental.customer_id
join payment on payment.rental_id = rental.rental_id
join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id
group by name;



/*4.2. List top 10 Customers (Last name, First Name) by rental amount (ranked) for PG & PG-13 rated films
*/

SELECT *, row_number() over () as 'Rank' FROM (
select concat(customer.last_name , ', ', customer.first_name)  as 'name' , 
sum(payment.amount) as 'rental_amount' 
from customer 
join rental on customer.customer_id = rental.customer_id
join payment on payment.rental_id = rental.rental_id
join inventory on  rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
where film.rating IN ( 'PG' , 'PG-13')
group by name
order by rental_amount desc
limit 10 ) A;

/*4.3.  Contribution by rental amount for customers from France, Italy or Germany
*/
select concat(customer.last_name , ', ', customer.first_name)  as 'name' , 
sum(payment.amount) as 'rental_amount' 
from customer 
join rental on customer.customer_id = rental.customer_id
join payment on payment.rental_id = rental.rental_id
join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id
where country.country IN ('France' , 'Germany' , 'Italy')
group by name
order by rental_amount desc;

/*4.4.  List top 20 Customers (Last name, First Name) by rental amount (ranked) for comedy films
*/

SELECT *, row_number() over () as 'Rank' FROM (
select concat(customer.last_name , ', ', customer.first_name)  as 'fullname' , 
sum(payment.amount) as 'rental_amount' 
from customer 
join rental on customer.customer_id = rental.customer_id
join payment on payment.rental_id = rental.rental_id
join inventory on  rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film.film_id = film_category.film_id
join category on film_category.category_id = category.category_id
where category.name= 'comedy'
group by fullname
order by rental_amount desc
limit 20 ) A ;

/*4.5.  List top 10 Customers (Last name, First Name) from China by rental amount (ranked) for films that have
replacement costs greater than $24
*/

SELECT *, row_number() over () as 'Rank' FROM (
select concat(customer.last_name , ', ', customer.first_name)  as 'fullname' , 
sum(payment.amount) as 'rental_amount' 
from customer 
join rental on customer.customer_id = rental.customer_id
join payment on payment.rental_id = rental.rental_id
join inventory on  rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id
where film.replacement_cost > 24 and country =  'china'
group by fullname
order by rental_amount desc
limit 10 ) A ;
