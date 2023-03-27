---Creating Stored Procedures to Insert, Read and Update data from the tables 
USE OnlineStore
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


---Procedure for registering products

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


---Procedure for linking Orders with Products 

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
				SELECT 'SUCCESS! PRODUCT(S) ASSIGNED TO THE ORDER IN THE DATABSE'
			END
		ELSE
			BEGIN
				SELECT 'ERROR! CHECK EITHER THE PRODUCT ID OR THE ORDER ID'
			END
	END


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
EXEC GET_Customer_Details_By_ID 1
EXEC GET_Customer_Details_By_ID 2
EXEC GET_Customer_Details_By_ID 3
EXEC GET_Customer_Details_By_ID 4


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
EXEC GET_Addresses_Customer_ID 1
EXEC GET_Addresses_Customer_ID 2
EXEC GET_Addresses_Customer_ID 3
EXEC GET_Addresses_Customer_ID 4

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
EXEC GET_Addresses_Address_ID 2
EXEC GET_Addresses_Address_ID 3
EXEC GET_Addresses_Address_ID 4

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
EXEC GET_Orders_Customer_ID 1
EXEC GET_Orders_Customer_ID 2
EXEC GET_Orders_Customer_ID 3
EXEC GET_Orders_Customer_ID 4


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
EXEC GET_Orders_Order_ID 2
EXEC GET_Orders_Order_ID 3
EXEC GET_Orders_Order_ID 4



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
EXEC GET_Products_Products_ID 2
EXEC GET_Products_Products_ID 3
EXEC GET_Products_Products_ID 4

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
EXEC GET_Products_SKU BM70NAHSF
EXEC GET_Products_SKU BM70122HSF
EXEC GET_Products_SKU BM70122AHS
EXEC GET_Products_SKU B5674NAHSF

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
EXEC GET_Payment_Payment_ID 1
EXEC GET_Payment_Payment_ID 2
EXEC GET_Payment_Payment_ID 3
EXEC GET_Payment_Payment_ID 4

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
EXEC GET_Payment_Customer_ID 1
EXEC GET_Payment_Customer_ID 2
EXEC GET_Payment_Customer_ID 3
EXEC GET_Payment_Customer_ID 4

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

CREATE PROCEDURE SET_Order_Order_ID
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
EXEC SET_Order_Order_ID 1,10,2,'2023-03-19','2023-03-24','AML2121455','INACTIVE',1
SELECT * FROM Orders


--Procedure for updating Address by Customer_Id
CREATE PROCEDURE SET_Address_Customer_ID
(
@Address_Line1 varchar(255)
,@Address_Line2 varchar(255)
,@City varchar(255)
,@State varchar(255)
,@Zip_Code varchar(255)
,@Phone_Number int
,@Address_Status varchar(255)
,@Customer_ID int
)
	AS
	BEGIN
		UPDATE Address
		SET 
			Address_Line1 = @Address_Line1
			,Address_Line2 =@Address_Line2
			,City = @City
			,State = @State
			,Zip_Code = @Zip_Code
			,Phone_Number = @Phone_Number
			,Address_Status = @Address_Status
			WHERE Customer_ID = @Customer_ID
	END

---- Confirming results 
SELECT * FROM Address
EXEC SET_Address_Customer_ID 'Calle Garros Bar','Apartamento 5', 'San Pedro','San Jose','11501',87878787,'ACTIVE',6

--Procedure for updating Address by Customer_Id

CREATE PROCEDURE SET_Products_SKU
(
@SKU varchar(255)
,@Product_Description varchar(255)
,@Product_Price float
,@Product_Status varchar(255)
)
	AS
	BEGIN
		UPDATE Products
		SET
			Product_Description= @Product_Description
			,Product_Price = @Product_Price
			,Product_Status = @Product_Status
			WHERE SKU = @SKU
	END

---- Confirming results 

EXEC SET_Products_SKU 'BM012FS4A','Shampoo para caballo',14000,'ACTIVO'
SELECT * FROM Products

--Procedure for updating Payment by Customer_Id

CREATE PROCEDURE SET_Payment_Customer_ID
(
@CardNumber bigint 
,@Expiration_Date date
,@Security_Code int
,@Cardholder_Name varchar(255)
,@Payment_Status varchar(255)
,@Customer_ID int 
)
	AS
	BEGIN
		UPDATE Payment
		SET 
			Card_Number = @CardNumber
			,Expiration_Date = @Expiration_Date
			,Security_Code = @Security_Code
			,Cardholder_Name = @Cardholder_Name
			,PaymentStatus = @Payment_Status
			WHERE Customer_ID = @Customer_ID
	END

---- Confirming results 
EXEC SET_Payment_Customer_ID 1234567891234,'2023-09-01',321,'Francisco Cordero','ACTIVE',6

SELECT * FROM Payment
