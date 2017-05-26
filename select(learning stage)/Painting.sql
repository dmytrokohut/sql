/*				Task 28					*/
select cast(sum(isnull(B_VOL, 0)) / cast(count(distinct Q_ID) as decimal(6,2)) as decimal(6,2)) avg_paint 
from utQ left join utB on Q_ID = B_Q_ID

/*				Task 92					*/
SELECT Q_NAME 
FROM utQ 
WHERE Q_ID IN (
	SELECT DISTINCT B.B_Q_ID 
	FROM (
		SELECT B_Q_ID 
		FROM utB 
		GROUP BY B_Q_ID 
		HAVING SUM(B_VOL) = 765
	) AS B 
	WHERE B.B_Q_ID NOT IN (
		SELECT B_Q_ID 
		FROM utB 
		WHERE B_V_ID IN (
			SELECT B_V_ID 
			FROM utB 
			GROUP BY B_V_ID 
			HAVING SUM(B_VOL) < 255
		)
	)
)

/*				Task 96					*/
SELECT ex.v_name 
FROM (
	SELECT v.v_name, v.v_id, COUNT(CASE WHEN v_color = 'R' THEN 1 END) OVER(PARTITION BY v_id) count_red, 
    COUNT(CASE WHEN v_color = 'B' THEN 1 END) OVER(PARTITION BY b_q_id) count_blue 
	FROM utV v
	INNER JOIN utB b ON v.v_id = b.b_v_id
) AS ex
WHERE count_red > 1 AND count_blue > 0
GROUP BY ex.v_name;

/*				Task 106				*/
WITH ex AS( 
	SELECT *, ROW_NUMBER() OVER(ORDER BY b_datetime, b_q_id, b_v_id) n 
	FROM utb
) 
SELECT b_datetime, b_q_id, b_v_id, b_vol, CAST(EXP(sum1)/EXP(sum2) AS NUMERIC(12,8)) k 
FROM ex x
CROSS APPLY (
	SELECT SUM( IIF(n%2 <> 0, LOG(b_vol), 0)) sum1, SUM( IIF(n%2=0, LOG(b_vol), 0)) sum2 
	FROM ex 
	WHERE n <= x.n
) y