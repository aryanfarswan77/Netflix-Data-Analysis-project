-- 1.Count the number of movies vs Tvshows.
SELECT
	type,
	COUNT(*) AS total_content
FROM netflix
GROUP BY type;


--2. Find the most common rating for movies and TV shows.
SELECT 
	type,
	rating
FROM(
	SELECT 
		type,
		rating,
		COUNT(*),
		rank() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
	FROM netflix
	GROUP BY 1,2
)
WHERE 
	ranking =1;

--3. List all movies released in a specific year (e.g., 2020)
SELECT *
FROM netflix
WHERE 
	release_year=2020
	AND
	type='Movie';

--4. Find the top 5 countries with the most content on Netflix.

SELECT * 
FROM
(
	SELECT 
		UNNEST(STRING_TO_ARRAY(country, ',')) as country,
		COUNT(*) as total_content
	FROM netflix
	GROUP BY 1
)as t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5

--5. Identify the longest movie
SELECT *
FROM netflix
WHERE
	type='Movie'
	AND
	duration=(SELECT MAX(duration) FROM netflix);

--6. Find content added in the last 5 years

SELECT
*
FROM netflix
WHERE TO_DATE(date_added, 'DD/MM/YYYY') >= CURRENT_DATE - INTERVAL '5 years'

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT *
FROM
(

SELECT 
	*,
	UNNEST(STRING_TO_ARRAY(director, ',')) as director_name
FROM 
netflix
)
WHERE 
	director_name = 'Rajiv Chilaka'

--8. List all TV shows with more than 5 seasons
SELECT *
FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5

--9. Count the number of content items in each genre.
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1
	
--10.Find each year and the average numbers of content release in India on netflix return top 5 year with highest avg content release.
SELECT 
 	EXTRACT(YEAR FROM TO_DATE(date_added, 'DD/MM/YYYY')) AS year,
	 COUNT(*) AS yearly_content,
	 ROUND(
	 COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country='India')::numeric*100 ,2)
	 AS avearge_content_year
FROM netflix
WHERE country='India'
GROUP BY 1;
	