

USE sakila;


SELECT *
FROM film;

SELECT *
FROM actor;


-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title AS movie_title
FROM film;


-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".


SELECT title AS movie_title
FROM film
WHERE rating = 'PG-13';


-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title,description 
FROM film
WHERE description LIKE '%amazing%';


-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title
FROM film
WHERE length > 120


-- 5. Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame nombre_actor y contenga nombre y apellido.

SELECT *
FROM actor;

SELECT DISTINCT CONCAT(first_name, ' ', last_name) AS actor_name
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT CONCAT(first_name, ' ', last_name) AS actor_name
FROM actor
WHERE last_name REGEXP 'Gibson';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT CONCAT(first_name, ' ', last_name) AS actor_name    
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".

SELECT *
FROM film;

SELECT title
FROM film
WHERE rating NOT IN('R','PG-13');


-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT rating, COUNT(film_id) AS movie_total
FROM film
GROUP BY rating;


-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente
-- y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT *
FROM customer;

SELECT *
FROM rental;

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS rental_total
FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id;


-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT *
FROM category;

SELECT *
FROM film_category;

SELECT *
FROM inventory;

SELECT *
FROM rental;

SELECT c.name AS category, COUNT(r.rental_id) AS rental_total
FROM category c
INNER JOIN film_category fc
ON c.category_id = fc.category_id
INNER JOIN inventory i
ON fc.film_id = i.film_id
INNER JOIN rental r  -- Joins the inventory table with the rental table
ON i.inventory_id = r.inventory_id  -- Matches inventory items with their rental records
GROUP BY c.name;  -- Groups the results by category name to calculate the total rentals

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT rating, AVG(length) AS duration
FROM film
GROUP BY rating;


-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT *
FROM actor;

SELECT *
FROM film_actor;

SELECT *
FROM film;

SELECT *
FROM category;

SELECT a.first_name, a.last_name,f.title
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
INNER JOIN film f
ON fa.film_id = f.film_id
WHERE f.title = 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%'; 

-- 15. ¿Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor?

SELECT *
FROM actor;

SELECT *
FROM film_actor;

SELECT a.first_name,a.last_name AS Name 
FROM actor a
LEFT JOIN film_actor fa  -- LEFT JOIN to include all actors, even if they have no films
ON a.actor_id = fa.actor_id  -- Matches actors with their respective film records
WHERE fa.actor_id IS NULL;  -- Filters to find actors who have not appeared in any film


-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT DISTINCT title
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT f.title, c.name
FROM film f
INNER JOIN film_category fc  -- Joins the film table with the film_category table
ON f.film_id = fc.film_id
INNER JOIN category c   -- Joins the film_category table with the category table
ON fc.category_id = c.category_id
WHERE c.name = 'Family';


-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT *
FROM actor;

SELECT *
FROM film_actor;

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS movie_total
FROM actor a
INNER JOIN film_actor fa  -- Joins the actor table with the film_actor table
ON a.actor_id = fa.actor_id  -- Matches each actor with their corresponding movies
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) > 10; -- 'HAVING' is used to filter the previously generated group

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title, rating, length
FROM film
WHERE rating = 'R' AND length > 120; 

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT *
FROM film;

SELECT *
FROM category;

SELECT *
FROM film_category;


SELECT c.name AS category, AVG(f.length) AS Average_length -- Calculates the average length of films
FROM category c
INNER JOIN film_category fc  -- Joins the category table with the film_category table
ON c.category_id = fc.category_id  
INNER JOIN film f  -- Joins the film_category table with the film table
ON fc.film_id = f.film_id
GROUP BY c.category_id  -- Groups the results by category to calculate averages for each
HAVING Average_length > 120;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT *
FROM actor;

SELECT *
FROM film;

SELECT a.first_name,a.last_name, COUNT(fa.film_id) AS movie_total
FROM actor a
INNER JOIN film_actor fa   -- Joins the actor table with the film_actor table
ON a.actor_id = fa.actor_id  -- Matches actors with their respective movie records
GROUP BY a.actor_id  -- Groups the results by actor to calculate the movie count for each
HAVING COUNT(fa.film_id) >= 5;


-- 22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. 
-- Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días 
-- y luego selecciona las películas correspondientes. 
-- Pista: Usamos DATEDIFF para calcular la diferencia entre una fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final)

SELECT *
FROM film;

SELECT *
FROM rental;

SELECT *
FROM inventory;


SELECT f.title
FROM film f
WHERE f.film_id IN (  -- Filters to include only films that match the IDs in the subquery
		SELECT i.film_id   -- Subquery: retrieves the film IDs associated with rentals
        FROM rental r
		INNER JOIN inventory i  -- Joins the rental table with the inventory table
        ON i.inventory_id = r.inventory_id  -- Matches inventory items with their rental records
        WHERE DATEDIFF(r.return_date, r.rental_date) > 5 -- Calculates the difference in days between return_date and rental_date; includes only rentals with more than 5 days
);

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
-- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT *
FROM film_actor;

SELECT *
FROM category;

SELECT *
FROM film_category;

SELECT *
FROM actor;


SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (  -- Excludes actors who appear in the subquery
	SELECT fa.actor_id -- Subquery: retrieves IDs of actors who acted in "Horror" movies
    FROM film_actor fa
    INNER JOIN film_category fc  
    ON fa.film_id = fc.film_id -- Joins films with their categories
    INNER JOIN category c
    ON fc.category_id = c.category_id -- Joins categories with their descriptions
    WHERE c.name = 'Horror'
);
    
    
    -- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film con subconsultas.
    
    SELECT *
	FROM film;
    
    SELECT *
	FROM film_category;
    
    SELECT *
	FROM category;
    
    
    SELECT f.title, f.length
    FROM film f
    WHERE f.film_id IN ( -- Includes only films that match the IDs in the subquery
		SELECT fc.film_id  -- Subquery: retrieves film IDs from the "Comedy" category
        FROM film_category fc
        INNER JOIN category c 
        ON fc.category_id = c.category_id  -- Joins film categories with their descriptions
        WHERE c.name = 'Comedy'
)   AND f.length > 180; 
    
        
-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. 
-- La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos. 
-- Pista: Podemos hacer un SELF/AUTO JOIN de la tabla film_actor consigo misma, poniendole un alias diferente.


    SELECT *
    FROM film_actor;

	SELECT *
    FROM actor;


SELECT
CONCAT(a1.first_name, ' ' , a1.last_name) AS first_actor,
CONCAT(a2.first_name, ' ' , a2.last_name) AS second_actor,
COUNT(fa1.film_id) AS movie_total -- Counts the total number of movies they acted in together
FROM film_actor fa1
JOIN film_actor fa2    -- Self-join on the film_actor table to find pairs of actors in the same movie
ON fa1.film_id = fa2.film_id   -- Matches movies in which both actors appeared
INNER JOIN actor a1  -- Links the first actor to their details in the actor table
ON a1.actor_id = fa1.actor_id
JOIN actor a2         -- Self-join on the actor table to link the second actor's details
ON a2.actor_id = fa2.actor_id
WHERE a1.actor_id < a2.actor_id  -- Avoids duplicate pairs 
GROUP BY a1.actor_id, a2.actor_id  -- Groups by unique pairs of actors
HAVING COUNT(fa1.film_id) > 0;   -- Ensures only pairs with at least one movie together are included




