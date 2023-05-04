-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(*)
FROM inventory
JOIN film ON inventory.film_id = film.film_id
WHERE film.title = 'Hunchback Impossible';
-- There are 6 copies available

-- List all films whose length is longer than the average of all the films.
SELECT title, length FROM film
WHERE length > (
SELECT AVG(length) FROM film);

-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT actor.first_name, actor.last_name FROM actor
WHERE actor.actor_id IN (
SELECT film_actor.actor_id FROM film_actor
WHERE film_actor.film_id = (
SELECT film.film_id FROM film
WHERE film.title = 'Alone Trip'));
/* Name of all the actors  
'ED', 'CHASE'
'KARL', 'BERRY'
'UMA', 'WOOD'
'WOODY', 'JOLIE'
'SPENCER', 'DEPP'
'CHRIS', 'DEPP'
'LAURENCE', 'BULLOCK'
'RENEE', 'BALL'*/

/* Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as family films.*/
SELECT film.title FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

/* Get name and email from customers from Canada using subqueries. 
Do the same with joins. Note that to create a join,
you will have to identify the correct tables with their primary keys and foreign keys, 
that will help you get the relevant information.*/
SELECT first_name, last_name, email FROM customer
WHERE address_id IN (
SELECT address_id FROM address
WHERE city_id IN (
SELECT city_id FROM city
WHERE country_id = (
SELECT country_id FROM country
WHERE country = 'Canada' )));
-- Joins
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';

-- Which are films starred by the most prolific actor? 
/* Most prolific actor is defined as the actor that has acted in the most number of films. 
First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.*/
SELECT first_name, last_name FROM actor
WHERE actor_id IN(
SELECT actor_id FROM(
SELECT actor_id, count(film_id) from film_actor
GROUP BY actor_id
ORDER BY count(film_id) DESC
LIMIT 1) as sub1);

SELECT * from film
WHERE film_id in(
SELECT film_id from film_actor
WHERE actor_id in (
SELECT actor_ID from actor
WHERE first_name = 'GINA' AND last_name = 'DEGENERES'));

/* Films rented by most profitable customer. 
You can use the customer table and payment table to find
 the most profitable customer ie the customer that has made the largest sum of payments */
SELECT film.title
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.customer_id = (
SELECT customer.customer_id FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY SUM(payment.amount) DESC 
LIMIT 1);

-- Customers who spent more than the average payments.
SELECT * from customer 
WHERE customer_id IN(
SELECT customer_id from(
SELECT customer_id, sum(amount) as total_spend from payment
GROUP BY customer_id
HAVING sum(amount) > 112.53) as sub1
);

















