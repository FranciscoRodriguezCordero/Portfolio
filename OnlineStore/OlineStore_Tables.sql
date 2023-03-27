--Database project for an online store--

--Creating database 

CREATE DATABASE OnlineStore

USE OnlineStore

--Creating tables
------------------------------

--Customers table

CREATE TABLE Customers (
Customer_ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
First_Name varchar(255) NOT NULL,
LastName varchar(255),
Email varchar(255) NOT NULL UNIQUE,
Customer_Status varchar(255)
)

------------------------------

--Payment  table

CREATE TABLE Payment (
Customer_ID int NOT NULL FOREIGN KEY REFERENCES Customers(Customer_ID),
Payment_ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
Card_Number bigint,
Expiration_Date date,
Security_Code int,
Cardholder_Name varchar(255),
PaymentStatus varchar(255)
)

------------------------------

--Address Table 

CREATE TABLE Address (
Address_ID int NOT NULL PRIMARY KEY IDENTITY(1,1), 
Customer_ID int NOT NULL FOREIGN KEY REFERENCES Customers(Customer_ID),
Address_Line1 varchar(255),
Address_Line2 varchar(255),
City varchar(255),
State varchar(255),
Zip_Code varchar(255),
Phone_Number int,
Address_Status varchar(255)
)

------------------------------

--Orders table 

CREATE TABLE Orders(
Order_ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
Customer_ID int NOT NULL FOREIGN KEY REFERENCES Customers(Customer_ID),
Payment_ID int FOREIGN KEY REFERENCES Payment(Payment_ID), 
Address_ID int FOREIGN KEY REFERENCES Address(Address_ID),
Purchase_Date date, 
Delivery_Date date, 
Tracking_ID varchar(255),
Order_Status varchar(255)
)

------------------------------

--Products Table 
CREATE TABLE Products(
Product_ID INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
Product_Description varchar(255),
Product_Price float, 
SKU varchar(255) NOT NULL UNIQUE,
Product_Status varchar(255)
)


------------------------------

--Order_Products table 

CREATE TABLE  Order_Products(
Order_ID int NOT NULL FOREIGN KEY REFERENCES Orders(Order_ID),
Product_ID int NOT NULL FOREIGN KEY REFERENCES Products(Product_ID), 
)

------------------------------