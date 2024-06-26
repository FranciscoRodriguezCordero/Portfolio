CREATE DATABASE DB_WU_SAMPLE

USE DB_WU_SAMPLE;

---DATABASE TABLES 
CREATE TABLE CUSTOMERS (
    CUSTOMER_ID INT PRIMARY KEY IDENTITY(1,1)
    ,FIRST_NAME NVARCHAR(50)
    ,LAST_NAME NVARCHAR(50)
    ,DATE_OF_BIRTH DATE
    ,EMAIL NVARCHAR(100)
);

CREATE TABLE ACCOUNTS (
    ACCOUNT_ID INT PRIMARY KEY IDENTITY(1,1)
    ,CUSTOMER_ID INT
    ,ACCOUNT_TYPE NVARCHAR(50)
    ,BALANCE DECIMAL(10, 2)
    ,FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID)
);

CREATE TABLE TRANSACTION_TYPE (
    TRANSACTION_TYPE_ID INT PRIMARY KEY IDENTITY(1,1)
    ,TRANSACTION_TYPE_NAME NVARCHAR(50)
);

CREATE TABLE COUNTRIES (
    COUNTRY_ID INT PRIMARY KEY IDENTITY(1,1)
    ,COUNTRY_NAME NVARCHAR(50)
);

CREATE TABLE CUSTOMERS_COUNTRIES (
    CUSTOMER_ID INT
    ,COUNTRY_ID INT
    ,FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID)
    ,FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRIES(COUNTRY_ID)
    ,PRIMARY KEY (CUSTOMER_ID, COUNTRY_ID)
);

CREATE TABLE TRANSACTIONS (
    TRANSACTION_ID INT PRIMARY KEY IDENTITY(1,1)
    ,ACCOUNT_ID INT
    ,TRANSACTION_DATE DATETIME
    ,AMOUNT DECIMAL(10, 2)
    ,TRANSACTION_TYPE_ID INT
    ,COUNTRY_ID INT
    ,FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNTS(ACCOUNT_ID)
    ,FOREIGN KEY (TRANSACTION_TYPE_ID) REFERENCES TRANSACTION_TYPE(TRANSACTION_TYPE_ID)
    ,FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRIES(COUNTRY_ID)
);

---Forgot to add sender in the transactions table. Modifying table to add new column
ALTER TABLE TRANSACTIONS
ADD SENDER_ACCOUNT_ID INT
    ,RECIPIENT_ACCOUNT_ID INT;

ALTER TABLE TRANSACTIONS
ADD CONSTRAINT FK_TRANSACTIONS_SENDER_ACCOUNT 
		FOREIGN KEY (SENDER_ACCOUNT_ID) REFERENCES ACCOUNTS(ACCOUNT_ID)
    ,CONSTRAINT FK_TRANSACTIONS_RECIPIENT_ACCOUNT 
		FOREIGN KEY (RECIPIENT_ACCOUNT_ID) REFERENCES ACCOUNTS(ACCOUNT_ID);


CREATE TABLE ALERTS (
    ALERT_ID INT PRIMARY KEY IDENTITY(1,1)
    ,TRANSACTION_ID INT
    ,ALERT_DATE DATETIME
    ,ALERT_DESCRIPTION NVARCHAR(255)
    ,FOREIGN KEY (TRANSACTION_ID) REFERENCES TRANSACTIONS(TRANSACTION_ID)
);


---STORED PROCEDURES---

CREATE OR ALTER PROCEDURE InsertCustomer
    @FirstName NVARCHAR(50)
    ,@LastName NVARCHAR(50)
    ,@DateOfBirth DATE
    ,@Email NVARCHAR(100)
AS
BEGIN
    INSERT INTO CUSTOMERS (FIRST_NAME, LAST_NAME, DATE_OF_BIRTH, EMAIL)
    VALUES (@FirstName, @LastName, @DateOfBirth, @Email);
END;

CREATE OR ALTER PROCEDURE InsertAccount
    @CustomerID INT
    ,@AccountType NVARCHAR(50)
    ,@Balance DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO ACCOUNTS (CUSTOMER_ID, ACCOUNT_TYPE, BALANCE)
    VALUES (@CustomerID, @AccountType, @Balance);
END;


CREATE OR ALTER PROCEDURE InsertTransactionType
    @TransactionTypeName NVARCHAR(50)
AS
BEGIN
    INSERT INTO TRANSACTION_TYPE (TRANSACTION_TYPE_NAME)
    VALUES (@TransactionTypeName);
END;


CREATE OR ALTER PROCEDURE InsertCountry
    @CountryName NVARCHAR(50)
AS
BEGIN
    INSERT INTO COUNTRIES (COUNTRY_NAME)
    VALUES (@CountryName);
END;


CREATE OR ALTER PROCEDURE InsertCustomerCountry
    @CustomerID INT
    ,@CountryID INT
AS
BEGIN
    INSERT INTO CUSTOMERS_COUNTRIES (CUSTOMER_ID, COUNTRY_ID)
    VALUES (@CustomerID, @CountryID);
END;


CREATE OR ALTER PROCEDURE InsertTransaction
    @SenderAccountID INT
    ,@RecipientAccountID INT
    ,@TransactionDate DATETIME
    ,@Amount DECIMAL(10, 2)
    ,@TransactionTypeID INT
    ,@CountryID INT
AS
BEGIN
    INSERT INTO TRANSACTIONS (SENDER_ACCOUNT_ID, RECIPIENT_ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, TRANSACTION_TYPE_ID, COUNTRY_ID)
    VALUES (@SenderAccountID, @RecipientAccountID, @TransactionDate, @Amount, @TransactionTypeID, @CountryID);
END;


CREATE OR ALTER PROCEDURE InsertAlert
    @TransactionID INT
    ,@AlertDate DATETIME
    ,@AlertDescription NVARCHAR(255)
AS
BEGIN
    INSERT INTO ALERTS (TRANSACTION_ID, ALERT_DATE, ALERT_DESCRIPTION)
    VALUES (@TransactionID, @AlertDate, @AlertDescription);
END;

---TRIGGERS--- 

CREATE OR ALTER TRIGGER trg_InsertAlertOnHighValueTransaction
ON TRANSACTIONS
AFTER INSERT
AS
BEGIN
    -- Insert into ALERTS if conditions are met
    INSERT INTO ALERTS (TRANSACTION_ID, ALERT_DATE, ALERT_DESCRIPTION)
    SELECT 
        I.TRANSACTION_ID,
        GETDATE(),
        'High-value transaction from US to a non-US country'
    FROM 
        INSERTED I
    JOIN 
        ACCOUNTS SA ON I.SENDER_ACCOUNT_ID = SA.ACCOUNT_ID
    JOIN 
        CUSTOMERS SCU ON SA.CUSTOMER_ID = SCU.CUSTOMER_ID
    JOIN 
        CUSTOMERS_COUNTRIES SCC ON SCU.CUSTOMER_ID = SCC.CUSTOMER_ID
    JOIN 
        COUNTRIES SC ON SCC.COUNTRY_ID = SC.COUNTRY_ID
    JOIN 
        ACCOUNTS RA ON I.RECIPIENT_ACCOUNT_ID = RA.ACCOUNT_ID
    JOIN 
        CUSTOMERS RCU ON RA.CUSTOMER_ID = RCU.CUSTOMER_ID
    JOIN 
        CUSTOMERS_COUNTRIES RCC ON RCU.CUSTOMER_ID = RCC.CUSTOMER_ID
    JOIN 
        COUNTRIES RC ON RCC.COUNTRY_ID = RC.COUNTRY_ID
    WHERE 
        I.AMOUNT > 10000 
        AND SC.COUNTRY_NAME = 'United States'
        AND RC.COUNTRY_NAME <> 'United States';
END;


---Feeding Tables with data---
--Customers 
EXEC InsertCustomer 'John', 'Doe', '1985-01-15', 'john.doe@example.com'; -- US
EXEC InsertCustomer 'Jane', 'Smith', '1990-07-23', 'jane.smith@example.com'; -- US
EXEC InsertCustomer 'Carlos', 'Martinez', '1978-05-12', 'carlos.martinez@example.com'; -- Mexico
EXEC InsertCustomer 'Maria', 'Gonzalez', '1988-11-04', 'maria.gonzalez@example.com'; -- Mexico
EXEC InsertCustomer 'Jose', 'Rodriguez', '1982-08-19', 'jose.rodriguez@example.com'; -- Colombia
EXEC InsertCustomer 'Ana', 'Garcia', '1992-03-25', 'ana.garcia@example.com'; -- Colombia
EXEC InsertCustomer 'Luis', 'Lopez', '1975-12-30', 'luis.lopez@example.com'; -- Argentina
EXEC InsertCustomer 'Sofia', 'Perez', '1980-07-09', 'sofia.perez@example.com'; -- Argentina
EXEC InsertCustomer 'Pedro', 'Hernandez', '1995-09-17', 'pedro.hernandez@example.com'; -- Chile
EXEC InsertCustomer 'Isabella', 'Fernandez', '1983-02-22', 'isabella.fernandez@example.com'; -- Chile

--Accounts 

EXEC InsertAccount 1, 'Checking', 5000.00; -- Account for John Doe (US)
EXEC InsertAccount 2, 'Savings', 15000.00; -- Account for Jane Smith (US)
EXEC InsertAccount 3, 'Checking', 7000.00; -- Account for Carlos Martinez (Mexico)
EXEC InsertAccount 4, 'Savings', 20000.00; -- Account for Maria Gonzalez (Mexico)
EXEC InsertAccount 5, 'Checking', 9000.00; -- Account for Jose Rodriguez (Colombia)
EXEC InsertAccount 6, 'Savings', 12000.00; -- Account for Ana Garcia (Colombia)
EXEC InsertAccount 7, 'Checking', 8000.00; -- Account for Luis Lopez (Argentina)
EXEC InsertAccount 8, 'Savings', 14000.00; -- Account for Sofia Perez (Argentina)
EXEC InsertAccount 9, 'Checking', 6000.00; -- Account for Pedro Hernandez (Chile)
EXEC InsertAccount 10, 'Savings', 16000.00; -- Account for Isabella Fernandez (Chile)

--Transaction Types

EXEC InsertTransactionType 'Deposit';       -- Transaction Type 1
EXEC InsertTransactionType 'Withdrawal';    -- Transaction Type 2
EXEC InsertTransactionType 'Transfer';      -- Transaction Type 3
EXEC InsertTransactionType 'Payment';       -- Transaction Type 4
EXEC InsertTransactionType 'Refund';        -- Transaction Type 5

--Countries 
EXEC InsertCountry 'United States';   -- Country ID 1
EXEC InsertCountry 'Mexico';          -- Country ID 2
EXEC InsertCountry 'Colombia';        -- Country ID 3
EXEC InsertCountry 'Argentina';       -- Country ID 4
EXEC InsertCountry 'Chile';           -- Country ID 5

--Countries_Customers 
EXEC InsertCustomerCountry 1, 1; -- John Doe (US)
EXEC InsertCustomerCountry 2, 1; -- Jane Smith (US)
EXEC InsertCustomerCountry 3, 2; -- Carlos Martinez (Mexico)
EXEC InsertCustomerCountry 4, 2; -- Maria Gonzalez (Mexico)
EXEC InsertCustomerCountry 5, 3; -- Jose Rodriguez (Colombia)
EXEC InsertCustomerCountry 6, 3; -- Ana Garcia (Colombia)
EXEC InsertCustomerCountry 7, 4; -- Luis Lopez (Argentina)
EXEC InsertCustomerCountry 8, 4; -- Sofia Perez (Argentina)
EXEC InsertCustomerCountry 9, 5; -- Pedro Hernandez (Chile)
EXEC InsertCustomerCountry 10, 5; -- Isabella Fernandez (Chile)

--Transactions 

EXEC InsertTransaction 1, 3, '2024-06-25 10:00:00', 15000.00, 3, 2; 
EXEC InsertTransaction 2, 5, '2024-06-25 11:00:00', 20000.00, 3, 3; 
EXEC InsertTransaction 1, 7, '2024-06-25 12:00:00', 25000.00, 3, 4; 
EXEC InsertTransaction 2, 9, '2024-06-25 13:00:00', 30000.00, 3, 5; 
EXEC InsertTransaction 1, 4, '2024-06-25 14:00:00', 11000.00, 3, 2; 
EXEC InsertTransaction 2, 6, '2024-06-25 15:00:00', 12000.00, 3, 3; 
EXEC InsertTransaction 1, 8, '2024-06-25 16:00:00', 13000.00, 3, 4; 
EXEC InsertTransaction 2, 10, '2024-06-25 17:00:00', 14000.00, 3, 5; 
EXEC InsertTransaction 1, 3, '2024-06-25 18:00:00', 16000.00, 3, 2; 
EXEC InsertTransaction 2, 5, '2024-06-25 19:00:00', 17000.00, 3, 3; 
EXEC InsertTransaction 3, 1, '2024-06-25 20:00:00', 9000.00, 3, 1; 
EXEC InsertTransaction 4, 2, '2024-06-25 21:00:00', 8000.00, 3, 1; 
EXEC InsertTransaction 5, 1, '2024-06-25 22:00:00', 7000.00, 3, 1; 
EXEC InsertTransaction 6, 2, '2024-06-25 23:00:00', 6000.00, 3, 1; 
EXEC InsertTransaction 7, 1, '2024-06-26 00:00:00', 5000.00, 3, 1; 
EXEC InsertTransaction 8, 2, '2024-06-26 01:00:00', 4000.00, 3, 1; 
EXEC InsertTransaction 9, 1, '2024-06-26 02:00:00', 3000.00, 3, 1;
EXEC InsertTransaction 10, 2, '2024-06-26 03:00:00', 2000.00, 3, 1; 
EXEC InsertTransaction 3, 5, '2024-06-26 04:00:00', 500.00, 3, 3; 
EXEC InsertTransaction 4, 7, '2024-06-26 05:00:00', 1000.00, 3, 4;
EXEC InsertTransaction 3, 1, '2024-06-26 10:00:00', 8000.00, 3, 1; 
EXEC InsertTransaction 4, 2, '2024-06-26 11:00:00', 7000.00, 3, 1; 
EXEC InsertTransaction 5, 1, '2024-06-26 12:00:00', 6000.00, 3, 1; 
EXEC InsertTransaction 6, 2, '2024-06-26 13:00:00', 5000.00, 3, 1; 
EXEC InsertTransaction 7, 1, '2024-06-26 14:00:00', 4000.00, 3, 1; 
EXEC InsertTransaction 8, 2, '2024-06-26 15:00:00', 3000.00, 3, 1; 
EXEC InsertTransaction 9, 1, '2024-06-26 16:00:00', 2000.00, 3, 1; 
EXEC InsertTransaction 10, 2, '2024-06-26 17:00:00', 1000.00, 3, 1; 
EXEC InsertTransaction 3, 5, '2024-06-26 18:00:00', 500.00, 3, 3; 
EXEC InsertTransaction 4, 7, '2024-06-26 19:00:00', 1000.00, 3, 4; 
EXEC InsertTransaction 5, 3, '2024-06-26 20:00:00', 12000.00, 3, 5;
EXEC InsertTransaction 6, 4, '2024-06-26 21:00:00', 3000.00, 3, 2; 
EXEC InsertTransaction 7, 5, '2024-06-26 22:00:00', 14000.00, 3, 3; 
EXEC InsertTransaction 8, 6, '2024-06-26 23:00:00', 5000.00, 3, 4; 
EXEC InsertTransaction 9, 7, '2024-06-27 00:00:00', 6000.00, 3, 5; 
EXEC InsertTransaction 10, 8, '2024-06-27 01:00:00', 7000.00, 3, 2; 
EXEC InsertTransaction 3, 9, '2024-06-27 02:00:00', 8000.00, 3, 3; 
EXEC InsertTransaction 1, 10, '2024-06-27 03:00:00', 9000.00, 3, 4; 
EXEC InsertTransaction 1, 1, '2024-06-27 04:00:00', 10000.00, 3, 5; 
EXEC InsertTransaction 1, 2, '2024-06-27 05:00:00', 11000.00, 3, 2; 
EXEC InsertTransaction 2, 1, '2024-06-27 10:00:00', 12000.00, 3, 2; 
EXEC InsertTransaction 2, 2, '2024-06-27 11:00:00', 13000.00, 3, 3; 
EXEC InsertTransaction 1, 1, '2024-06-27 12:00:00', 14000.00, 3, 4; 
EXEC InsertTransaction 2, 2, '2024-06-27 13:00:00', 15000.00, 3, 5; 
EXEC InsertTransaction 1, 5, '2024-06-27 14:00:00', 16000.00, 3, 2; 
EXEC InsertTransaction 1, 2, '2024-06-27 15:00:00', 17000.00, 3, 3; 
EXEC InsertTransaction 2, 5, '2024-06-27 16:00:00', 18000.00, 3, 4; 
EXEC InsertTransaction 1, 5, '2024-06-27 17:00:00', 19000.00, 3, 5; 
EXEC InsertTransaction 3, 5, '2024-06-27 18:00:00', 20000.00, 3, 2; 
EXEC InsertTransaction 4, 7, '2024-06-27 19:00:00', 21000.00, 3, 3; 
EXEC InsertTransaction 5, 3, '2024-06-27 20:00:00', 22000.00, 3, 4; 
EXEC InsertTransaction 6, 4, '2024-06-27 21:00:00', 23000.00, 3, 5; 
EXEC InsertTransaction 7, 5, '2024-06-27 22:00:00', 24000.00, 3, 2; 
EXEC InsertTransaction 8, 6, '2024-06-27 23:00:00', 25000.00, 3, 3; 
EXEC InsertTransaction 9, 7, '2024-06-28 00:00:00', 26000.00, 3, 4; 
EXEC InsertTransaction 10, 8, '2024-06-28 01:00:00', 27000.00, 3, 5; 
EXEC InsertTransaction 3, 1, '2024-06-28 02:00:00', 5000.00, 3, 1; 
EXEC InsertTransaction 4, 2, '2024-06-28 03:00:00', 4000.00, 3, 1; 
EXEC InsertTransaction 5, 1, '2024-06-28 04:00:00', 3000.00, 3, 1; 
EXEC InsertTransaction 6, 2, '2024-06-28 05:00:00', 2000.00, 3, 1; 
EXEC InsertTransaction 7, 1, '2024-06-28 06:00:00', 1000.00, 3, 1; 
EXEC InsertTransaction 8, 2, '2024-06-28 07:00:00', 9000.00, 3, 1; 
EXEC InsertTransaction 9, 1, '2024-06-28 08:00:00', 8000.00, 3, 1; 
EXEC InsertTransaction 10, 2, '2024-06-28 09:00:00', 7000.00, 3, 1; 
EXEC InsertTransaction 3, 5, '2024-06-28 10:00:00', 6000.00, 3, 3; 
EXEC InsertTransaction 4, 7, '2024-06-28 11:00:00', 5000.00, 3, 4; 
EXEC InsertTransaction 2, 3, '2024-06-28 12:00:00', 14000.00, 3, 5; 
EXEC InsertTransaction 2, 4, '2024-06-28 13:00:00', 13000.00, 3, 2; 
EXEC InsertTransaction 2, 5, '2024-06-28 14:00:00', 12000.00, 3, 3; 
EXEC InsertTransaction 1, 6, '2024-06-28 15:00:00', 11000.00, 3, 4; 
EXEC InsertTransaction 1, 7, '2024-06-28 16:00:00', 12500.00, 3, 5; 
EXEC InsertTransaction 1, 8, '2024-06-28 17:00:00', 33100.00, 3, 2; 
EXEC InsertTransaction 3, 1, '2024-06-28 18:00:00', 11000.00, 3, 2; 
EXEC InsertTransaction 4, 2, '2024-06-28 19:00:00', 12000.00, 3, 3; 
EXEC InsertTransaction 5, 1, '2024-06-28 20:00:00', 13000.00, 3, 4; 
EXEC InsertTransaction 6, 2, '2024-06-28 21:00:00', 14000.00, 3, 5; 
EXEC InsertTransaction 7, 1, '2024-06-28 22:00:00', 15000.00, 3, 2; 
EXEC InsertTransaction 8, 2, '2024-06-28 23:00:00', 16000.00, 3, 3; 
EXEC InsertTransaction 9, 1, '2024-06-29 00:00:00', 17000.00, 3, 4; 
EXEC InsertTransaction 1, 2, '2024-06-29 01:00:00', 18000.00, 3, 5; 
EXEC InsertTransaction 1, 5, '2024-06-29 02:00:00', 19000.00, 3, 2;
EXEC InsertTransaction 1, 7, '2024-06-29 03:00:00', 20000.00, 3, 3;
EXEC InsertTransaction 2, 3, '2024-06-29 04:00:00', 21000.00, 3, 4; 
EXEC InsertTransaction 2, 4, '2024-06-29 05:00:00', 22000.00, 3, 5; 
EXEC InsertTransaction 2, 5, '2024-06-29 06:00:00', 23000.00, 3, 2; 
EXEC InsertTransaction 1, 6, '2024-06-29 07:00:00', 24000.00, 3, 3; 
EXEC InsertTransaction 1, 7, '2024-06-29 08:00:00', 25000.00, 3, 4; 
EXEC InsertTransaction 10, 8, '2024-06-29 09:00:00', 26000.00, 3, 5; 
EXEC InsertTransaction 3, 1, '2024-06-29 10:00:00', 5000.00, 3, 1; 
EXEC InsertTransaction 4, 2, '2024-06-29 11:00:00', 4000.00, 3, 1; 
EXEC InsertTransaction 5, 1, '2024-06-29 12:00:00', 3000.00, 3, 1; 
EXEC InsertTransaction 6, 2, '2024-06-29 13:00:00', 2000.00, 3, 1; 
EXEC InsertTransaction 7, 1, '2024-06-29 14:00:00', 1000.00, 3, 1; 
EXEC InsertTransaction 8, 2, '2024-06-29 15:00:00', 9000.00, 3, 1; 
EXEC InsertTransaction 9, 1, '2024-06-29 16:00:00', 8000.00, 3, 1; 
EXEC InsertTransaction 1, 2, '2024-06-29 17:00:00', 7000.00, 3, 1; 
EXEC InsertTransaction 2, 5, '2024-06-29 18:00:00', 6000.00, 3, 3; 
EXEC InsertTransaction 2, 7, '2024-06-29 19:00:00', 5000.00, 3, 4; 


--Query All In One 
SELECT 
    T.TRANSACTION_ID
    ,T.SENDER_ACCOUNT_ID
    ,SA.ACCOUNT_TYPE AS SENDER_ACCOUNT_TYPE
    ,SA.BALANCE AS SENDER_BALANCE
    ,T.RECIPIENT_ACCOUNT_ID
    ,RA.ACCOUNT_TYPE AS RECIPIENT_ACCOUNT_TYPE
    ,RA.BALANCE AS RECIPIENT_BALANCE
    ,T.TRANSACTION_DATE
    ,T.AMOUNT
    ,T.TRANSACTION_TYPE_ID
    ,TT.TRANSACTION_TYPE_NAME
    ,T.COUNTRY_ID
    ,C.COUNTRY_NAME AS RECIEVING_COUNTRY
    ,CASE WHEN AL.ALERT_ID IS NOT NULL THEN 'Yes' ELSE 'No' END AS IS_ALERT
FROM 
    TRANSACTIONS T
JOIN 
    ACCOUNTS SA ON T.SENDER_ACCOUNT_ID = SA.ACCOUNT_ID
JOIN 
    ACCOUNTS RA ON T.RECIPIENT_ACCOUNT_ID = RA.ACCOUNT_ID
JOIN 
    TRANSACTION_TYPE TT ON T.TRANSACTION_TYPE_ID = TT.TRANSACTION_TYPE_ID
JOIN 
    COUNTRIES C ON T.COUNTRY_ID = C.COUNTRY_ID
LEFT JOIN 
    ALERTS AL ON T.TRANSACTION_ID = AL.TRANSACTION_ID;
