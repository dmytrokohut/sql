/*				Task 31				*/
SELECT class, country FROM Classes WHERE bore >= 16;

/*				Task 32				*/
SELECT ex.country, CAST(AVG(ex.bore*ex.bore*ex.bore/2) AS NUMERIC(6, 2)) AS mw FROM ( 
SELECT C.class, S.name, C.country, C.bore FROM Classes AS C INNER JOIN Ships AS S ON C.class = S.class
UNION 
SELECT C.class, O.ship, C.country, C.bore FROM Classes AS C INNER JOIN Outcomes AS O ON C.class = O.ship)
AS ex GROUP BY ex.country;

/*				Task 33				*/
SELECT ship FROM Outcomes WHERE battle = 'North Atlantic' AND result='sunk';

/*				Task 34				*/
SELECT name FROM Classes INNER JOIN Ships ON Classes.class = Ships.class
WHERE launched >= 1922 AND displacement > 35000 AND type = 'bb';

/*				Task 36				*/
select name from Ships where class = name
union select ship as name from Classes inner join Outcomes on Classes.class = Outcomes.ship;

/*				Task 37				*/
select ex.class from (select name, class from ships
union 
select ship, c.class from Outcomes o  join Classes c on o.ship = c.class ) as ex
group by ex.class having count(ex.class) = 1

/*				Task 38				*/
select country from classes where type='bb' intersect select country from classes where type='bc';

/*				Task 39				*/
with ex as 
(select o.ship, b.name, b.date, o.result
from outcomes o inner join battles b on o.battle = b.name)
select distinct a.ship
from ex a where upper(a.ship) in (select upper(b.ship)
from ex b where b.date < a.date and b.result='damaged')

/*				Task 40				*/
select c.class, name, c.country
from ships inner join classes c on c.class = ships.class where c.numGuns >= 10

/*				Task 42				*/
select ship, battle from Outcomes where result = 'sunk'

/*				Task 43				*/
select distinct name
from battles
where name is not null and datepart(yyyy, date) not in ( select launched from ships s where launched is not null)


/*				Task 44				*/
select distinct name from ships where name like 'R%'
union 
select distinct ship from outcomes where ship like 'R%'

/*				Task 45				*/
select distinct name from ships where name like '% % %'
union
select distinct ship from outcomes where ship like '% % %'

/*				Task 46				*/
select name as [ship], displacement as [displacement], numGuns as [numGuns]
from classes c inner join ships s on s.class = c.class
where name in ( select ship from outcomes where battle like 'Guadalcanal')
union
select ship as [ship], displacement as [displacement], numGuns as [numGuns]
from outcomes o inner join classes c on c.class = o.ship
where battle like 'Guadalcanal' and ship not in (select name from ships)
union
select ship as [ship], null as [displacement], null as [numGuns]
from outcomes
where battle like 'Guadalcanal' and ship not in (select name from ships) and ship not in (select class from classes) 

/*				Task 48					*/
select class from ships s inner join outcomes o on o.ship = s.name where o.result = 'sunk'
union 
select class from outcomes o inner join classes c on c.class = o.ship where o.result = 'sunk'

/*				Task 49					*/
select name as [name] from ships s inner join classes c on s.class = c.class where c.bore = 16	
union
select o.ship as [name] from outcomes o inner join classes c on c.class = o.ship where c.bore = 16

/*				Task 50					*/
select battle from outcomes o inner join ships s on s.name = o.ship where class like 'Kongo'
union
select battle from outcomes o inner join classes c on c.class = o.ship where class like 'Kongo' and class in (
select battle from outcomes o inner join ships s on s.name = o.ship where class like 'Kongo')

/*				Task 51					*/
select NAME from (select name as NAME, displacement, numguns  
from ships inner join classes on ships.class = classes.class 
union 
select ship as NAME, displacement, numguns from outcomes inner join classes on outcomes.ship= classes.class) as d1 inner join
(select displacement, max(numGuns) as numguns from ( select displacement, numguns from
ships inner join classes on ships.class = classes.class  
union 
select displacement, numguns  from outcomes inner join classes on outcomes.ship= classes.class) as f 
group by displacement) as d2 on d1.displacement = d2.displacement and d1.numguns = d2.numguns 

/*				Task 52					*/
select distinct s.name from ships s inner join classes c on c.class = s.class
where (numguns >= 9 or numguns is null) and (bore < 19 or bore is null) and (displacement <= 65000 or displacement is null)
and type like 'bb' and country like 'Japan'

/*				Task 53					*/
select cast(avg(cast(numguns as numeric(6, 2))) as numeric(6, 2)) as AVG_numguns from classes where type like 'bb'

/*				Task 54					*/
select cast(avg(cast(numguns as numeric(6, 2))) as numeric(6, 2)) as AVG_numguns from (
select ship, type, numguns from classes c right join outcomes o on c.class = o.ship
union 
select name, type, numguns from ships s inner join classes c on c.class = s.class) as ex where type like 'bb'

/*				Task 55					*/
select c.class, min(launched) from ships s right join classes c on s.class=c.class group by c.class

/*				Task 56					*/
select c.class, count(ex.ship) from classes c left join(
select o.ship, s.class from outcomes o left join ships s on o.ship = s.name where o.result='sunk'
union
select o.ship, c.class from outcomes o left join classes c on ship=class where o.result='sunk') as ex
on c.class = ex.class group by c.class;

/*				Task 57					*/
select class, count(class) as sunked from( 
select c.class, o.ship from classes c inner join outcomes o on c.class = o.ship where o.result = 'sunk' 
union 
select s.class, o.ship from outcomes o inner join ships s on s.name = o.ship where o.result = 'sunk') as ex1
where class in ( select distinct ex2.class from (select c.class, o.ship
from classes c inner join outcomes o on c.class = o.ship 
union 
select c.class, s.name from classes as c inner join ships as s on c.class = s.class) as ex2 group by ex2.class 
having count(ex2.class)>=3 )  group by class 

/*				Task 70					*/
SELECT DISTINCT o.battle FROM outcomes o LEFT JOIN ships s ON s.name = o.ship 
LEFT JOIN classes c ON o.ship = c.class OR s.class = c.class 
WHERE c.country IS NOT NULL 
GROUP BY c.country, o.battle 
HAVING COUNT(o.ship) >= 3

/*				Task 73					*/
SELECT DISTINCT Classes.country AS country, Battles.name
FROM Classes, Battles
EXCEPT
SELECT DISTINCT Classes.country AS country, Outcomes.battle
FROM Outcomes
LEFT JOIN Ships ON Outcomes.ship = Ships.name
LEFT JOIN Classes ON Classes.class = Outcomes.ship 
OR Classes.class = Ships.class
WHERE Classes.country IS NOT NULL;

/*				Task 74					*/
SELECT c.country, c.class
FROM Classes c
WHERE UPPER(c.country) LIKE 'RUSSIA' AND EXISTS (
	SELECT c.country, c.class
	FROM Classes c
	WHERE UPPER(c.country) LIKE 'RUSSIA'
)
UNION ALL
SELECT c.country, c.class
FROM Classes c
WHERE NOT EXISTS (
	SELECT c.country, c.class
	FROM Classes c
	WHERE UPPER(c.country) LIKE 'RUSSIA'
)

/*				Task 75					*/
SELECT ex.ship, ex.launched, ex.battle
FROM (
	SELECT s.name AS ship, s.launched, b.name AS battle,
	ROW_NUMBER() OVER(PARTITION BY s.name ORDER BY date) AS num
	FROM Ships s, Battles b
	WHERE DATEPART(YEAR, date) >= launched AND launched IS NOT NULL
) AS ex
WHERE ex.num = 1
UNION 
SELECT name AS ship, launched, (
	SELECT name 
	FROM Battles
	WHERE date = (
		SELECT MAX(date)
		FROM Battles
	)
) AS battle
FROM Ships
WHERE launched IS NULL;

/*				Task 78					*/
SELECT name, REPLACE(CONVERT(CHAR(12), DATEADD(M, DATEDIFF(M, 0, date), 0), 102), '.', '-') AS date_begin,
REPLACE(CONVERT(CHAR(12), DATEADD(S, -1, DATEADD(M, DATEDIFF(M, 0, date)+1, 0)), 102), '.', '-') AS date_end
FROM Battles

/*				Task 83					*/
SELECT name
FROM Ships s
INNER JOIN Classes c ON s.class = c.class
WHERE 
CASE WHEN numGuns = 8 THEN 1 ELSE 0 
END +
CASE WHEN bore = 15 THEN 1 ELSE 0 
END +
CASE WHEN displacement = 32000 THEN 1 ELSE 0
END +
CASE WHEN type = 'bb' THEN 1 ELSE 0
END +
CASE WHEN launched = 1915 THEN 1 ELSE 0
END +
CASE WHEN c.class = 'Kongo' THEN 1 ELSE 0
END +
CASE WHEN country = 'USA' THEN 1 ELSE 0
END >= 4;

/*					Task 104				*/
SELECT DISTINCT class,'bc-' + cast(ex.numb AS CHAR(2)) AS number
FROM ( 
	SELECT c1.class, c1.numGuns, ROW_NUMBER() OVER(PARTITION BY c1.class ORDER BY c1.numguns) numb 
	FROM Classes c1, classes c2 
	WHERE c1.type = 'bc'
) ex
WHERE ex.numguns >= numb

