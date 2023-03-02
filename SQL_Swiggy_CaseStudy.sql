USE swiggy_casestudy;

/* 1. Find customers who have never ordered*/

SELECT name 
FROM users 
WHERE user_id NOT IN (SELECT user_id FROM orders);



/* 2. Average Price/dish */
SELECT f_id, AVG(price)
FROM menu
GROUP BY f_id;
/*====OR=====*/
SELECT f.f_name, AVG(price) AS 'Average Price'
FROM menu m
JOIN food f ON m.f_id = f.f_id
GROUP BY m.f_id;



/*3. Find the top restaurant in terms of the number of orders for a given month*/
SELECT o.r_id, r.r_name, COUNT(*) AS 'MONTH' 
FROM orders o
JOIN restaurants r ON o.r_id = r.r_id
WHERE MONTHNAME(date) LIKE 'June'
GROUP BY o.r_id
ORDER BY COUNT(*) DESC;

SELECT o.r_id, r.r_name, COUNT(*) AS 'MONTH' 
FROM orders o
JOIN restaurants r ON o.r_id = r.r_id
WHERE MONTHNAME(date) LIKE 'May'
GROUP BY o.r_id
ORDER BY COUNT(*) DESC;

SELECT o.r_id, r.r_name, COUNT(*) AS 'MONTH' 
FROM orders o
JOIN restaurants r ON o.r_id = r.r_id
WHERE MONTHNAME(date) LIKE 'July'
GROUP BY o.r_id
ORDER BY COUNT(*) DESC;



/* 4. restaurants with monthly sales greater than x(1k,10k,....)*/
SELECT r.r_id, r.r_name, SUM(amount) AS 'revenue'
FROM orders o
JOIN restaurants r ON o.r_id = r.r_id
WHERE MONTHNAME(date) LIKE 'June'
GROUP BY o.r_id
HAVING Revenue > 500;



/* 5. Show all orders with order details for a particular customer in a particular date range Eg. Nitish*/ 
SELECT o.order_id, r.r_name, od.f_id, fd.f_name
FROM orders o
JOIN restaurants r ON r.r_id = o.r_id
JOIN order_details od ON o.order_id = od.order_id
JOIN food fd ON fd.f_id = od.f_id
WHERE user_id = (SELECT user_id FROM users WHERE name LIKE 'Nitish')
AND (date > '2022-06-10' AND date < '2022-07-10');



/* 6. Find restaurants with max repeated customers */
SELECT r.r_name, COUNT(*) AS 'loyal_customer'
FROM (
	SELECT r_id, user_id, COUNT(*) AS 'visits'
	FROM orders
	GROUP BY r_id, user_id
	having visits > 1
) t
JOIN restaurants r ON r.r_id = t.r_id
GROUP BY t.r_id
ORDER BY loyal_customer DESC;



/* 7. Month over month revenue growth of swiggy */
SELECT month, ((revenue - prev) / prev) * 100 AS 'Growth' FROM(
	WITH sales AS
	(
		SELECT MONTHNAME(date) AS 'month', SUM(amount) AS 'revenue'
		FROM orders
		GROUP BY month
		ORDER BY MONTH(date)
	)
	SELECT month, revenue, LAG(revenue,1) OVER(ORDER BY revenue) AS prev FROM sales
) t
