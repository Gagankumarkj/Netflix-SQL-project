CREATE TABLE netflixs (
    show_id VARCHAR(6),
    type VARCHAR(10),
    title VARCHAR(275),
    director VARCHAR(600),
    cast VARCHAR(1200),
    country VARCHAR(600),
    date_added VARCHAR(60),
    release_year INT,
    rating VARCHAR(20),
    duration VARCHAR(20),
    listed_in VARCHAR(275),
    description VARCHAR(580)
);
SELECT 
    *
FROM
    netflixs;

--  Count the Number of Movies vs TV Shows

SELECT 
    type, COUNT(*) content_count
FROM
    netflixs
GROUP BY type
ORDER BY content_count;

--  Find the Most Common Rating for Movies and TV Shows


with rating_count as (select type,rating, count(*) as rating_count from netflixs group by 1,2 order by 3 desc ),
ranked_rating as (select *, dense_rank() over(partition by type order by rating_count desc) as ranking
from rating_count)
select  type, rating_count,rating as most_frequently_rated from ranked_rating where ranking =1;




-- . List All Movies Released in a Specific Year (e.g., 2020)

SELECT 
    *
FROM
    netflixs
WHERE
    release_year = '2020';
 -- Identify the Longest Movie 
 
SELECT 
    title, duration
FROM
    netflixs
WHERE
    type = 'movie'
        AND duration = (SELECT 
            MAX(duration)
        FROM
            netflixs);
 
 --  Find Content Added in the Last 5 Years
SELECT 
    *
FROM
    netflixs
WHERE
    STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
 
 -- List All TV Shows with More Than 5 Seasons
 
SELECT 
    *
FROM
    netflixs
WHERE
    type = 'tv show'
        AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;


-- Find each year and the average numbers of content release in India on netflix.

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_releases,
    (COUNT(show_id) / (SELECT 
            COUNT(show_id)
        FROM
            netflixs
        WHERE
            country = 'india') * 100) AS avg_release
FROM
    netflixs
WHERE
    country = 'India'
GROUP BY country , release_year
ORDER BY avg_release DESC;
 


-- Find each year and the average numbers of content release in India on netflix.


SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_releases,
    (COUNT(show_id) / (SELECT 
            COUNT(show_id) AS total_releases
        FROM
            netflixs
        WHERE
            country = 'india')) * 100 AS avg_release
FROM
    netflixs
WHERE
    country = 'india'
GROUP BY country , release_year
ORDER BY avg_release DESC;

--  List All Movies that are Documentaries

SELECT 
    *
FROM
    netflixs;

SELECT 
    *
FROM
    netflixs
WHERE
    listed_in LIKE '%documentaries';

-- Find All Content Without a Director
SELECT 
    *
FROM
    netflixs
WHERE
    director IS NULL;



--  Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT 
    *
FROM
    netflixs;


SELECT 
    category, COUNT(*) AS content_count
FROM
    (SELECT 
        *,
            CASE
                WHEN
                    description LIKE '%kill%'
                        OR description LIKE '%violence%'
                THEN
                    'A'
                ELSE 'U'
            END AS category
    FROM
        netflixs) AS categorized_content
GROUP BY category;

