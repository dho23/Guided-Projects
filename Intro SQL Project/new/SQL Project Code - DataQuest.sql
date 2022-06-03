/* Exploratory */
SELECT *
  FROM products
 LIMIT 5;
 
 SELECT count(*)
   FROM products;	
   
   /* There is a total of 8 tables in the stores DATABASE
   productlines - 4 variables: product line
   products - 9 variables: product code
   orderdetails - 5 varibales: product code, order number
   orders - 7 variables: orderNumber
   customers - 13 varibles: customerNumber
   payments - 4 variables: customerNumber, checkNumber
   employees - 8 variables: employeeNumber
   offices - 8 variables: officeCode */
   

/* Introduction - Scale Model Cars Database */   
SELECT 'Customers' AS table_name, 
       13 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Customers
  
UNION ALL

SELECT 'Products' AS table_name, 
       9 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Products

UNION ALL

SELECT 'ProductLines' AS table_name, 
       4 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM ProductLines

UNION ALL

SELECT 'Orders' AS table_name, 
       7 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Orders

UNION ALL

SELECT 'OrderDetails' AS table_name, 
       5 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM OrderDetails

UNION ALL

SELECT 'Payments' AS table_name, 
       4 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Payments

UNION ALL

SELECT 'Employees' AS table_name, 
       8 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Employees

UNION ALL

SELECT 'Offices' AS table_name, 
       9 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Offices;
   
   
 /* Question 1: Which Products Should We Order More or Less of? */
 
 /* Computing low stock for each product */
SELECT productCode,
ROUND(SUM(quantityOrdered) * 1.0/(SELECT quantityInStock
                                    FROM products p
                                   WHERE od.productCode = p.productCode), 2) AS Low_stock
FROM orderdetails AS od
GROUP BY productCode
ORDER BY Low_stock 
LIMIT 10;
 
/* Computing product performance for each product */
SELECT productCode, SUM(quantityOrdered * priceEach) AS product_performance
FROM orderdetails
GROUP BY productCode
ORDER BY product_performance DESC
LIMIT 10;

/* Priority products for restocking */

WITH
low_stock_query AS(
SELECT productCode,
ROUND(SUM(quantityOrdered) * 1.0/(SELECT quantityInStock
                                    FROM products p
                                   WHERE od.productCode = p.productCode), 2) AS Low_stock
FROM orderdetails AS od
GROUP BY productCode
ORDER BY Low_stock 
LIMIT 10
 )

SELECT productCode, SUM(quantityOrdered * priceEach) AS product_performance
FROM orderdetails AS od
WHERE productCode IN (SELECT productCode 
						FROM low_stock_query)
GROUP BY productCode
ORDER BY product_performance DESC
LIMIT 10;			
 
 /* Question 2: How should we match marketing and communication strats to customer behavior? */
 
SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) AS profit
  FROM products p
  JOIN orderdetails od
    ON p.productCode = od.productCode
  JOIN orders o
    ON o.orderNumber = od.orderNumber
 GROUP BY o.customerNumber;


 /* Finding the VIP and Less Engaged Customers */ 
 
 /* VIP MEMEBERS */
 WITH 
 profit_table AS (
 SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) AS profit
   FROM products p
   JOIN orderdetails od
     ON p.productCode = od.productCode
   JOIN orders o
     ON o.orderNumber = od.orderNumber
  GROUP BY o.customerNumber
 )
 
SELECT contactLastName, contactFirstName, city, country, pt.profit
  FROM customers AS c
  JOIN profit_table AS pt
    ON pt.customerNumber = c.customerNumber
 ORDER BY pt.profit DESC
 LIMIT 5;
 
/* Least-engaged Customers */
 WITH 
 profit_table AS (
 SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) AS profit
   FROM products p
   JOIN orderdetails od
     ON p.productCode = od.productCode
   JOIN orders o
     ON o.orderNumber = od.orderNumber
  GROUP BY o.customerNumber
 )
 
SELECT contactLastName, contactFirstName, city, country, pt.profit
  FROM customers AS c
  JOIN profit_table AS pt
    ON pt.customerNumber = c.customerNumber
 ORDER BY pt.profit 
 LIMIT 5;
 
 
 /* Question 3: How much can we spend on acquiring new customers? */
 
  WITH 
 profit_table AS (
 SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) AS profit
   FROM products p
   JOIN orderdetails od
     ON p.productCode = od.productCode
   JOIN orders o
     ON o.orderNumber = od.orderNumber
  GROUP BY o.customerNumber
 )
 
 SELECT AVG(profit)
   FROM profit_table;
 

 /* Conclusion: We began this project looking at which products we should be ordering 
 more of, while also looking at the products we should be ordering less of to maximize profit. 
 We find that the classic cars are the priority for restocking as they sell frequently
 and are the highest-performance products. We then looked into the top VIP customers, as well as the
 least-engaged customers. We found that on average, a customer generates about $39,039.59 during their
 lifetime with the store. */
 
 
