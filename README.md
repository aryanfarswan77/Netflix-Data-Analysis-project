# Netflix-Data-Analysis-project
<p align="center">
  <img src="https://github.com/aryanfarswan77/Netflix-Data-Analysis-project/blob/main/netflix.jpg?raw=true" alt="Netflix Logo" width="200"/>
  <br/>
  <strong>Netflix Data Analysis Project</strong>
</p>

# 📊 Netflix Data Analysis Using SQL and Tableau

## 📌 Overview

This project involves a comprehensive analysis of Netflix's movies and TV shows dataset using SQL. The objective is to extract valuable insights and answer key business questions related to content type, genre distribution, ratings, regional preferences, and more. Then I have  visualize all the insights and converted it into a dasboards for better understanding to our stakeholders using Tableau.

---

## 🎯 Objectives

- Analyze the distribution of content types (Movies vs. TV Shows)
- Identify the most common ratings for movies and TV shows
- List and analyze content based on release years, countries, and durations
- Explore and categorize content based on specific criteria and keywords.
- Visualize all the insights.

---

## 📁 Dataset

- **Source**: [Netflix Movies and TV Shows Dataset on Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows)
- **Schema**:

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix (
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
💼 Business Problems and SQL Solutions
1. Count the Number of Movies vs TV Shows.
    Objective: Determine the distribution of content types on Netflix.
```sql
SELECT
	type,
	COUNT(*) AS total_content
FROM netflix
GROUP BY type;
```
2.Find the Most Common Rating for Movies and TV Shows.
Objective: Identify the most frequently occurring rating for each type of content.
```sql
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
```
3. List All Movies Released in a Specific Year (e.g., 2020).
Objective: Retrieve all movies released in a specific year.
```sql
SELECT *
FROM netflix
WHERE 
	release_year=2020
	AND
	type='Movie';
```
4. Find the Top 5 Countries with the Most Content on Netflix.
Objective: Identify the top 5 countries with the highest number of content items.
```sql
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
```
5. Identify the Longest Movie.
Objective: Find the movie with the longest duration.
```sql
SELECT *
FROM netflix
WHERE
	type='Movie'
	AND
	duration=(SELECT MAX(duration) FROM netflix);
```
6. Find Content Added in the Last 5 Years.
Objective: Retrieve content added to Netflix in the last 5 years.
```sql
SELECT
*
FROM netflix
WHERE TO_DATE(date_added, 'DD/MM/YYYY') >= CURRENT_DATE - INTERVAL '5 years'
```
7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'.
Objective: List all content directed by 'Rajiv Chilaka'.
```sql
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
```
8. List All TV Shows with More Than 5 Seasons.
Objective: Identify TV shows with more than 5 seasons.
```sql
SELECT *
FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5
```
9. Count the Number of Content Items in Each Genre.
Objective: Count the number of content items in each genre.
```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1
```

10. Find Top 5 Years with Highest Average Content Release in India.
    
Objective: Calculate and rank years by the average number of content releases by India.
```sql
SELECT 
 	EXTRACT(YEAR FROM TO_DATE(date_added, 'DD/MM/YYYY')) AS year,
	 COUNT(*) AS yearly_content,
	 ROUND(
	 COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country='India')::numeric*100 ,2)
	 AS avearge_content_year
FROM netflix
WHERE country='India'
GROUP BY 1;
```

## 📊 Visualization Dashboard

Explore the interactive visualizations created from this analysis on [**Tableau Public**](https://public.tableau.com/app/profile/aryan.farswan/viz/Netflix_17483456418360/Netflix).

> _The dashboard includes insights on content distribution by type, country, release year, genre, and more._

## 📌 Findings and Conclusion

- **Content Distribution**: Netflix offers a rich mix of both movies and TV shows with a diverse range of genres and ratings.
- **Ratings & Durations**: TV Shows generally have more consistent ratings, while movie durations vary widely.
- **Regional Trends**: Countries like the USA and India dominate content creation.
- **Genre Diversity**: Netflix hosts a wide variety of genres, with drama, comedies, and documentaries being most popular.
- **Special Cases**: Keywords like “kill” and “violence” are used to categorize content sentimentally.

---

## 🛠️ Tools Used

- **SQL** (PostgreSQL Syntax)
- **PostgreSQL** or compatible RDBMS
- **Kaggle** for dataset sourcing
- **Tableau** for visualization

## 👨‍💻 Author

**Aryan Farswan**

This project is a part of my data analytics portfolio, demonstrating my skills in **SQL** and **Tableau** through real-world data analysis.

If you have any questions, feedback, or collaboration ideas, feel free to reach out — I'd love to connect!

📫 _Contact_: deepakfarswan99@gmail.com
