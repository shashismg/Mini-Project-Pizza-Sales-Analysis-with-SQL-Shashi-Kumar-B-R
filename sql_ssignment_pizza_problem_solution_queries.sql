# Selecting the 'pizza_db' database 
USE pizza_db;

# Getting an idea about all the tables 
SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;

# Questions -> 

/*
Question 1 -> 
Retrieve the total number of orders placed.
Objective: Understand the total volume of orders.

*/
# Table/s -> orders / order_details

SELECT COUNT(DISTINCT(order_id)) AS count_orders
FROM orders;


/*
Question 2 -> 
Calculate the total revenue generated from pizza sales
*/

# Table/s -> pizzas, order_details

SELECT SUM(od.quantity * p.price) AS Total_Revenue 
FROM order_details AS od 
JOIN pizzas AS p
ON od.pizza_id = p.pizza_id;

SELECT ROUND(SUM(od.quantity * p.price), 3) AS Total_Revenue 
FROM order_details AS od 
JOIN pizzas AS p
ON od.pizza_id = p.pizza_id;

SELECT CEIL(SUM(od.quantity * p.price)) AS Total_Revenue 
FROM order_details AS od 
JOIN pizzas AS p
ON od.pizza_id = p.pizza_id;

SELECT FLOOR(SUM(od.quantity * p.price)) AS Total_Revenue 
FROM order_details AS od 
JOIN pizzas AS p
ON od.pizza_id = p.pizza_id;

/*
Question 3 -> 
Identify the highest-priced pizza.
*/

# Table/s -> pizzas, pizza_types
SELECT * FROM pizza_types;
SELECT * FROM pizzas;
SELECT * FROM order_details;
SELECT * FROM orders;

SELECT pt.name, p.price
FROM pizza_types AS pt
JOIN pizzas AS p
ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

# Homework -> Try to solve the above question with Sub-Query

SELECT pt.name 
FROM pizza_types AS pt 
WHERE pt.pizza_type_id = (
	SELECT p1.pizza_type_id
    FROM pizzas AS p1 
    WHERE p1.price = (
		SELECT MAX(p2.price) 
        FROM pizzas AS p2
        )
);

/*
Question 4 -> 
Identify the most common pizza size ordered
*/

# Table/s -> pizzas, order_details
SELECT * FROM pizzas;
SELECT * FROM order_details;

SELECT size
FROM (
	SELECT p.size, COUNT(od.order_details_id) AS Number_of_Orders
	FROM pizzas AS p 
	JOIN order_details AS od
	ON p.pizza_id = od.pizza_id 
	GROUP BY p.size 
	ORDER BY Number_of_Orders DESC
) AS a
LIMIT 1;

# Homework -> Try to solve the above question without JOINs

/*
Question 5 -> 
List the top 5 most ordered pizza types along with their quantities
*/

# Table/s -> pizza_types, order_details, pizzas

SELECT p.pizza_type_id, SUM(od.quantity) AS Total_Quantity 
FROM pizzas AS p
JOIN Order_Details AS od 
ON od.pizza_id = p.pizza_id 
GROUP BY p.pizza_type_id 
ORDER BY Total_Quantity DESC
LIMIT 5;

/* 
Joins cannot be removed in this case becausein the SELECT clause, 
we are taking columns from 2 different tables. 
*/

/*
Question 6 ->  Intermediate: 1
Join the necessary tables to find the total quantity of each pizza category ordered.
*/

# Table/s -> pizza_types, order_details, pizzas

SELECT pt.category, SUM(od.quantity) AS Total_Quantity
FROM pizza_types AS pt 
JOIN pizzas AS p 
ON p.pizza_type_id = pt.pizza_type_id
JOIN Order_Details AS od 
ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY Total_Quantity DESC;

/*
Question 7 ->  Intermediate: 2
Determine the distribution of orders by hour of the day.
*/

# Table/s -> orders 

SELECT HOUR(time) AS Hour_, COUNT(order_id) AS Number_of_Orders 
FROM Orders
GROUP BY Hour_
ORDER BY Hour_;

/*
Question 8 ->  Intermediate: 3
Join relevant tables to find the category-wise distribution of pizzas
*/

# Table/s -> pizza_types, pizza, order_details 

SELECT * FROM order_details;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;

SELECT pt.category, COUNT(od.order_id) AS Number_of_Orders
FROM pizza_types AS pt
JOIN pizzas AS p 
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details AS od 
ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY Number_of_Orders DESC;

/*
Question 9 -> Intermediate: 4
Group the orders by date and calculate 
the average number of pizzas ordered per day
*/

# Table/s -> Orders, Order_Details

SELECT FLOOR(AVG(Quantity)) AS Avg_Pizzas_Ordered_Per_Day 
FROM (
	SELECT o.date, SUM(od.quantity) AS Quantity
    FROM Orders AS o 
    JOIN Order_Details AS od 
    ON o.order_id = od.order_id
    GROUP BY o.date
) AS a;

/*
Question 10 -> Intermediate: 5
Determine the top 3 most ordered pizza types based on revenue
*/

# Table/s -> pizza_types, order_details, pizza

SELECT pt.name, FLOOR(SUM(od.quantity * p.price)) AS Total_Revenue 
FROM pizza_types AS pt 
JOIN pizzas AS p
ON p.pizza_type_id = pt.pizza_type_id 
JOIN order_details AS od 
ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY Total_Revenue DESC
LIMIT 3;

/*
Question 11 -> Advanced :  1
Calculate the percentage contribution of each pizza category to total revenue
*/

# Table/s -> order_details, pizzas, pizza_types

SELECT pt.category,
ROUND((SUM(od1.quantity * p1.price) / (
	SELECT SUM(od2.quantity * p2.price)
    FROM order_details AS od2
    JOIN pizzas AS p2
    ON od2.pizza_id = p2.pizza_id)) * 100, 2) AS Proportion
FROM order_details AS od1
JOIN pizzas AS p1 
ON od1.pizza_id = p1.pizza_id
JOIN pizza_types AS pt 
ON p1.pizza_type_id = pt.pizza_type_id 
GROUP BY pt.category;

/*
Question 12 -> Advanced : 2
Analyze the cumulative revenue generated over time.
*/
# Table/s -> order_details, pizzas, orders

SELECT date, FLOOR(Revenue) AS Revenue,
FLOOR(SUM(Revenue) OVER (ORDER BY date)) AS Cum_Revenue
FROM (
	SELECT o.date, 
    SUM(od.quantity * p.price) AS Revenue 
    FROM Order_Details AS od
    JOIN Pizzas AS p
    ON p.pizza_id = od.pizza_id 
    JOIN Orders AS o 
    ON o.order_id = od.order_id 
    GROUP BY o.date
) AS s;
/*
Question 13 -> Advanced : 3
Determine the top 3 most ordered pizza types 
based on revenue for each pizza category
*/
# Table/s -> 
SELECT name, Revenue 
FROM (
	SELECT category, name, revenue, 
    RANK() OVER (PARTITION BY category ORDER BY Revenue DESC) AS rank_
    FROM (
		SELECT pt.category, pt.name,
        SUM(od.quantity * p.price) AS Revenue
        FROM pizza_types AS pt
        JOIN pizzas AS p 
        ON pt.pizza_type_id = p.pizza_type_id
        JOIN order_details AS od 
        ON od.pizza_id = p.pizza_id 
        GROUP BY pt.category, pt.name
        ) AS a
) AS b
WHERE rank_ <= 3;