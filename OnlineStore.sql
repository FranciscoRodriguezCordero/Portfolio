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

ALTER TABLE Products 
ADD SKU varchar(255) NOT NULL UNIQUE

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


---Creating Stored Procedures to Insert, Read , Update and Delete data from the tables 

---Procedure for registering a new customer 

CREATE PROCEDURE RegisterCustomer (
@First_Name varchar(255)
,@LastName varchar(255)
,@Email varchar (255)
)
AS 
	BEGIN
		IF(exists (SELECT * FROM dbo.Customers WHERE Email = @Email))
		BEGIN 
			SELECT 'THIS EMAIL ADDRESS IS ALREADY IN USE'
		END 
		ELSE 
			BEGIN 
				INSERT INTO Customers (First_Name,LastName,Email,Customer_Status) VALUES (@First_Name,@LastName,@Email,'ACTIVE')
				SELECT 'SUCCESS! USER REGISTERED IN THE DATABASE'
			END 
	END 

---- Registering customers using the stored proecedure 

EXEC RegisterCustomer 'Francisco', 'Rodriguez', 'frodri@gmail.com'
EXEC RegisterCustomer 'Javier', 'Cordero', 'jarocor@gmail.com'
EXEC RegisterCustomer 'Kevin', 'Araya', 'kevara@gmail.com'
EXEC RegisterCustomer 'Josue', 'Gutierrez', 'josugu@gmail.com'

---- Confirming values registered 
SELECT * FROM Customers


---Procedure for registering a customer's address 

CREATE PROCEDURE Register_Address 
(
@Customer_ID int
,@Address_Line1 varchar(255) 
,@Address_Line2 varchar(255)
,@City varchar(255)
,@State varchar(255)
,@Zip_Code varchar(255)
,@Phone_Number int
)
	AS
		BEGIN

		IF (exists(SELECT * FROM dbo.Customers WHERE Customer_ID = @Customer_ID))
		BEGIN
			INSERT INTO Address (Customer_ID, Address_Line1, Address_Line2,City,State,Zip_Code,Phone_Number,Address_Status) VALUES (@Customer_ID, @Address_Line1,@Address_Line2,@City,@State,@Zip_Code,@Phone_Number,'ACTIVE')
			SELECT 'SUCCESS! ADDRESS REGISTERED IN THE DATABASE'
		END 
			ELSE
			BEGIN
			SELECT 'ERROR, CHECK THE CUSTOMER ID'
			END

		END 

---- Registering addresses using the stored proecedure 

EXEC Register_Address 6,'Calle Garros','Apartamento 1','San Pedro','San Jose','11501',84848484 

---- Confirming values registered 
SELECT * FROM Address


---Procedure for registering a payment method 

CREATE PROCEDURE Register_Payment
(
@Card_Number bigint 
,@Expiration_Date date
,@Security_Code int
,@Cardholder_Name varchar(255)
,@Customer_ID int
)
	AS 
	BEGIN
			IF (exists(SELECT * FROM dbo.Customers WHERE Customer_ID = @Customer_ID))
			BEGIN
				INSERT INTO Payment (Card_Number,Expiration_Date,Security_Code,Cardholder_Name,PaymentStatus,Customer_ID) VALUES (@Card_Number,@Expiration_Date,@Security_Code,@Cardholder_Name,'ACTIVE',@Customer_ID)
				SELECT 'SUCCESS! PAYMENT METHOD REGISTERED IN THE DATABASE'
			END
			ELSE 
				BEGIN
				SELECT 'ERROR! CHECK THE CUSTOMER ID'
				END 

	END


---- Registering addresses using the stored proecedure 
EXEC Register_Payment 01234567891234, '2023-09-01',123,'Francisco Rodriguez',6

---- Confirming values registered 
SELECT * FROM Payment



---Procedure for registering products

SELECT * FROM Products
INSERT INTO Products (Product_Description,Product_Price,Product_Status,SKU) VALUES ('Shampoo para gatos', 7000,'ACTIVO','BM012FS4A')

CREATE PROCEDURE Register_Product 
(
@Product_Description varchar(255)
,@Product_Price float
,@SKU varchar(255)
)
	AS
	BEGIN
		IF (exists(SELECT * FROM Products WHERE SKU = @SKU))
			BEGIN
			SELECT ('THE SKU IS ALREADY REGISTERED')
			END
		ELSE
			BEGIN
			INSERT INTO Products (Product_Description,Product_Price,Product_Status,SKU) VALUES (@Product_Description, @Product_Price,'ACTIVO',@SKU)
			SELECT ('SUCCESS! PRODUCT REGISTERED IN THE DATABASE')
			END
	END
	
---- Registering products using the stored proecedure 

EXEC Register_Product 'Shampoo para perros',7000,'BM70NAHSF'

---- Confirming values registered 
SELECT * FROM Products


---Procedure for registering orders 

CREATE PROCEDURE Register_Order 
(
    @Customer_ID int,
    @Payment_ID int,
    @Address_ID int,
    @Delivery_Date date,
    @Tracking_ID varchar(255)
)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM Customers WHERE Customer_ID = @Customer_ID)
    BEGIN
        SELECT 'ERROR, CHECK THE CUSTOMER ID'
    END
    ELSE IF NOT EXISTS(SELECT * FROM Payment WHERE Payment_ID = @Payment_ID)
    BEGIN
        SELECT 'ERROR, CHECK THE PAYMENT ID'
    END
    ELSE IF NOT EXISTS(SELECT * FROM Address WHERE Address_ID = @Address_ID)
    BEGIN
        SELECT 'ERROR, CHECK THE ADDRESS ID'
    END
    ELSE
    BEGIN
        INSERT INTO Orders (Customer_ID, Payment_ID, Address_ID, Purchase_Date, Delivery_Date, Tracking_ID, Order_Status) 
			VALUES (@Customer_ID, @Payment_ID, @Address_ID, GETDATE(), @Delivery_Date, @Tracking_ID, 'ACTIVE')
        SELECT 'SUCCESS! ORDER REGISTERED IN THE DATABASE'
    END
END

---- Registering orders using the stored proecedure 

EXEC Register_Order 6,3,7,'2023-01-01','23131'

---- Confirming values registered 
SELECT * FROM Orders


---Procedure for linking Orders with Products 

SELECT * FROM Order_Products

CREATE PROCEDURE Register_Order_Products 
(
@Order_ID int
,@Product_ID int
)
	AS
	BEGIN
		IF(exists(SELECT * FROM Orders WHERE Order_ID = @Order_ID) AND exists(SELECT * FROM Products WHERE Product_ID = @Product_ID))
			BEGIN
				INSERT INTO Order_Products (Order_ID,Product_ID)
					VALUES (@Order_ID,@Product_ID)
			END
		ELSE
			BEGIN
				SELECT 'ERROR! CHECK EITHER THE PRODUCT ID OR THE ORDER ID'
			END
	END


---- Registering orders using the stored proecedure 

EXEC Register_Order_Products 1,0


---- Confirming values registered 
SELECT * FROM Order_Products


------------------------------
--Reading data and storing the pre built queries in Stored Procedures 

--Procedure for retreiving all customers details 

CREATE PROCEDURE GET_Customer_Details
	AS
		BEGIN
			SELECT 
				Customers.First_Name
				, Customers.LastName
				, Customers.Email
				, Customers.Customer_ID
				, Customers.Customer_Status
				, Address.Address_Line1
				, Address.Address_Line2
				, Address.City
				, Address.State
				, Address.Zip_Code
				, Address.Phone_Number

				FROM Address
				FULL OUTER JOIN Customers ON Address.Customer_ID = Customers.Customer_ID
	END

---- Confirming results 
EXEC GET_Customer_Details


--Procedure for retreiving a single customer by ID 
CREATE PROCEDURE GET_Customer_Details_By_ID
(
@Customer_ID int
)
	AS
		BEGIN
			SELECT 
				Customers.First_Name
				, Customers.LastName
				, Customers.Email
				, Customers.Customer_ID
				, Customers.Customer_Status
				, Address.Address_Line1
				, Address.Address_Line2
				, Address.City
				, Address.State
				, Address.Zip_Code
				, Address.Phone_Number

				FROM Address
				FULL OUTER JOIN Customers ON Address.Customer_ID = Customers.Customer_ID

				WHERE Customers.Customer_ID = @Customer_ID
	END

---- Confirming results 
EXEC GET_Customer_Details_By_ID 6


--Procedure for retreiving all addresses 
CREATE PROCEDURE GET_Addresses 
	AS
	BEGIN
		SELECT
			Address_ID
			,Customer_ID
			,Address_Line1
			,Address_Line2
			,City
			,Zip_Code
			,Phone_Number
			,Address_Status
			,Customer_ID
		FROM Address
	END

---- Confirming results 
EXEC GET_Addresses

--Procedure for retreiving an addresses by Customer_ID

CREATE PROCEDURE GET_Addresses_Customer_ID 
(
@Customer_ID int
)
	AS
	BEGIN
		SELECT
			Address_ID
			,Customer_ID
			,Address_Line1
			,Address_Line2
			,City
			,Zip_Code
			,Phone_Number
			,Address_Status
			,Customer_ID
		FROM Address
		WHERE Customer_ID = @Customer_ID
	END

---- Confirming results 
EXEC GET_Addresses_Customer_ID 6

--Procedure for retreiving an addresses by Address_ID

CREATE PROCEDURE GET_Addresses_Address_ID 
(
@Address_ID  varchar(255)
)
	AS
	BEGIN
		SELECT
			Address_ID
			,Customer_ID
			,Address_Line1
			,Address_Line2
			,City
			,Zip_Code
			,Phone_Number
			,Address_Status
			,Customer_ID
		FROM Address
		WHERE Address_ID = @Address_ID
	END

---- Confirming results 
EXEC GET_Addresses_Address_ID 1

--Procedure for retreiving all orders

CREATE PROCEDURE GET_Orders
	AS 
	BEGIN
		SELECT 
			Order_ID
			,Customer_ID
			,Payment_ID
			,Purchase_Date
			,Delivery_Date
			,Tracking_ID
			,Order_Status
			,Address_ID

		FROM Orders
	END
---- Confirming results 
EXEC GET_Orders

--Procedure for retreiving all orders by Customer_ID

CREATE PROCEDURE GET_Orders_Customer_ID
(
@Customer_ID int
)
	AS 
	BEGIN
		SELECT 
			Order_ID
			,Customer_ID
			,Payment_ID
			,Purchase_Date
			,Delivery_Date
			,Tracking_ID
			,Order_Status
			,Address_ID

		FROM Orders
		WHERE Customer_ID = @Customer_ID
	END

---- Confirming results 
EXEC GET_Orders_Customer_ID 6


--Procedure for retreiving all orders by Customer_ID

CREATE PROCEDURE GET_Orders_Order_ID
(
@Order_ID int
)
	AS 
	BEGIN
		SELECT 
			Order_ID
			,Customer_ID
			,Payment_ID
			,Purchase_Date
			,Delivery_Date
			,Tracking_ID
			,Order_Status
			,Address_ID

		FROM Orders
		WHERE Order_ID = @Order_ID
	END

---- Confirming results 
EXEC GET_Orders_Order_ID 1



--Procedure for retreiving all Products

CREATE PROCEDURE GET_Products 
	AS 
	BEGIN
	SELECT 
		Product_ID 
		,Product_Description
		,Product_Price
		,SKU
		,Product_Status
		FROM Products
	END

---- Confirming results 
EXEC GET_Products


--Procedure for retreiving all Products by ID

CREATE PROCEDURE GET_Products_Products_ID
(
@Product_ID int
)
	AS 
	BEGIN
	SELECT 
		Product_ID 
		,Product_Description
		,Product_Price
		,SKU
		,Product_Status
		FROM Products
		WHERE Product_ID = @Product_ID
	END

---- Confirming results 
EXEC GET_Products_Products_ID 1

--Procedure for retreiving all Products by SKU

CREATE PROCEDURE GET_Products_SKU
(
@SKU varchar(255)
)
	AS 
	BEGIN
	SELECT 
		Product_ID 
		,Product_Description
		,Product_Price
		,SKU
		,Product_Status
		FROM Products
		WHERE SKU = @SKU
	END

---- Confirming results 
EXEC GET_Products_SKU BM012FS4A


--Procedure for retreiving all Payment methods

CREATE PROCEDURE GET_Payment
	AS 
	BEGIN
	SELECT 
			Payment_ID
			,Card_Number
			,Expiration_Date
			,Security_Code
			,Cardholder_Name
			,PaymentStatus
			,Customer_ID
		FROM Payment
	END

---- Confirming results 
EXEC GET_Payment


--Procedure for retreiving all Products by ID

CREATE PROCEDURE GET_Payment_Payment_ID
(
@Payment_ID int
)
	AS 
	BEGIN
		SELECT 
				Payment_ID
				,Card_Number
				,Expiration_Date
				,Security_Code
				,Cardholder_Name
				,PaymentStatus
				,Customer_ID
			FROM Payment
				WHERE Payment_ID = @Payment_ID
	END

---- Confirming results 
EXEC GET_Payment_Payment_ID 3

--Procedure for retreiving all Products by SKU

CREATE PROCEDURE GET_Payment_Customer_ID
(
@Customer_ID int
)
	AS 
	BEGIN
		SELECT 
				Payment_ID
				,Card_Number
				,Expiration_Date
				,Security_Code
				,Cardholder_Name
				,PaymentStatus
				,Customer_ID
			FROM Payment
				WHERE Customer_ID  = @Customer_ID 
	END

---- Confirming results 
EXEC GET_Payment_Customer_ID 6



--Procedure for updating customer details by ID

CREATE PROCEDURE SET_Customer_Details_Customer_ID
(
@Customer_ID int
,@First_Name varchar(255)
,@LastName varchar(255)
,@Customer_Status varchar(255)
,@Email varchar(255)
)
	AS
	BEGIN
		UPDATE Customers 
		SET 
			First_Name= @First_Name
			,LastName=@LastName
			,Customer_Status=@Customer_Status
			,Email=@Email
				WHERE Customer_ID = @Customer_ID
	END 

---- Confirming results 
EXEC SET_Customer_Details_Customer_ID 10,'Jorge','Brenes','ACTIVE','brenjo@gmail.com'
SELECT * FROM Customers WHERE Customer_ID = 10

--Procedure for updating Orders by ID

SELECT * FROM Orders

ALTER PROCEDURE SET_Order_Order_ID
(
@Order_ID int
,@Customer_ID int
,@Payment_ID int
,@Purchase_Date date
,@Delivery_Date date
,@Tracking_ID varchar(255)
,@Order_Status varchar(255)
,@Address_ID int
)
	AS
	BEGIN
	UPDATE Orders 
		SET 
		
			Payment_ID = @Payment_ID
			,Purchase_Date = @Purchase_Date
			,Delivery_Date = @Delivery_Date
			,Tracking_ID = @Tracking_ID
			,Order_Status = @Order_ID
			,Address_ID = @Address_ID
				WHERE Order_ID = @Order_ID
	END

---- Confirming results 
SELECT * FROM Address
EXEC SET_Order_Order_ID 1,10,2,'2023-03-19','2023-03-24','AML2121455','INACTIVE',1