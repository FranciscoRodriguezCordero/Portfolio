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
--,Products.SKU
--,Products.Product_Description
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
,SUM(Products.Product_Price)
,COUNT (DISTINCT Orders.Order_ID)
--INTO #Sales_Date
FROM Orders
INNER JOIN Order_Products
ON Orders.Order_ID = Order_Products.Order_ID
INNER JOIN Products
ON Products.Product_ID = Order_Products.Product_ID
GROUP BY 
Orders.Purchase_Date

