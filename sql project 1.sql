--netflix project
drop table if exists netflix_1;
create table netflix_1
(
  show_id  varchar(20),	
  type	   varchar(10),
  title	   varchar(150), 
  director	varchar(208),
  casts	    varchar(800),
  country	varchar(150),
  date_added	varchar(50),
  release_year	int,
  rating	  varchar(10),
  duration	varchar(15),
  listed_in	varchar(100),
  description varchar(250)

);

select * from netflix_1;

select count(*) as total_content from netflix_1;

select distinct type from netflix_1;




-- Business Problems & Solutions

--1. Count the number of Movies vs TV Shows

select type,count(*) as total_count
from netflix_1
group by type;

--2. Find the most common rating for movies and TV shows

select type,rating from
(
select type,rating,count(*) ,
rank() over (partition by type order by count(*) desc) as ranking
from netflix_1
group by 1,2
) as t1
where ranking =1
--3. List all movies released in a specific year (e.g., 2020)

select * from netflix_1
where type ='Movie' and
      release_year = 2020;
	  
--4. Find the top 5 countries with the most content on Netflix

select unnest(string_to_array(country,',')) as new_country,
count(show_id) as total_content 
from netflix_1
group by 1
order by 2 desc
limit 5;


--5. Identify the longest movie

select * from netflix_1
where type='Movie' and duration =(select max(duration) from netflix_1);

--6. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix_1
where director like '%Rajiv Chilaka%';

--7. List all TV shows with more than 5 seasons

select *
		from netflix_1
where type = 'TV Show' and 
		split_part(duration,' ',1)::numeric > 5 ;

--8. Count the number of content items in each genre

select 
	unnest(string_to_array(listed_in,',')) as genre,
	count(show_id) as total_count
from netflix_1
group by 1;

--9.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!
select extract( YEAR from to_date(date_added,'Month DD YYYY')) as year,
  count(*) ,
  count(*)::numeric/(select count(*) from netflix_1 where country = 'India'):: numeric * 100 as avg_year
  from netflix_1
where country ='India'
group by 1;


--10. List all movies that are documentaries

select * from netflix_1
	where  listed_in like '%Documentaries%';
	
--11. Find all content without a director

select * from netflix_1
where director is NULL;

--12. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix_1
where casts Ilike '%Salman Khan%'
		and release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10;

--13. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select unnest(string_to_array(casts,',')) as actros,
count(*) as total_content
from netflix_1
where country ilike '%India' 
group by 1
order by 2 desc
limit 10
