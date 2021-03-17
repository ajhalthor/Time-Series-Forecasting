WITH distinct_orders AS (
	SELECT DISTINCT
		number,
		DATE(date) AS date
	FROM orders
)

SELECT 
	date,
	COUNT(*) AS num_orders 
FROM distinct_orders
GROUP BY 1
ORDER BY 1