/*				Task 1					*/
select model, speed, hd from dbo.PC where price < 500;

/*				Task 2					*/
select distinct maker from dbo.Product where type='Printer';

/*				Task 3					*/
select model, ram, screen from dbo.Laptop where price > 1000;

/*				Task 4					*/
select * from dbo.Printer where color='y';

/*				Task 5					*/
select model, speed, hd from dbo.PC where cd in ('12x', '24x') and price < 600;

/*				Task 6					*/
select distinct dbo.Product.maker, dbo.Laptop.speed
from dbo.Laptop inner join dbo.Product on dbo.Laptop.model = dbo.Product.model
where hd >= 10;

/*				Task 7					*/
SELECT dbo.PC.model, dbo.PC.price
FROM dbo.PC INNER JOIN dbo.Product ON dbo.PC.model = dbo.Product.model
WHERE dbo.Product.maker = 'B'
UNION
SELECT dbo.Laptop.model, dbo.Laptop.price
FROM dbo.Laptop INNER JOIN dbo.Product ON dbo.Laptop.model = dbo.Product.model
WHERE dbo.Product.maker = 'B'
UNION
SELECT dbo.Printer.model, dbo.Printer.price
FROM dbo.Printer INNER JOIN dbo.Product ON dbo.Printer.model = dbo.Product.model
WHERE dbo.Product.maker = 'B';

/*				Task 8					*/
SELECT maker FROM Product WHERE type='PC' 
EXCEPT SELECT maker FROM Product WHERE type='Laptop';

/*				Task 9					*/
select distinct Product.maker from Product inner join PC on Product.model = PC.model where PC.speed >= 450;

/*				Task 10					*/
select model, price from Printer
where price = (select max(price) from Printer);

/*				Task 11					*/
SELECT AVG(speed) AS AVG_S FROM PC;

/*				Task 12					*/
SELECT AVG(speed) AS AVG_S FROM Laptop WHERE price > 1000;

/*				Task 13					*/
SELECT AVG(PC.speed) AS AVG_S
FROM Product INNER JOIN PC ON Product.model = PC.model
WHERE Product.maker = 'A';

/*				Task 14					*/
SELECT maker, MAX(type) FROM Product
GROUP BY maker
HAVING COUNT(DISTINCT type) = 1 AND COUNT(model) > 1;

/*				Task 15					*/
SELECT hd FROM PC GROUP BY hd HAVING COUNT(model) >= 2;

/*				Task 16					*/
SELECT DISTINCT pc1.model, pc2.model, pc1.speed, pc1.ram FROM PC pc1, PC pc2
WHERE pc1.model > pc2.model AND pc1.speed = pc2.speed AND pc1.ram = pc2.ram;

/*				Task 17					*/
SELECT DISTINCT Product.type, Laptop.model, Laptop.speed
FROM Product INNER JOIN Laptop ON Laptop.model = Product.model
WHERE Laptop.speed < ALL (SELECT speed FROM PC);

/*				Task 18					*/
SELECT DISTINCT Product.maker, Printer.price FROM Product INNER JOIN Printer ON Product.model = Printer.model
WHERE Printer.color = 'y' AND Printer.price = (SELECT MIN(price) FROM Printer WHERE color = 'y');

/*				Task 19					*/
SELECT Product.maker, AVG(Laptop.screen) AS screen_size
FROM Product INNER JOIN Laptop ON Product.model = Laptop.model GROUP BY Product.maker;

/*				Task 20					*/
SELECT maker, COUNT(model) AS model_numb FROM Product
WHERE type='PC' GROUP BY maker HAVING COUNT(model) >= 3;

/*				Task 21					*/
SELECT Product.maker, MAX(PC.price) FROM Product INNER JOIN PC ON Product.model = PC.model
GROUP BY Product.maker;

/*				Task 22					*/
SELECT speed, AVG(price) AS AVG_speed FROM PC WHERE speed > 600 GROUP BY speed;

/*				Task 23					*/
SELECT DISTINCT Product.maker FROM Product INNER JOIN PC ON Product.model = PC.model
WHERE PC.speed >= 750 AND Product.maker IN (SELECT Product.maker
FROM Product INNER JOIN Laptop ON Product.model = Laptop.model WHERE Laptop.speed >= 750);

/*				Task 24					*/
SELECT ex1.model FROM (SELECT model, price FROM PC
UNION SELECT model, price FROM Laptop UNION 
SELECT model, price FROM Printer) ex1
WHERE ex1.price = (SELECT MAX(ex2.price) FROM (SELECT price FROM PC UNION
SELECT price FROM Laptop UNION
SELECT price FROM Printer) ex2);

/*				Task 25					*/
SELECT DISTINCT maker FROM Product
WHERE model IN (SELECT model FROM PC WHERE ram = (SELECT MIN(ram) FROM PC) AND 
speed = (SELECT MAX(speed) FROM PC WHERE ram = (SELECT MIN(ram) FROM PC)))
AND maker IN (SELECT maker FROM Product WHERE type='printer');

/*				Task 26					*/

/*				Task 27					*/
SELECT Product.maker, AVG(PC.hd)
FROM Product INNER JOIN PC ON Product.model = PC.model
WHERE PC.model = Product.model AND Product.maker IN (SELECT DISTINCT maker
FROM Product WHERE type='Printer')
GROUP BY Product.maker;

/*				Task 35					*/
select model, type from Product where model not like '%[^0-9]%' or model not like '%[^a-z]%';

/*				Task 41					*/
SELECT 'model' AS chr, CAST(model AS VARCHAR) AS value
FROM PC 
WHERE code = (
	SELECT MAX(code) 
	FROM pc 
)
UNION 
SELECT 'speed' AS chr, CAST(speed AS VARCHAR) AS value
FROM PC 
WHERE code = (
	SELECT MAX(code) 
	FROM PC
)
UNION SELECT 'ram' AS chr, CAST(ram AS VARCHAR) AS value 
FROM pc 
WHERE code = (
	SELECT MAX(code) 
	FROM PC
)
UNION 
SELECT 'hd' AS chr, CAST(hd AS VARCHAR) AS value 
FROM PC 
WHERE code = (
	SELECT MAX(code) 
	FROM PC
)
UNION 
SELECT 'cd' AS chr, CAST(cd AS VARCHAR) AS [value] 
FROM PC 
WHERE code = (
	SELECT MAX(code) 
	FROM PC
)
UNION 
SELECT 'price' AS chr, CAST(price AS VARCHAR) AS value 
FROM PC 
WHERE code = (
	SELECT MAX(code) 
	FROM PC
)

/*				Task 47					*/
select row_number() over(order by ex.numb desc, ex.maker, ex.model) as [¹], ex.maker, ex.model from (
select p1.maker, p1.model, p2.numb from product as p1 inner join ( 
select maker, count(model) as numb from product group by maker ) as p2 on p1.maker = p2.maker )as ex
order by ex.model;

/*				Task 58					*/
SELECT ex1.maker, ex1.type, CAST(100.0 * ex1.count_one/ex2.count_two AS NUMERIC(6, 2))
FROM (
	SELECT ex.maker, ex.type, SUM(count) AS count_one
	FROM (
		SELECT maker, 'PC' AS type, 0 AS count
		FROM Product
		UNION
		SELECT maker, 'Laptop' AS type, 0 AS count
		FROM Product
		UNION
		SELECT maker, 'Printer' AS type, 0 AS count
		FROM Product
		UNION
		SELECT maker, type, COUNT(*) AS count
		FROM Product
		GROUP BY maker, type
	) AS ex
	GROUP BY maker, type
) AS ex1
INNER JOIN (
	SELECT maker, COUNT(type) AS count_two
	FROM Product
	GROUP BY maker
) AS ex2 ON ex1.maker = ex2.maker;

/*				Task 65		?			*/
SELECT ROW_NUMBER() over(ORDER BY maker, s), t, type 
FROM (SELECT maker, type, 
CASE 
WHEN type='PC' THEN 0 
WHEN type='Laptop' THEN 1 
ELSE 2 
END AS s, 
CASE 
WHEN type='Laptop' AND (maker IN (SELECT maker FROM Product WHERE type='PC')) THEN ''
WHEN type='Printer' AND ((maker IN (SELECT maker FROM Product WHERE type='PC')) OR (maker in (SELECT maker 
FROM Product WHERE type='Laptop'))) THEN ''
ELSE maker 
END AS t 
FROM Product GROUP BY maker,type) AS t1 
ORDER BY maker, s;

/*				Task 71					*/
SELECT DISTINCT p.maker
FROM Product p
WHERE type = 'PC'
GROUP BY maker
HAVING COUNT(DISTINCT model) = (
	SELECT COUNT(DISTINCT model) 
	FROM PC
	WHERE model IN (
		SELECT DISTINCT Product.model
		FROM Product
		WHERE Product.maker = p.maker
	)
)

/*				Task 80					*/
SELECT DISTINCT maker
FROM Product
WHERE maker NOT IN (
	SELECT maker
	FROM Product
	WHERE type LIKE 'PC' AND model NOT IN (
		SELECT model 
		FROM PC
	)
);

/*				Task 82					*/
WITH ex AS (
	SELECT PC.code, PC.price, numb = ROW_NUMBER() OVER(ORDER BY PC.code)
	FROM PC
)
SELECT ex.code, AVG(x.price) AS average
FROM ex, ex x
WHERE (x.numb - ex.numb) < 6 AND (x.numb - ex.numb) >= 0
GROUP BY ex.numb, ex.code
HAVING COUNT(ex.numb) = 6;

/*				Task 85					*/
SELECT maker
FROM Product
GROUP BY maker
HAVING COUNT(DISTINCT type) = 1 AND (
	MIN(type) = 'Printer' OR
	MIN(type) = 'PC' AND COUNT(type) >= 3
)

/*				Task 86					*/
SELECT maker,
CASE
WHEN COUNT(DISTINCT type) = 1
THEN MAX(type)
WHEN COUNT(DISTINCT type) = 2
THEN MIN(type) + '/' + MAX(type)
WHEN COUNT(DISTINCT type) = 3
THEN 'Laptop/PC/Printer'
END AS types
FROM Product
GROUP BY maker

/*				Task 89					*/
SELECT maker, COUNT(DISTINCT model) AS num_model
FROM Product 
GROUP BY maker
HAVING COUNT(DISTINCT model) >= ALL(
	SELECT COUNT(model)
	FROM Product
	GROUP BY maker
) OR COUNT(DISTINCT model) <= ALL(
	SELECT COUNT(model)
	FROM Product
	GROUP BY maker
);

/*				Task 90					*/
SELECT *
FROM Product
WHERE model NOT IN (
	SELECT TOP 3 model
	FROM Product
	ORDER BY model DESC
) AND model NOT IN (
	SELECT TOP 3 model
	FROM Product
	ORDER BY model
);

/*				Task 91					*/
SELECT COUNT(maker) AS count
FROM Product
WHERE maker IN (
	SELECT maker
	FROM Product
	GROUP BY maker
	HAVING COUNT(DISTINCT model) = 1
)

/*				Task 98					*/
SELECT code, speed, ram, price, screen 
FROM Laptop 
WHERE EXISTS ( 
	SELECT 1 x 
	FROM ( 
		SELECT v, RANK()OVER(ORDER BY v) rn 
		FROM ( 
			SELECT CAST(speed AS float) sp, CAST(ram AS float) rm, CAST(price AS float) pr, CAST(screen AS float) sc 
		) l UNPIVOT(v FOR c IN (sp, rm, pr, sc)) u 
  ) l PIVOT(MAX(v) FOR rn IN ([1],[2],[3],[4])) p 
  WHERE [1]*2 <= [2] AND [2]*2 <= [3] AND [3]*2 <= [4] 
)

/*				Task 99					*/
WITH CTE AS (
	SELECT 1 n, CAST(0 AS VARCHAR(16)) bit_or, code, speed, ram 
	FROM PC 
	UNION ALL 
	SELECT n*2, CAST(CONVERT(bit,(speed|ram)&n) AS VARCHAR(1)) + CAST(bit_or AS VARCHAR(15)), code, speed, ram 
	FROM CTE WHERE n < 65536 
) 
SELECT code, speed, ram 
FROM CTE 
WHERE n = 65536 AND CHARINDEX('1111', bit_or ) > 0;

/*				Task 102				*/
SELECT ex.code, ex.model, ex.color, ex.type, ex.price, MAX(ex.model) OVER(PARTITION BY grp) AS max_model, 
MAX(CASE ex.type WHEN 'Laser' THEN 1 ELSE 0 END) OVER(PARTITION BY grp )+ 
MAX(CASE ex.type WHEN 'Matrix' THEN 1 ELSE 0 END) OVER(PARTITION BY grp) + 
MAX(CASE ex.type WHEN 'Jet' THEN 1 ELSE 0 END) OVER(PARTITION BY grp) AS distinct_types_cou, 
AVG(ex.price) OVER(PARTITION BY grp) AS avg_price
FROM( 
	SELECT *, 
    CASE color WHEN 'n' THEN 0 ELSE ROW_NUMBER() OVER(ORDER BY code) END + 
    CASE color WHEN 'n' THEN 1 ELSE-1 END * ROW_NUMBER() OVER(PARTITION BY color ORDER BY code) grp 
	FROM Printer
) ex

/*				Task 105				*/
SELECT maker, model, ROW_NUMBER() OVER(ORDER BY maker, model) AS A, DENSE_RANK() OVER(ORDER BY maker) AS B, 
       RANK() OVER(ORDER BY maker) AS V, COUNT(*) OVER(ORDER BY maker) AS G
FROM product;