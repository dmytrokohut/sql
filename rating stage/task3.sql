SELECT DISTINCT p.maker,
CASE WHEN COUNT(DISTINCT PC.model) = 0
THEN 'no' ELSE CONCAT('yes(', COUNT(DISTINCT PC.model), ')') END pc, 
CASE WHEN COUNT(DISTINCT l.model) = 0 
THEN 'no' ELSE CONCAT('yes(', COUNT(DISTINCT l.model), ')') END laptop,
CASE WHEN COUNT(DISTINCT pr.model) = 0
THEN 'no' ELSE CONCAT('yes(', COUNT(DISTINCT pr.model), ')') END printer
FROM Product p 
LEFT JOIN PC ON p.model = PC.model
LEFT JOIN Laptop l ON p.model = l.model
LEFT JOIN Printer pr ON p.model = pr.model
GROUP BY p.maker;



SELECT ex.maker,  
COALESCE('yes('+CAST(SUM(ex.pc_qty) AS varchar)+')', 'no') pc, 
COALESCE('yes('+CAST(SUM(ex.laptop_qty) AS varchar)+')', 'no') laptop,
COALESCE('yes('+CAST(SUM(ex.printer_qty) AS varchar)+')', 'no') printer
FROM (
	SELECT maker, printer.qty printer_qty, pc.qty pc_qty, laptop.qty laptop_qty 
	FROM Product p 
	LEFT JOIN (SELECT model, COUNT(DISTINCT 1) qty FROM Printer GROUP BY model) printer
	ON p.model = printer.model
	LEFT JOIN (SELECT model, COUNT(DISTINCT 1) qty FROM PC GROUP BY model) pc
	ON p.model = pc.model
	LEFT JOIN (SELECT model, COUNT(DISTINCT 1) qty FROM laptop GROUP BY model) laptop
	ON p.model = laptop.model
) ex
GROUP BY maker



SELECT ex.maker, 
COALESCE('yes('+CAST(SUM(ex.pc) AS varchar)+')', 'no') pc,
COALESCE('yes('+CAST(SUM(ex.laptop) AS varchar)+')', 'no') laptop,
COALESCE('yes('+CAST(SUM(ex.printer) AS varchar)+')', 'no') printer
FROM (
	SELECT maker, COUNT(DISTINCT pr.model) printer, NULL AS pc, NULL AS laptop
	FROM Product p JOIN Printer pr ON p.model = pr.model
	GROUP BY maker
	UNION 
	SELECT maker, NULL AS printer, COUNT(DISTINCT PC.model) AS pc, NULL AS laptop
	FROM Product p JOIN PC ON p.model = PC.model
	GROUP BY maker
	UNION 
	SELECT maker, NULL AS printer, NULL AS pc, COUNT(DISTINCT l.model) AS laptop
	FROM Product p JOIN Laptop l ON p.model = l.model
	GROUP BY maker
) ex
GROUP BY ex.maker



select p.maker, 
coalesce('yes('+cast(sum(pc.qty) as varchar)+')', 'no') pc,
coalesce('yes('+cast(sum(laptop.qty) as varchar)+')', 'no') laptop, 
coalesce('yes('+cast(sum(printer.qty) as varchar)+')', 'no') printer
from Product p left join (select model, 1 qty from PC group by model) pc on p.model = pc.model 
left join (select model, 1 qty from Laptop l group by model) laptop on p.model = laptop.model 
left join (select model, 1 qty from Printer pr group by model) printer on p.model = printer.model
group by p.maker



select p.maker, 
case when sum(pc.qty) > 0 then concat('yes(', sum(pc.qty), ')')
	 when sum(pc.qty) = 0 and count(pc_un.model) > 0 then 'yes(0)' else 'no' end PC,
case when sum(laptop.qty) > 0 then concat('yes(', sum(laptop.qty), ')')
	 when sum(laptop.qty) = 0 and count(lp_un.model) > 0 then 'yes(0)' else 'no' end Laptop,
case when sum(printer.qty) > 0 then concat('yes(', sum(printer.qty), ')')
	 when sum(printer.qty) = 0 and count(lp_un.model) > 0 then 'yes(0)' else 'no' end Laptop
from Product p left join (select model, 1 qty from PC group by model) pc on p.model = pc.model 
left join (select model, 1 qty from Laptop l group by model) laptop on p.model = laptop.model 
left join (select model, 1 qty from Printer pr group by model) printer on p.model = printer.model,
(select count(model) model from Product where type='PC' and model not in (select model from PC)) pc_un,
(select count(model) model from Product where type='Laptop' and model not in (select model from Laptop)) lp_un,
(select count(model) model from Product where type='Printer' and model not in (select model from Printer)) pr_un
group by p.maker



select ex.maker,
CASE WHEN SUM(ex.pc) = 0 AND SUM(PC.model) > 0 THEN 'yes(0)'
	 WHEN SUM(ex.pc) > 0 THEN CONCAT('yes(', SUM(ex.pc), ')') 
	 ELSE 'no' END PC,
CASE WHEN SUM(ex.Laptop) = 0 AND SUM(lp.model) > 0 THEN 'yes(0)'
	 WHEN SUM(ex.Laptop) > 0 THEN CONCAT('yes(', SUM(ex.Laptop), ')') 
	 ELSE 'no' END Laptop,
CASE WHEN SUM(ex.Printer) = 0 AND SUM(pr.model) > 0 THEN 'yes(0)'
	 WHEN SUM(ex.Printer) > 0 THEN CONCAT('yes(', SUM(ex.Printer), ')')
	 ELSE 'no' END Printer
FROM(
   SELECT p.maker, COUNT(DISTINCT pc.model) AS pc, NULL AS Laptop, NULL AS Printer
   FROM Product p
   JOIN PC ON p.model=pc.model
   group by maker
   union 
   SELECT p.maker, NULL AS pc, COUNT(DISTINCT lp.model) AS Laptop, NULL AS Printer
   FROM Product p
   JOIN Laptop lp ON p.model=lp.model
   group by maker
   union
   select p.maker, NULL AS pc, NULL AS Laptop, COUNT(DISTINCT pr.model) Printer
   FROM Product p
   JOIN Printer pr ON p.model=pr.model
   group by maker
) ex, (SELECT COUNT(model) model FROM Product WHERE type='PC' AND model NOT IN (SELECT model FROM PC)) pc,
(SELECT COUNT(model) model FROM Product WHERE type='Laptop' AND model NOT IN (SELECT model FROM Laptop)) lp,
(SELECT COUNT(model) model FROM Printer WHERE type='Printer' AND model NOT IN (SELECT model FROM Printer)) pr
GROUP BY maker



select ex.maker, 
COALESCE('yes('+CAST(SUM(ex.pc) AS varchar)+')', 'no') pc, 
COALESCE('yes('+CAST(SUM(ex.laptop) AS varchar)+')', 'no') laptop,
COALESCE('yes('+CAST(SUM(ex.printer) AS varchar)+')', 'no') printer
FROM(
	select p.maker, 
	CASE WHEN COUNT(DISTINCT PC.model) > 0 THEN COUNT(DISTINCT PC.model)
		WHEN COUNT(DISTINCT PC.model) = 0 AND COUNT(DISTINCT p.model) > 0 THEN 0
		ELSE NULL END pc, NULL AS Laptop, NULL AS Printer
	FROM Product p JOIN PC ON p.model = PC.model
	WHERE type='PC'
	GROUP BY maker
	union
	select p.maker, NULL AS PC,
	CASE WHEN COUNT(DISTINCT lp.model) > 0 THEN COUNT(DISTINCT lp.model)
		WHEN COUNT(DISTINCT lp.model) = 0 AND COUNT(DISTINCT p.model) > 0 THEN 0
		ELSE NULL END Laptop, NULL AS Printer
	FROM Product p JOIN Laptop lp ON p.model = lp.model
	WHERE type='Laptop'
	GROUP BY maker
	union 
	select p.maker, NULL AS PC, NULL AS Laptop,
	CASE WHEN COUNT(DISTINCT pr.model) > 0 THEN COUNT(DISTINCT pr.model)
		WHEN COUNT(DISTINCT PR.model) = 0 AND COUNT(DISTINCT p.model) > 0 THEN 0
		ELSE NULL END printer
	FROM Product p JOIN Printer pr ON p.model = pr.model
	WHERE p.type='Printer'
	GROUP BY maker
) ex
GROUP BY maker



select p.maker
	   ,case when count (case when pc.model is not null then 1 else null end) > 0 and (select count(model) from Product where type='PC' and model not in (select model from PC)) >= 0 then 'yes('+ cast(count (case when pc.model is not null then 1 else null end) as varchar(10))+')' else 'no' end as PC
	   ,case when count (case when lp.model is not null then 1 else null end) > 0 then 'yes('+ cast(count (case when lp.model is not null then 1 else null end) as varchar(10))+')' else 'no' end as Laptop
	   ,case when count (case when pr.model is not null then 1 else null end) > 0 then 'yes('+ cast(count (case when pr.model is not null then 1 else null end) as varchar(10))+')' else 'no' end as Printer  
  from Product p
left join (select distinct model as model from Printer) pr on p.model=pr.model
left join (select distinct model as model from PC) pc on p.model=pc.model
left join (select distinct model as model from Laptop ) lp on p.model=lp.model
group by p.maker