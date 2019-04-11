Use sakila;

-- Question 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name 
FROM actor;

-- Question 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT
 CONCAT (
 UPPER (first_name),
 UPPER (last_name)
 ) as Actor_Name
FROM actor;

-- Question 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT first_name, last_name, actor_id
FROM actor
WHERE first_name = "Joe";

-- Question 2b Find all actors whose last name contain the letters `GEN`: 
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name like '%GEN%';

-- Question 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- Question 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China'); 

-- Question 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, 
-- as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor
ADD COLUMN description BLOB;

-- Question 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor
DROP COLUMN description; 

-- Question 4a. List the last names of actors, as well as how many actors have that last name. 
SELECT last_name, COUNT(last_name) 
FROM actor 
GROUP BY last_name; 

-- Question 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) 
FROM actor 
GROUP BY last_name 
HAVING COUNT(last_name) >= 2; 

-- Question 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor 
SET first_name = 'HARPO'
WHERE First_name = "Groucho" AND last_name = "Williams";

-- Question 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` 
-- was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.  
UPDATE actor 
SET first_name = 'GROUCHO'
WHERE actor_id = 172; 

-- Question 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- Question 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
-- Use the tables `staff` and `address`:
SELECT first_name, last_name, address
FROM staff s
INNER JOIN address a
ON s.address_id = a.address_id;  

-- Question 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT staff.first_name, staff.last_name, sum(payment.amount) 
FROM staff
INNER JOIN  payment 
ON staff.staff_id = payment.staff_id
GROUP BY staff.staff_id; 

-- Question 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT title, COUNT(actor_id)
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY title;

-- Question 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT title, 
COUNT(inventory_id)
FROM film f
INNER JOIN inventory i 
ON f.film_id = i.film_id
WHERE title = "Hunchback Impossible";

-- Question 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT c.first_name, c.last_name, sum(p.amount) AS `Total Paid`
FROM customer c
JOIN payment p 
ON c.customer_id= p.customer_id
GROUP BY c.last_name; 

-- Question 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title 
FROM film
WHERE language_id in
	(SELECT language_id 
	FROM language
	WHERE name = "English" )
AND (title LIKE "K%") OR (title LIKE "Q%");

-- Question 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT last_name, first_name
FROM actor
WHERE actor_id in
	(SELECT actor_id FROM film_actor
	WHERE film_id in 
		(SELECT film_id FROM film
		WHERE title = "Alone Trip"));

-- Question 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
SELECT c.first_name, c.last_name, c.email 
FROM customer c
JOIN address a 
ON (c.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id)
WHERE country.country= 'Canada';

-- Question 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as _family_ films. 
SELECT title, category
FROM film_list
WHERE category = 'Family';

-- Question  7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(f.film_id) AS count_of_rented_movies
FROM  film f
JOIN inventory i 
ON (f.film_id= i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
GROUP BY title 
ORDER BY count_of_rented_movies DESC;

-- Question 7f. Write a query to display how much business, in dollars, each store brought in.
 SELECT s.store_id, SUM(amount) AS 'Revenue'
 FROM payment p
 JOIN rental r
 ON (p.rental_id = r.rental_id)
 JOIN inventory i
 ON (i.inventory_id = r.inventory_id)
 JOIN store s
 ON (s.store_id = i.store_id)
 GROUP BY s.store_id;

-- Question 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country
FROM store s
JOIN address a
ON (s.address_id = a.address_id)
JOIN city cit
ON (cit.city_id = a.city_id)
JOIN country ctr
ON(cit.country_id = ctr.country_id);	

-- Question 7h. List the top five genres in gross revenue in descending order. 
SELECT c.name, SUM(p.amount) AS gross_revenue
FROM category AS c
INNER JOIN film_category AS fc
ON c.category_id = fc.category_id
INNER JOIN inventory AS i
ON fc.film_id = i.film_id
INNER JOIN rental AS r
ON i.inventory_id = r.inventory_id
INNER JOIN payment AS p
ON r.rental_id = p.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;

-- Question 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top5_genre_gross_revenue AS
SELECT c.name, SUM(p.amount) AS gross_revenue
FROM category AS c
INNER JOIN film_category AS fc
    ON c.category_id = fc.category_id
INNER JOIN inventory AS i
    ON fc.film_id = i.film_id
INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
INNER JOIN payment AS p
    ON r.rental_id = p.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5; 

-- Question 8b. How would you display the view that you created in 8a?
SELECT * FROM top5_genre_gross_revenue;

-- Question 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top5_genre_gross_revenue;


