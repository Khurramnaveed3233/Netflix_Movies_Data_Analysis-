--- Overview
--- This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.
Objectives
•	Analyze the distribution of content types (movies vs TV shows).
•	Identify the most common ratings for movies and TV shows.
•	List and analyze content based on release years, countries, and durations.
•	Explore and categorize content based on specific criteria and keywords

--- Schema
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix (
•	show_id      VARCHAR(5),
•	type         VARCHAR(10),
•	title        VARCHAR(250),
•	director     VARCHAR(550),
•	casts        VARCHAR(1050),
•	country      VARCHAR(550),
•	date_added   VARCHAR(55),
•	release_year INT,
•	rating       VARCHAR(15),
•	duration     VARCHAR(15),
•	listed_in    VARCHAR(250),
•	description  VARCHAR(550)
);

create database Netflix_Movies_Data_Analysis 

use Netflix_Movies_Data_Analysis

select * from Netflix_Movies

--- 1. Count the Number of Movies vs TV Shows
--- Objective: Determine the distribution of content types on Netflix.
SELECT 
    type AS Movie_Type,
    COUNT(*) as Total_Count
FROM Netflix_Movies
GROUP BY type ;

--- 2. Find the Most Common Rating for Movies and TV Shows
---    Objective: Identify the most frequently occurring rating for each type of content.

select * from Netflix_Movies

with RatingCount as ( 
select type , 
       rating , 
	   count(*) as Rating_Count 
from netflix_movies
group by type , rating 
) , 

RankedRatings AS (
select type ,
       rating , 
	   Rating_Count , 
	   RANK() over ( partition by type order by Rating_Count desc ) AS rank
from RatingCount
) 

select  type , 
        rating as Most_Frequent_Rating 
FROM RankedRatings
WHERE rank = 1 

--- 3. List All Movies Released in a Specific Year (e.g., 2020) 
--- Objective: Retrieve all movies released in a specific year.

select title as Movies 
from netflix_movies 
where release_year = 2020

--- 4. Find the Top 5 Countries with the Most Content on Netflix 
--- Objective: Identify the top 5 countries with the highest number of content items.

select * from Netflix_Movies


SELECT TOP 5 TRIM(value) AS Country, COUNT(*) AS Total_Content
FROM Netflix_Movies
CROSS APPLY STRING_SPLIT(country, ',') -- Split the 'country' column by comma
WHERE value IS NOT NULL
GROUP BY TRIM(value)
ORDER BY Total_Content DESC;

--- 5. Identify the Longest Movie
--- Objective: Find the movie with the longest duration.

select * from Netflix_Movies

SELECT *
FROM Netflix_Movies
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING(duration, 1, CHARINDEX(' ', duration) - 1) AS INT) DESC;

select duration , CHARINDEX(' ',duration)
from Netflix_Movies

select top 5  duration , concat(cast(SUBSTRING(duration,1,CHARINDEX(' ' ,duration)-1)as int),' mins')  as Movie_Duration
from Netflix_Movies

--- 6. Find Content Added in the Last 5 Years 
--- Objective: Retrieve content added to Netflix in the last 5 years.

SELECT *
FROM Netflix_Movies
WHERE TRY_CONVERT(DATE, date_added, 101) >= DATEADD(YEAR, -5, GETDATE());


--- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka' 
--- Objective: List all content directed by 'Rajiv Chilaka'.

SELECT * 
FROM Netflix_Movies
CROSS APPLY STRING_SPLIT(director, ',') AS split_director
WHERE LTRIM(RTRIM(split_director.value)) = 'Daniel Sandu';

select * from Netflix_Movies

--- 8. List All TV Shows with More Than 5 Seasons
--- Objective: Identify TV shows with more than 5 seasons.

SELECT *
FROM Netflix_Movies
WHERE type = 'TV Show'
  AND CAST(SUBSTRING(duration, 1, CHARINDEX(' ', duration) - 1) AS INT) > 5;

select type , SUBSTRING(type,1,4-1)
from Netflix_Movies

--- 9. Count the Number of Content Items in Each Genre
--- Objective: Count the number of content items in each genre.

select * from Netflix_Movies

exec sp_rename 'Netflix_Movies.listed_in','Genre','column'

select trim(value) as Genre , 
count(*) as Total
from Netflix_Movies
cross apply string_split(genre,',')
group by trim(value)



---- 10.Find each year and the average numbers of content release in Japan on netflix. return top 5 year with highest avg content release!
---- Objective: Calculate and rank years by the average number of content releases by Japan.

select * from Netflix_Movies


select  top 5 country ,
            release_year ,
	        COUNT(show_id) AS total_release,
	        round
			(cast(count(show_id) as float) / 
	        (select cast(count(show_id) as float ) from Netflix_Movies where country = 'japan') *100,2) AS avg_release
from Netflix_Movies
where country = 'japan'
group by country , release_year
order by avg_release desc 

--- 11. List All Movies that are Documentaries
--- Objective: Retrieve all movies classified as documentaries.

SELECT title  , Genre
FROM Netflix_Movies
WHERE Genre LIKE '%Documentaries'

--- 12. Find All Content Without a Director
--- Objective: List content that does not have a director.

SELECT * 
FROM Netflix_Movies
WHERE director IS NULL;

--- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
--- Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.

SELECT * 
FROM Netflix_Movies
WHERE cast LIKE '%Salman Khan%'
  AND release_year > YEAR(GETDATE()) - 10;

--- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India 
--- Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.

select top 8
       trim(value) as Actors , 
	   count(*) as Total_Appearences 
from Netflix_Movies
cross apply string_split(cast,',')
group by trim(value) 
order by  count(*) desc 

--- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords 
--- Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

SELECT 
       Category , 
	   count(*) as Content_count 
from ( select case when lower(description) like '%kill%' or lower(description) like '%violence%' then 'Bad' 
       else 'Good' 
	   end as Category from Netflix_Movies) as categorized_content
group by Category 


--- Findings and Conclusion

•	Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
•	Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
•	Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
•	Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
•	This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.








