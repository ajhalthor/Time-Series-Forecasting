WITH distinct_orders AS (
	SELECT DISTINCT
		number,
		DATE(date) AS date
	FROM orders
),

weekly_orders AS (
	SELECT 
		DATE(date, '-7 DAYS', 'WEEKDAY 1') AS week,
		COUNT(*) AS num_orders 
	FROM distinct_orders
	GROUP BY 1
),

recent_7_day_orders AS (
	SELECT 
		orders.week,
		COUNT(recent_orders.number) AS order_count
	FROM weekly_orders orders
	JOIN distinct_orders recent_orders
		ON recent_orders.date < orders.week
		AND recent_orders.date >= DATE(orders.week, '-7 DAYS') 
	GROUP BY 1
),

recent_30_day_orders AS (
	SELECT 
		orders.week,
		COUNT(recent_orders.number) AS order_count
	FROM weekly_orders orders
	JOIN distinct_orders recent_orders
		ON recent_orders.date < orders.week
		AND recent_orders.date >= DATE(orders.week, '-30 DAYS') 
	GROUP BY 1
),

labels AS (
	SELECT 
		orders.week,
		COUNT(label_orders.number) AS order_count
	FROM weekly_orders orders
	JOIN distinct_orders label_orders
		ON label_orders.date >= orders.week
		AND label_orders.date < DATE(orders.week, '7 DAYS') 
	GROUP BY 1
)

SELECT
	orders.week,
	COALESCE(recent_7_day_orders.order_count, 0) AS order_count_7_day,
	COALESCE(recent_30_day_orders.order_count, 0) AS order_count_30_day,
	COALESCE(labels.order_count, 0) AS label
FROM weekly_orders orders
LEFT JOIN recent_7_day_orders
	ON recent_7_day_orders.week = orders.week
LEFT JOIN recent_30_day_orders
	ON recent_30_day_orders.week = orders.week
LEFT JOIN labels
	ON labels.week = orders.week
WHERE orders.week >= '2016-01-01'

