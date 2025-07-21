# Mini Project: Pizza Sales Analysis with SQL

## Problem Statement:
This SQL project involves analyzing a pizza sales dataset to gain insights about sales patterns, order distributions, and revenue. The dataset contains details about customer orders, pizzas, their categories, and prices. The project challenges students to write SQL queries to extract and analyze data based on progressively complex questions.

## Dataset Link:
sql file attached

## Project Overview:
The goal of this project is to help you gain experience with SQL querying by analyzing pizza sales data. You will explore the dataset through a series of tasks that range from basic queries to more complex analyses. The focus will be on understanding sales trends, customer behavior, and pizza popularity.

---

## Guidelines for Students:

### 1. **Data Understanding:**
- Understand the structure of the dataset by inspecting the tables and their relationships.
- Familiarize yourself with the schema, particularly the pizza categories, order details, and sales records.

### 2. **Data Exploration:**
- Analyze the dataset by writing queries to retrieve basic information such as the total number of orders, revenue, and frequently ordered items.

### 3. **Advanced Analysis:**
- Perform more complex queries involving joins and groupings to calculate metrics like revenue distribution, pizza category sales, and cumulative sales over time.

### 4. **Optimization and Interpretation:**
- Ensure that your queries are optimized for performance (e.g., using GROUP BY, JOIN operations, and HAVING clauses).
- Interpret the results of each query to understand trends and patterns.

---

## Project Questions:

### **Basic:**
1. **Retrieve the total number of orders placed.**
   - Objective: Understand the total volume of orders.
   ```sql
   SELECT COUNT(DISTINCT(order_id)) AS count_orders
   FROM orders;
