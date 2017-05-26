/*----------------------------Task 1----------------------------*/
SELECT DISTINCT kostya.model 
FROM PC kostya,
(SELECT p.maker, l.* FROM product p, laptop l WHERE p.model = l.model) dima,
(SELECT p.maker, PC.* FROM product p, PC WHERE p.model = PC.model) misha, 
(SELECT p.maker, pr.* FROM product p, printer pr WHERE p.model = pr.model) tanya,
(SELECT p.maker, pr.* FROM product p, printer pr WHERE p.model = pr.model) vitya,
(SELECT p.maker, l.* FROM product p, laptop l WHERE p.model = l.model) olya
WHERE dima.maker = misha.maker
AND (tanya.type <> vitya.type AND tanya.color = vitya.color)
AND dima.screen = olya.screen + 3
AND misha.price  = tanya.price * 4
AND ( SUBSTRING(vitya.model, 1, 2) = SUBSTRING(olya.model, 1, 2) 
	AND SUBSTRING(vitya.model, 3, 1) != SUBSTRING(olya.model, 3, 1)
	AND SUBSTRING(vitya.model, 4, LEN(vitya.model)) = SUBSTRING(olya.model, 4, LEN(vitya.model)) )
AND LEN(vitya.model) >= 3 
AND LEN(olya.model) >= 3
AND kostya.speed = misha.speed
AND kostya.hd = dima.hd  
AND kostya.ram = olya.ram
AND kostya.price = vitya.price;


/*----------------------------Task 2----------------------------*/
SELECT ship, STUFF(ship, first + 1, last - first, REPLICATE('*', last-first))
FROM (
	SELECT o.ship, CHARINDEX(' ', o.ship) AS first, DATALENGTH(o.ship) - CHARINDEX(' ', REVERSE(o.ship)) AS last
	FROM Outcomes o
	WHERE o.ship LIKE '% % %'
) ex


/*----------------------------Task 3----------------------------*/
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
	LEFT JOIN (SELECT DISTINCT model, COUNT(DISTINCT 1) qty FROM Printer GROUP BY model) printer
	ON p.model = printer.model
	LEFT JOIN (SELECT DISTINCT model, COUNT(DISTINCT 1) qty FROM PC GROUP BY model) pc
	ON p.model = pc.model
	LEFT JOIN (SELECT DISTINCT model, COUNT(DISTINCT 1) qty FROM laptop GROUP BY model) laptop
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



/*----------------------------Task 4----------------------------*/
SELECT ex.model, sum
FROM (
	SELECT model, 
	CASE WHEN SUBSTRING(model, 1, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 1, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 2, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 2, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 3, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 3, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 4, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 4, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 5, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 5, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 6, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 6, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 7, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 7, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 8, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 8, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 9, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 9, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 10, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 10, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 11, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 11, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 12, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 12, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 13, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 13, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 14, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 14, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 15, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 15, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 16, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 16, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 17, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 17, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 18, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 18, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 19, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 19, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 20, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 20, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 21, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 21, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 22, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 22, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 23, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 23, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 24, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 24, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 25, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 25, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 26, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 26, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 27, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 27, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 28, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 28, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 29, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 29, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 30, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 30, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 31, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 31, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 32, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 32, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 33, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 33, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 34, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 34, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 35, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 35, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 36, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 36, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 37, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 37, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 38, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 38, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 39, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 39, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 40, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 40, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 41, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 41, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 42, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 42, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 43, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 43, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 44, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 44, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 45, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 45, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 46, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 46, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 47, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 47, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 48, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 48, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 49, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 49, 1) AS INT) END+
	CASE WHEN SUBSTRING(model, 50, 1) LIKE '%[^0-9]%' THEN 0 ELSE CAST(SUBSTRING(model, 50, 1) AS INT) END AS sum
	FROM Product
) ex


/*----------------------------Task 5----------------------------*/


/*----------------------------Task 6----------------------------*/
SELECT CAST(trip_no AS varbinary(50))
FROM Tripl;

WITH number AS (
	SELECT trip_no, trip_no / 2 digit, CAST(trip_no % 2 AS VARCHAR) string
	FROM Trip
	UNION ALL
	SELECT trip_no, digit / 2, CAST(digit % 2 AS varchar)
	FROM number
	WHERE trip_no > 1
)
SELECT string
FROM number

select * from dbo.syscolumns WHERE id = object_id(N'Trip') AND name='trip_no' 

