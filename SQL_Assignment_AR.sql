-- Homework Assignment

USE sakila;

-- 1a. Display the first and last names of all actors from the table 'actor'

select (first_name), (last_name)  FROM actor
 

-- 1b. Displaay the first and last name of each actor in a single column in upper case letter

select (first_name)	, (last_name) , CONCAT_WS('', first_name,' ', last_name) As Full_Name
from actor;


-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

select actor_id As ID, first_name, last_name 
from actor
where first_name like 'Joe%';
   
   
-- 2b. Find all actors whose last name contain the letters `GEN`:

select actor_id As ID, first_name, last_name 
from actor
where last_name like '%Gen%';

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:

select last_name, first_name
from actor
where last_name like '%LI%';
   
   
-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:   
   
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh','China');
   
 --  3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).

alter table actor
add column description BLOB ; 


-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.

alter table actor
drop column description ; 

-- 4a. List the last names of actors, as well as how many actors have that last name.

select last_name, count(*)
from actor
group by last_name
having count(*) >0; 

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

select last_name, count(*)
from actor
group by last_name
having count(*) >1; 

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.

update actor
set 
	first_name = 'HARPO'
where 
	first_name = 'GROUCHO' AND
    last_name = 'WILLIAMS';

select first_name, last_name from actor
where first_name = 'HARPO';

* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. 
   
   update actor
set 
	first_name = 'GROUCHO'
where 
	first_name = 'HARPO' AND
    last_name = 'WILLIAMS';

select first_name, last_name from actor
where first_name = 'GROUCHO';
   
    
   5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
   
   SHOW CREATE TABLE address
   
   mysql> SHOW CREATE TABLE t\G
*************************** 1. row ***************************
       Table: t
Create Table: CREATE TABLE `t` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `s` char(60) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1

create table address_new (   
	address_id smallint(5) NOT NULL, UN AI PK, 
	address varchar(50) NOT NULL,
	address2 varchar(50) NOT NULL, 
	district varchar(20) NOT NULL,
	city_id smallint(5) NOT NULL, UN 
	postal_code varchar(10) NOT NULL,
	phone varchar(20) NOT NULL,
	location geometry 
	last_update timestamp
);

  * Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html](https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html)
  
  * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

select
	first_name,
    last_name,
    address
from
	staff
		inner join
	address using (address_id);


-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.

select
	first_name,
    last_name,
    sum(amount)
from
	staff
		inner join
	payment using (staff_id)
 where payment_date between '2005-08-01' and '2005-08-31';
    
-- select payment_date from payment;   


-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

select 
	title,
   count(actor_id) as total_actors 
from 
	film
		inner join
	film_actor using (film_id)
group by title
order by total_actors;


-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

select 
	title,
 	count(inventory_id) as total_inventory
from 
	film
		inner join
	inventory using (film_id)
 group by title 
having title like '%Hunchback Impossible%' ;



--- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

  --- [Total amount paid](Images/total_payment.png) 
  
  select 
	first_name,
    last_name,
    sum(amount) as Total_Paid
   from 
	payment
		inner join
	customer using (customer_id)
group by first_name
order by last_name;
  
   
--   7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

select 
	title as Title from film
where 
	title like 'K%' or title like 'Q%';
from films;




(select 
	title as Title
from 
	film
where 
	title like 'K%' or title like 'Q%')

	 
select name as Language
from language
where name = 'English'
from
    (select 
	title as Title
	from 
		film
	where 
		title like 'K%' or title like 'Q%');
 


* 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

select * from actor
where actor_id in
	(select actor_id from film_actor
    where film_id =
		(select film_id from film 
		where title = 'Alone Trip'));
		



-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

select concat(c.first_name, ' ', c.last_name) as 'Name', c.email as 'E_mail' 
from customer as c
join address as a on c.address_id = a.address_id
join city as cy on a.city_id = cy.city_id
join country as ct on ct.country_id = cy.country_id
where ct.country = 'Canada';


-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.

select f.title as 'Movie Title'
from film as f
join film_category as fc on fc.film_id = f.film_id
join category as c on c.category_id = fc.category_id
where c.name = 'Family';



-- 7e. Display the most frequently rented movies in descending order. 
   
   select f.title as 'Movie Title', count(r.rental_date) as 'No of times rented'
   from film as f
   join inventory as i on i.film_id = f.film_id
   join rental as r on r.inventory_id = i.inventory_id
   group by f.title
   order by count(r.rental_date) desc; 
   
  
   
-- 7f. Write a query to display how much business, in dollars, each store brought in.

-- sales_by_store is a view.
-- without Id.

select store as 'Store', total_sales as 'Total Sales' from sales_by_store;
-- with Id.
select concat(c.city,',  ',cy.country) as 'Store', s.store_id as 'Store ID', sum(p.amount) as 'Total Sales'
from payment as p
join rental as r on r.rental_id = p.rental_id
join inventory as i on i.inventory_id = r.inventory_id
join store as s on s.store_id = i.store_id
join address as a on a.address_id = s.address_id
join city as c on c.city_id = a.city_id
join country as cy on cy.country_id = c.country_id
group by s.store_id;

select * from sales_by_store



-- 7g. Write a query to display for each store its store ID, city, and country.

select s.store_id as 'Store ID', c.city as 'City', cy.country as 'Country'
from store as s
join address as a on a.address_id = s.address_id
join city as c on c.city_id = a.city_id
join country as cy on cy.country_id = c.country_id
order by s.store_id;


--  7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select c.name as 'Film', sum(p.amount) as 'Gross Renevue'
from category as c
join film_category as fc on fc.category_id = c.category_id
join inventory as i on i.film_id = fc.film_id
join rental as r on r.inventory_id = i.inventory_id
join payment as p on p.rental_id = r.rental_id
group by c.name
order by sum(p.amount) desc
limit 5;


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.


create view Top_Five_Genres_by_Gross_Revenue as
select c.name as 'Film', sum(p.amount) as 'Gross Renevue'
from category as c
join film_category as fc on fc.category_id = c.category_id
join inventory as i on i.film_id = fc.film_id
join rental as r on r.inventory_id = i.inventory_id
join payment as p on p.rental_id = r.rental_id
group by c.name
order by sum(p.amount) desc
limit 5;



-- 8b. How would you display the view that you created in 8a?

select * 
from Top_Five_Genres_by_Gross_Revenue;


-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
   
   drop view Top_Five_Genres_by_Gross_Revenue;
   
   
   
   
   