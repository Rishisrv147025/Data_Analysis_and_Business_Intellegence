---------Verifying table structure
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'supermarket_salesSheet1';

-----Get the total number of sales transactions:
SELECT COUNT(*) AS total_transactions
FROM supermarket_salesSheet1;

------Get the total sales revenue:
SELECT SUM(Total) AS total_revenue
FROM supermarket_salesSheet1;

-------Sales by Branch:
SELECT Branch, 
       COUNT(*) AS total_transactions, 
       SUM(Total) AS total_revenue
FROM supermarket_salesSheet1
GROUP BY Branch;

-----Get total sales revenue by product line:
SELECT Product_line, 
       COUNT(*) AS total_transactions, 
       SUM(Total) AS total_revenue
FROM sales_data
GROUP BY Product_line
ORDER BY total_revenue DESC;

-----Sales by Product Line:
SELECT Customer_type, 
       Gender, 
       COUNT(*) AS total_transactions, 
       SUM(Total) AS total_revenue
FROM supermarket_salesSheet1
GROUP BY Customer_type, Gender
ORDER BY total_revenue DESC;

-----Monthly Sales Trends
SELECT DATE_FORMAT(Date, '%Y-%m') AS month, 
       SUM(Total) AS total_revenue
FROM supermarket_salesSheet1
GROUP BY month
ORDER BY month;

-----Get average rating for each product line:
SELECT Product_line, 
       AVG(Rating) AS average_rating
FROM supermarket_salesSheet1
GROUP BY Product_line
ORDER BY average_rating DESC;

-----High-Value Customers:
SELECT Customer_ID, 
       SUM(Total) AS total_spent
FROM supermarket_salesSheet1
GROUP BY Customer_ID
ORDER BY total_spent DESC
LIMIT 10;  

-----Most Popular Products:
SELECT Product_line, 
       SUM(Quantity) AS total_quantity_sold
FROM supermarket_salesSheet1
GROUP BY Product_line
ORDER BY total_quantity_sold DESC;

----Correlation
SELECT Quantity, 
       Total
FROM supermarket_salesSheet1;