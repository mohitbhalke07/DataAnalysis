CREATE DATABASE olympic_casestudy;

USE olympic_casestudy;

SELECT * FROM athlete_events;

SELECT * FROM noc_regions;

/* 1. How many olympics games have been held? */
SELECT count(DISTINCT games) AS total_olympic_games
FROM athlete_events;


/* 2. List down all Olympics games held so far. (Data issue at 1956-"Summer"-"Stockholm") */
SELECT DISTINCT oh.year,oh.season,oh.city
FROM athlete_events oh
ORDER BY year;


/* 3. Identify the sport which was played in all summer olympics. */
WITH t1 AS
	(SELECT count(DISTINCT games) AS total_games
	FROM athlete_events WHERE season = 'Summer'),
  t2 AS
	(SELECT DISTINCT games, sport
	FROM athlete_events WHERE season = 'Summer'),
  t3 AS
	(SELECT sport, count(1) AS no_of_games
	FROM t2
	GROUP BY sport)
SELECT *
FROM t3
JOIN t1 ON t1.total_games = t3.no_of_games;



/* 4. Which Sports were just played only once in the olympics. */
WITH t1 AS
	(SELECT DISTINCT games, sport
	FROM athlete_events),
  t2 AS
	(SELECT sport, count(1) AS no_of_games
	FROM t1
	GROUP BY sport)
SELECT t2.*, t1.games
FROM t2
JOIN t1 ON t1.sport = t2.sport
WHERE t2.no_of_games = 1
ORDER BY t1.sport;


/* 5. Fetch the total no of sports played in each olympic games. */
WITH t1 AS
	(SELECT DISTINCT games, sport
	FROM athlete_events),
t2 AS
	(SELECT games, count(1) AS no_of_sports
	FROM t1
	GROUP BY games)
SELECT * FROM t2
ORDER BY no_of_sports DESC;


/* 6. Top 5 athletes who have won the most gold medals. */
WITH t1 AS
		(SELECT name, team, count(1) AS total_gold_medals
		FROM athlete_events
		WHERE medal = 'Gold'
		GROUP BY name, team
		ORDER BY total_gold_medals DESC),
	t2 AS
		(SELECT *, DENSE_RANK() OVER (ORDER BY total_gold_medals DESC) AS rnk
		FROM t1)
SELECT name, team, total_gold_medals
FROM t2
WHERE rnk <= 5;



/* 7. Top 5 athletes who have won the most medals (gold/silver/bronze). */
WITH t1 AS
		(SELECT name, team, count(1) as total_medals
		FROM athlete_events
		WHERE medal IN ('Gold', 'Silver', 'Bronze')
		GROUP BY name, team
		ORDER BY total_medals desc),
	t2 AS
		(SELECT *, DENSE_RANK() OVER (ORDER BY total_medals DESC) AS rnk
		FROM t1)
SELECT name, team, total_medals
FROM t2
WHERE rnk <= 5;


/* 8. Top 5 most successful countries in olympics. Success is defined by no of medals won. */
WITH t1 AS
		(SELECT nr.region, count(1) AS total_medals
		FROM athlete_events oh
		JOIN noc_regions nr ON nr.noc = oh.noc
		WHERE medal <> 'NA'
		GROUP BY nr.region
		ORDER BY total_medals DESC),
	t2 AS
		(SELECT *, DENSE_RANK() OVER(ORDER BY total_medals DESC) AS rnk
		FROM t1)
SELECT *
FROM t2
WHERE rnk <= 5;


/* 19. In which Sport/event, India has won highest medals. */
WITH t1 AS
		(SELECT sport, count(1) AS total_medals
		FROM athlete_events
		WHERE medal <> 'NA'
		AND team = 'India'
		GROUP BY sport
		ORDER BY total_medals DESC),
	t2 AS
		(SELECT *, RANK() OVER(ORDER BY total_medals DESC) AS rnk
		FROM t1)
SELECT sport, total_medals
FROM t2
WHERE rnk = 1;














