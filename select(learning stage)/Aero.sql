/*					Task 63					*/
SELECT name 
FROM Passenger 
WHERE ID_psg IN (
	SELECT LEFT([string], CHARINDEX(' ', string)) 
	FROM ( 
		SELECT CAST(CONCAT(ID_psg, ' ', place) AS VARCHAR(30)) AS string, trip_no AS numb, ID_psg AS psg 
		FROM Pass_in_trip 
	) AS ex
	GROUP BY string
	HAVING COUNT(numb) > 1 
)

/*					Task 66					*/
SELECT date, max(c) 
FROM (SELECT date, count(*) AS c FROM Trip,  
(SELECT trip_no, date FROM Pass_in_trip WHERE date>='2003-04-01' AND date<='2003-04-07' GROUP BY trip_no, date) AS t1 
WHERE Trip.trip_no=t1.trip_no AND town_from='Rostov' GROUP BY date 
UNION ALL SELECT '2003-04-01', 0 
UNION ALL SELECT '2003-04-02', 0 
UNION ALL SELECT '2003-04-03', 0 
UNION ALL SELECT '2003-04-04', 0 
UNION ALL SELECT '2003-04-05', 0 
UNION ALL SELECT '2003-04-06', 0 
UNION ALL SELECT '2003-04-07', 0) AS t2  
GROUP BY date 

/*					Task 67					*/
SELECT COUNT(town_from) AS num_tw FROM 
(SELECT town_from, town_to, COUNT(trip_no) AS trip_no FROM Trip GROUP BY town_from, town_to 
HAVING COUNT(trip_no) >= ALL(SELECT COUNT(trip_no) FROM Trip GROUP BY town_from, town_to) ) AS ex

/*					Task 68					*/
SELECT COUNT(*) FROM ( 
SELECT TOP 1 WITH TIES SUM(c) count, ex1, ex2 FROM ( 
SELECT COUNT(*) c, town_from ex1, town_to ex2 FROM trip WHERE town_from >= town_to GROUP BY town_from, town_to 
UNION ALL 
SELECT COUNT(*) c, town_to ex1, town_from ex2 FROM trip WHERE town_to > town_from GROUP BY town_from, town_to)
AS t GROUP BY ex1, ex2 ORDER BY count DESC )
AS ex;

/*					Task 72					*/
SELECT TOP 1 WITH TIES p.name, ex.count 
FROM Passenger p
INNER JOIN (
	SELECT ex1.id_p, MAX(ex1.count) count 
	FROM ( 
		SELECT Pass_in_trip.ID_psg id_p, Trip.ID_comp id_c, COUNT(*) count 
		FROM Pass_in_trip  
		INNER JOIN Trip ON Trip.trip_no = Pass_in_trip.trip_no 
		GROUP BY Pass_in_trip.ID_psg, Trip.ID_comp 
	) AS ex1 
	GROUP BY id_p 
	HAVING COUNT(DISTINCT ex1.id_c) = 1
) AS ex ON p.ID_psg = ex.id_p 
ORDER BY count DESC;

/*					Task 76					*/
SELECT MAX(ex.name) AS name, SUM(ex.minutes) AS minutes
FROM (
	SELECT ROW_NUMBER() OVER(PARTITION BY p.ID_psg, pit.place ORDER BY pit.date) AS numb, p.ID_psg, p.name,
	DATEDIFF(MINUTE, t.time_out, DATEADD(DAY, IIF(t.time_in < t.time_out, 1, 0), t.time_in)) AS minutes
	FROM Pass_in_trip pit
	LEFT JOIN Trip t ON pit.trip_no = t.trip_no
	LEFT JOIN Passenger p ON pit.ID_psg = p.ID_psg
) AS ex
GROUP BY ex.ID_psg
HAVING MAX(ex.numb) = 1

/*					Task 77					*/
SELECT TOP 1 WITH TIES *
FROM (
	SELECT COUNT(DISTINCT t.trip_no) AS count, pit.date
	FROM Trip t
	INNER JOIN Pass_in_trip pit ON pit.trip_no = t.trip_no
	WHERE UPPER(town_from) = 'ROSTOV'
	GROUP BY pit.date
) AS ex
ORDER BY ex.count DESC

/*					Task 79					*/
SELECT Passenger.name, ex.minutes
FROM (
	SELECT pit.ID_psg, SUM((DATEDIFF(MINUTE, t.time_out, t.time_in)+1440)%1440) AS minutes,
	MAX(SUM((DATEDIFF(MINUTE, t.time_out, t.time_in)+1440)%1440)) OVER() AS max_minutes
	FROM Pass_in_trip pit
	INNER JOIN Trip t ON pit.trip_no = t.trip_no
	GROUP BY pit.ID_psg
) AS ex 
INNER JOIN Passenger ON Passenger.ID_psg = ex.ID_psg
WHERE ex.minutes = ex.max_minutes;

/*					Task 84					*/
SELECT c.name, ex.first AS [1-10], ex.second AS [11-20], ex.third AS [21-30]
FROM (
	SELECT t.ID_comp, SUM(CASE WHEN DATEPART(DAY, date) < 11 THEN 1 ELSE 0 END) AS first,
	SUM(CASE WHEN DATEPART(DAY, date) > 10 AND DATEPART(DAY, date) < 21 THEN 1 ELSE 0 END) AS second,
	SUM(CASE WHEN DATEPART(DAY, date) > 20 THEN 1 ELSE 0 END) AS third
	FROM Trip t
	INNER JOIN Pass_in_trip pit ON t.trip_no = pit.trip_no
	WHERE CONVERT(CHAR(6), pit.date, 112) = '200304'
	GROUP BY t.ID_comp
) AS ex
INNER JOIN Company c ON ex.ID_comp = c.ID_comp;

/*					Task 87					*/
SELECT DISTINCT name, COUNT(town_to) numb
FROM Trip t
INNER JOIN Pass_in_trip pit ON t.trip_no = pit.trip_no
INNER JOIN Passenger p ON pit.ID_psg = p.ID_psg
WHERE town_to LIKE 'Moscow' AND pit.ID_psg NOT IN(
	SELECT DISTINCT ID_psg
	FROM Trip t2
	INNER JOIN Pass_in_trip pit2 ON t2.trip_no = pit2.trip_no
	WHERE date + time_out = (
		SELECT MIN(date+time_out)
		FROM Trip t3
		INNER JOIN Pass_in_trip pit3 ON t3.trip_no = pit3.trip_no
		WHERE pit.ID_psg = pit3.ID_psg
	) AND town_from = 'Moscow'
)
GROUP BY pit.ID_psg, name
HAVING COUNT(town_to) > 1;

/*					Task 88					*/
SELECT (
	SELECT name 
	FROM Passenger 
	WHERE ID_psg = ex.ID_psg
) AS name, ex.count, (
	SELECT name
	FROM Company 
	WHERE ID_comp = ex.ID_comp
) AS Company 
FROM (
	SELECT P.ID_psg, MIN(t.ID_comp) AS ID_comp, COUNT(*) AS count, MAX(COUNT(*)) OVER() AS max_count 
    FROM Pass_in_trip P 
	INNER JOIN Trip t ON P.trip_no = t.trip_no 
    GROUP BY P.ID_psg 
    HAVING MIN(T.ID_comp) = MAX(T.ID_comp) 
) AS ex 
WHERE ex.count = ex.max_count;

/*					Task 93					*/
SELECT c.name, SUM(ex.time_fly) 
FROM (
	SELECT DISTINCT t.id_comp, pit.trip_no, pit.date, t.time_out, t.time_in,
	CASE
    WHEN DATEDIFF(MINUTE, t.time_out, t.time_in) > 0 
	THEN DATEDIFF(MINUTE, t.time_out, t.time_in) 
    WHEN DATEDIFF(MINUTE, t.time_out, t.time_in) <= 0 
	THEN DATEDIFF(MINUTE, t.time_out, t.time_in + 1) 
	END time_fly 
	FROM Pass_in_trip pit 
	LEFT JOIN Trip t ON pit.trip_no = t.trip_no 
) ex LEFT JOIN Company c ON ex.id_comp = c.id_comp 
GROUP BY c.name

/*					Task 94					*/
SELECT DATEADD(DAY, S.Num, D.date) AS Dt, (
	SELECT COUNT(DISTINCT P.trip_no) 
    FROM Pass_in_trip P 
    INNER JOIN Trip T ON P.trip_no = T.trip_no AND T.town_from = 'Rostov' AND P.date = DATEADD(day, S.Num, D.date)
) AS Qty 
FROM (
	SELECT (3 * ( x - 1 ) + y - 1) AS Num 
    FROM (
		SELECT 1 AS x 
		UNION ALL 
		SELECT 2 
		UNION ALL 
		SELECT 3
	) AS N1 
	CROSS JOIN (
		SELECT 1 AS y 
		UNION ALL 
		SELECT 2 
		UNION ALL 
		SELECT 3
	) AS N2 
	WHERE (3 * ( x - 1 ) + y ) < 8
) AS S, (
	SELECT MIN(A.date) AS date 
    FROM (
		SELECT P.date, COUNT(DISTINCT P.trip_no) AS Qty, MAX(COUNT(DISTINCT P.trip_no)) OVER() AS M_Qty 
        FROM Pass_in_trip AS P 
        INNER JOIN Trip AS T ON P.trip_no = T.trip_no AND T.town_from = 'Rostov' 
        GROUP BY P.date
	) AS A 
    WHERE A.Qty = A.M_Qty
) AS D

/*					Task 95					*/
SELECT c.name, 
COUNT(DISTINCT CONVERT(CHAR(24), pit.date) + CONVERT(CHAR(4), t.trip_no)) AS num_trips, 
COUNT(DISTINCT plane) AS num_dif_planes, COUNT(DISTINCT ID_psg) AS num_dif_pass, COUNT(*) AS total_pass
FROM Company c
INNER JOIN Trip t ON c.ID_comp = t.ID_comp
INNER JOIN Pass_in_trip pit ON t.trip_no = pit.trip_no 
GROUP BY c.name

/*					Task 102				*/
SELECT name
FROM passenger 
WHERE id_psg IN( 
	SELECT id_psg 
	FROM trip t,pass_in_trip pit 
	WHERE t.trip_no=pit.trip_no 
	GROUP BY id_psg 
	HAVING COUNT(DISTINCT CASE
		WHEN town_from <= town_to
		THEN town_from + town_to
		ELSE town_to + town_from 
		END ) = 1 
)

/*					Task 103				*/
SELECT MIN(t1.trip_no), MIN(t2.trip_no), MIN(t3.trip_no), MAX(t1.trip_no), MAX(t2.trip_no), MAX(t3.trip_no) 
FROM trip t1, trip t2, trip t3 
WHERE t2.trip_no > t1.trip_no AND t3.trip_no > t2.trip_no

/*					Task 107				*/
SELECT ex.name, ex.trip_no, ex.date 
FROM ( 
	SELECT ROW_NUMBER() OVER(ORDER BY date + time_out, ID_psg) rn, c.name, Trip.trip_no, pit.date 
	FROM Company c, Pass_in_trip pit, Trip 
	WHERE c.ID_comp = Trip.ID_comp AND Trip.trip_no = pit.trip_no AND town_from = 'Rostov'
	AND year(pit.date)=2003 AND month(pit.date)=4
) ex
WHERE ex.rn=5;

/*					Task 110				*/
SELECT name 
FROM Passenger 
WHERE ID_psg IN (
	SELECT ID_psg 
	FROM Pass_in_trip pit 
	INNER JOIN Trip t ON pit.trip_no = t.trip_no 
	WHERE t.time_in < t.time_out AND DATEPART(WEEKDAY, date) = 7 
)

/*					Task 114				*/
WITH ex AS (
	SELECT ID_psg, COUNT(*) AS count 
	FROM Pass_In_Trip 
	GROUP BY ID_psg, place
) 
SELECT name, count 
FROM (
	SELECT DISTINCT ID_psg, count 
	FROM ex 
	WHERE count = (
		SELECT MAX(count) 
		FROM ex
	) 
) ex1
INNER JOIN Passenger p ON ex1.ID_psg = p.ID_psg;