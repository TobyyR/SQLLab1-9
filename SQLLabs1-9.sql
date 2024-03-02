use sakila;

## lab 1 #############################################################################

select * from actor;
select * from film;
select * from customer;

select title from film;

select distinct name as language from language;

select count(store_id) from store;

select count(staff_id) from staff;

select first_name from staff;

## lab 2 ############################################################################

select * 
	from actor 
		where first_name = "Scarlett";
        
select * 
	from actor 
		where last_name = "Johansson";
 

select count(rental_id) 
	from rental
		where return_date is NULL;
        
select count(rental_id) 
	from rental
		where return_date is not NULL;
        
        
select * from film;
select 
	min(rental_duration) as shortest_rental, max(rental_duration) as longest_rental
		from film;

select 
	min(length) as min_duration, max(length) as max_duration
		from film;
        
select 
	avg(length)
		from film;

select 
    concat(
        floor(avg(length) / 60), 
        ' hours, ', 
        avg(length) % 60, 
        ' minutes'
    ) as average_duration
from film;

select count(distinct film_id) 
	from film
		where length > "180";

select * from customer;
select 
    concat(customer.first_name, ' ', (customer.last_name), ' - ', lower(customer.email)) as formatted
		from customer;
        
select 
	max(char_length(title)) as longest_title
		from film;
        

## lab 3 #################################################################################################       

select count(distinct last_name) from actor;

select * from film;
select count(distinct language_id) from film;

select count(film_id)
	from film
		where rating = "PG-13";
        
select title, max(length), release_year
	from film
		group by title, release_year
        having release_year = "2006"
		order by max(length) desc
			limit 10;
            
select datediff("2006-02-23", "2005-05-24");

select *,
		month(rental_date) as rental_month,
		dayname(rental_date) as rental_weekday,
		case 
			when dayofweek(rental_date) = 1 or dayofweek(rental_date) = 7 then 'weekend'
			else 'workday'
				end as day_type
					from rental
						limit 20;

select count(rental_id)
	from rental
		where rental_date >= "2006-02-1";
        


## lab 4 #####################################################################################

select distinct rating from film;

select distinct release_year from film;

select title
	from film
		where title like "%ARMAGEDDON%";
        
select title
	from film
		where title like "%APOLLO%";
        
select title
	from film
		where title like "%APOLLO";
        
select title
	from film
		where title like "%DATE%";
        
select title 
	from film
		order by length(title) desc
			limit 10;
            
select * 
	from film
		order by length desc
			limit 10;
            
select count(*)
	from film
		where special_features like "%Behind the Scenes%";
        
select title, release_year
			from film
				order by title, release_year desc;
                
	
## lab 5 ##################################################################################

alter table staff
	drop column picture;
  
  
select * from customer where last_name = "Sanders";
INSERT INTO staff (first_name, last_name, email, address_id, store_id, active, username, password, last_update)
VALUES ('Tammy', 'Sanders', 'tammy.sanders@example.com', 79, 1, 1, 'tammy_sanders', 'password', NOW());


select * from rental;
select * from customer where last_name = "Hunter"; -- customer_id 130
select * from film where title = "Academy Dinosaur"; -- film_id 1
select * from inventory where film_id = "1"; -- inventory_id 1
select * from staff where last_name = "Hillyer"; -- staff_id 1
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES (NOW(), 1, 130, NULL, 1);


select * from customer;
create table deleted_users (
    deleted_user_id int auto_increment PRIMARY KEY,
    customer_id int,
    email varchar(255),
    deletion_date timestamp default current_timestamp
);

insert into deleted_users (customer_id, email)
	select customer_id, email
		from customer
			where active = 0;

select * from deleted_users;

delete from customer
	where active = 0; -- safe mode on, I dont want to disable it so to not delete the database by accident :D 
    
select count(active) 
	from customer 
		where active = 0;
        

## lab 6 #########################################################################################################################

CREATE TABLE `films_2020` (
  `film_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `release_year` year(4) DEFAULT NULL,
  `language_id` tinyint(3) unsigned NOT NULL,
  `original_language_id` tinyint(3) unsigned DEFAULT NULL,
  `rental_duration` varchar(255) DEFAULT NULL,
  `rental_rate` varchar(255) DEFAULT NULL,
  `length` smallint(5) unsigned DEFAULT NULL,
  `replacement_cost` varchar(255) DEFAULT NULL,
  `rating` enum('G','PG','PG-13','R','NC-17') DEFAULT NULL,
  PRIMARY KEY (`film_id`),
  CONSTRAINT FOREIGN KEY (`original_language_id`) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1003 DEFAULT CHARSET=utf8;

select * from films_2020;

update films_2020
	set 
		rental_duration = 3,
		rental_rate = 2.99,
		replacement_cost = 8.99; -- safe mode on, I dont want to disable it so to not break the database by accident :D
	
    
## lab 7 ###############################################################################################

select last_name, group_concat(first_name) AS first_names
	from actor
		group by last_name
			having count(*) = 1;

select last_name, group_concat(first_name) AS first_names
	from actor
		group by last_name
			having count(*) > 1;                

select staff_id, count(*)
	from rental
		group by staff_id;
        
select release_year , count(*) as films_released
	from film 
		group by release_year;

select rating, count(*)
	from film
		group by rating;
        
select rating, round(avg(length), 2) as mean_length
	from film
		group by rating;
        
select rating, round(avg(length), 2) as mean_length
	from film
		group by rating
			having mean_length > 120;


## lab 8 ###################################################################################################


select title, length, rank() over(order by length desc) as ranking
	from film
		where length is not NULL and length >0;
        
select title, length, rating, rank() over(order by length desc) as ranking
	from film
		where length is not NULL and length >0
        order by rating;
        
select c.name as category, count(fc.film_id) as number_of_films
	from category c
		join film_category fc on c.category_id = fc.category_id
			group by c.category_id, c.name
				order by number_of_films desc;

select a.actor_id, a.first_name, a.last_name, count(fa.film_id) as num_appearances
	from actor a
		join film_actor fa on a.actor_id = fa.actor_id
			group by a.actor_id, a.first_name, a.last_name
				order by num_appearances desc
				limit 1;

select c.customer_id, c.first_name, c.last_name, count(r.rental_id) as num_rentals
	from customer c
		join rental r on c.customer_id = r.customer_id
			group by c.customer_id, c.first_name, c.last_name
				order by num_rentals desc
				limit 1;
                
select f.title as film_title, count(r.rental_id) as num_rentals
	from film f 
		join inventory i on f.film_id = i.film_id
			join rental r on i.inventory_id = r.inventory_id
				group by f.title
					order by num_rentals desc
					limit 1;
                    
	
## lab 9 ####################################################################################


create table rentals_may as
	select *
		from rental
			where month(rental_date) = 5;
select * from rentals_may;

create table rentals_june as
	select *
		from rental
			where month(rental_date) = 6;
select * from rentals_june;

select customer_id, count(*)
	from rentals_may
		group by customer_id 
        order by count(*) desc;
        
select customer_id, count(*)
	from rentals_june
		group by customer_id
        order by count(*) desc;