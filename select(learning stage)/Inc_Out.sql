/*				Task 29					*/
SELECT ex.point, ex.date, SUM(ex.inc) AS inc, SUM(ex.out) AS out
FROM (SELECT point, date, inc, NULL AS out FROM Income_o
UNION
SELECT point, date, NULL AS inc, Outcome_o.out FROM Outcome_o) AS ex
GROUP BY ex.point, ex.date;

/*				Task 30					*/
SELECT ex.point, ex.date, SUM(ex.sum_out) AS SUM_inc, SUM(ex.sum_inc) AS SUM_out
FROM (SELECT point, date, NULL AS sum_out, SUM(inc) AS sum_inc FROM Income GROUP BY point, date
UNION SELECT point, date, SUM(out) AS sum_out, NULL AS sum_inc FROM Outcome GROUP BY point, date) AS ex
GROUP BY ex.point, ex.date ORDER BY point;

/*				Task 59					*/
select a.point,
case
when out_o is null
then inc_o
else inc_o - out_o
end as remain
FROM (select point, sum(inc) as inc_o from Income_o group by point) as A left join
(select point, sum(out) as out_o from Outcome_o group by point) as B on A.point=B.point;

/*				Task 60					*/
select a.point,
case 
when out is null
then inc 
else inc - out 
end remain 
from (select point, sum(inc) as inc 
from Income_o where '2001-04-15' > date group by point) as A left join (select point, sum(out) as out 
from Outcome_o  where '2001-04-15' > date group by point) as B on A.point = B.point;

/*				Task 61					*/
select isnull((select sum(inc) from income_o), 0) - isnull((select sum(out) from outcome_o), 0) as remain;

/*				Task 62					*/
select (select sum(inc)
from income_o where date < '2001-04-15') - (select sum(out)
from outcome_o where date < '2001-04-15') as remain;

/*				Task 64					*/
select i.point, i.date, 'inc' as operation, sum(i.inc) as money_sum
from income i left join outcome o on i.point = o.point and i.date = o.date
where o.date is null
group by i.point, i.date
union
select o.point, o.date, 'out' as operation, sum(o.out) as money_sum
from income i right join outcome o on i.point = o.point and i.date = o.date
where i.date is null
group by o.point, o.date;

/*				Task 69					*/
WITH ex AS (
SELECT point, date, inc AS sum FROM Income 
UNION ALL 
SELECT point, date, -out AS sum FROM Outcome ) 
SELECT ex1.point, CONVERT(CHAR(25), ex1.date, 103) AS date, (
	SELECT SUM(sum) FROM ex WHERE ex.date <= ex1.date and ex.point = ex1.point
) AS remain
FROM ex AS ex1 
GROUP BY point, date;

/*				Task 81					*/
SELECT Outcome.*
FROM Outcome 
INNER JOIN (
	SELECT TOP 1 WITH TIES DATEPART(YEAR, date) AS year, DATEPART(MONTH, date) AS month,
	SUM(out) AS sum
	FROM Outcome
	GROUP BY DATEPART(YEAR, date), DATEPART(MONTH, date)
	ORDER BY sum DESC
) AS ex ON DATEPART(YEAR, Outcome.date) = ex.year AND DATEPART(MONTH, Outcome.date) = ex.month;

/*				Task 100				*/
SELECT DISTINCT x1.date , x1.code, x2.point, x2.inc, x3.point, x3.out 
FROM (
	SELECT DISTINCT date, ROW_NUMBER() OVER(PARTITION BY date ORDER BY code) AS code 
	FROM Income 
	UNION 
	SELECT DISTINCT date, ROW_NUMBER() OVER(PARTITION BY date ORDER BY code) AS code
	FROM Outcome
) x1 
LEFT JOIN (
	SELECT date, point, inc, ROW_NUMBER() OVER(PARTITION BY date ORDER BY code) AS code_inc 
	FROM Income 
) x2 ON x2.date = x1.date AND x2.code_inc = x1.code
LEFT JOIN (
	SELECT date, point, out, ROW_NUMBER() OVER(PARTITION BY date ORDER BY code) AS code_out 
	FROM Outcome 
) x3 ON x3.date = x1.date AND x3.code_out = x1.code;
