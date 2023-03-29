--SQL Queries 

USE OnlineStore



--Checking order details by order ID 
SELECT
Orders.Order_ID
,Customers.First_Name
,Customers.LastName
,Address.Address_Line1
,Address.Address_Line2
,Address.City
,Address.State
,Address.Zip_Code
,Orders.Tracking_ID
,Orders.Purchase_Date
,Orders.Delivery_Date
,Products.SKU
,Products.Product_Description

FROM Orders
INNER JOIN Customers
ON Customers.Customer_ID = Orders.Customer_ID
INNER JOIN Address
ON Address.Customer_ID = Orders.Customer_ID
INNER JOIN Order_Products
ON Order_Products.Order_ID = Orders.Order_ID
INNER JOIN Products
ON Products.Product_ID = Order_Products.Product_ID

WHERE Orders.Order_ID = 9
--WHERE Customers.Customer_ID = 1


--Generating an invoice 

SELECT
Orders.Order_ID
,Customers.First_Name
,Customers.LastName
,Address.Address_Line1
,Address.Address_Line2
,Address.City
,Address.State
,Address.Zip_Code
,Orders.Tracking_ID
,Orders.Purchase_Date
,Orders.Delivery_Date
,Products.SKU
,Products.Product_Description
,SUM(Products.Product_Price) AS SubTotal
,SUM(Products.Product_Price)*0.13 AS Taxes
,SUM(Products.Product_Price) + (SUM(Products.Product_Price)*0.13 ) as Total 
,COUNT(Products.SKU) AS Products_Quantity


FROM Orders
INNER JOIN Customers
ON Customers.Customer_ID = Orders.Customer_ID
INNER JOIN Address
ON Address.Customer_ID = Orders.Customer_ID
INNER JOIN Order_Products
ON Order_Products.Order_ID = Orders.Order_ID
INNER JOIN Products
ON Products.Product_ID = Order_Products.Product_ID

WHERE Orders.Order_ID = 33 --USE THE ORDER YOU WANT 

GROUP BY Orders.Order_ID
,Customers.First_Name
,Customers.LastName
,Address.Address_Line1
,Address.Address_Line2
,Address.City
,Address.State
,Address.Zip_Code
,Orders.Tracking_ID
,Orders.Purchase_Date
,Orders.Delivery_Date
,Products.SKU
,Products.Product_Description


--Checking amount of orders placed by ZIP code 

SELECT 
COUNT (Orders.Order_ID) AS Orders_Placed
,Address.Zip_Code

FROM Orders
INNER JOIN Customers
ON Customers.Customer_ID = Orders.Customer_ID
INNER JOIN Address
ON Address.Customer_ID = Orders.Customer_ID
INNER JOIN Order_Products
ON Order_Products.Order_ID = Orders.Order_ID

GROUP BY Zip_Code

--Checking total sales per day 

SELECT
Orders.Purchase_Date
,SUM(Products.Product_Price) AS Total_Revenue
,COUNT (DISTINCT Orders.Order_ID) AS Total_Orders
FROM Orders
INNER JOIN Order_Products
ON Orders.Order_ID = Order_Products.Order_ID
INNER JOIN Products
ON Products.Product_ID = Order_Products.Product_ID
GROUP BY 
Orders.Purchase_Date;

--Checking average orders per day

SELECT * FROM ORDERS;

WITH Total_Orders (Purchase_Date, Count_Orders)
AS
(
SELECT 
Purchase_Date
,COUNT(DISTINCT Order_ID) AS Total_Orders 
FROM Orders
GROUP BY Purchase_Date
)
SELECT
'Average orders placed by day ' AS Question
,AVG(Count_Orders) AS Answer
FROM Total_Orders;

--Checking the percentage of revenue difference between days with a window function  and CTE 

WITH Sales_Per_Day (Purchase_Date,Total_Revenue, Last_Day_Revenue, Total_Orders) AS
(
SELECT
Orders.Purchase_Date
,SUM(Products.Product_Price) AS Total_Revenue
,Last_Day_Revenue = LAG(SUM(Products.Product_Price),1) OVER (ORDER BY Orders.Purchase_Date)
,COUNT (DISTINCT Orders.Order_ID) AS Total_Orders
FROM Orders
INNER JOIN Order_Products
ON Orders.Order_ID = Order_Products.Order_ID
INNER JOIN Products
ON Products.Product_ID = Order_Products.Product_ID
GROUP BY 
Orders.Purchase_Date
)

SELECT 
*,ROUND((CONVERT(float,(Total_Revenue - Last_Day_Revenue))/CONVERT(float, Total_Revenue))*100,2) AS Percentage_Change
FROM Sales_Per_Day
WHERE Last_Day_Revenue IS NOT NULL

