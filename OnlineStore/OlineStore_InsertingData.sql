--Inserting Data to the database

USE OnlineStore

---- Registering Customers using the stored proecedure 

EXEC RegisterCustomer 'Francisco', 'Rodriguez', 'frodri@gmail.com'
EXEC RegisterCustomer 'Javier', 'Cordero', 'jarocor@gmail.com'
EXEC RegisterCustomer 'Kevin', 'Araya', 'kevara@gmail.com'
EXEC RegisterCustomer 'Josue', 'Gutierrez', 'josugu@gmail.com'

EXEC RegisterCustomer 'Jorge', 'Brenes', 'brenjor@gmail.com'
EXEC RegisterCustomer 'Pedro', 'Alvarado', 'alpe@gmail.com'
EXEC RegisterCustomer 'David', 'Sosa', 'dasosa@gmail.com'
EXEC RegisterCustomer 'Andres', 'Hernandez', 'andeher@gmail.com'

---- Registering Addresses using the stored proecedure 

EXEC Register_Address 1,'Avenida Central','Casa 10','San Jose','San Jose','11501',80808080 
EXEC Register_Address 2,'Calle Garros','Apartamento 1','San Pedro','San Jose','11502',84848484 
EXEC Register_Address 3,'Mall Don Pancho','Apartamento 11','Patalillo','Coronado','11503',85858585 
EXEC Register_Address 4,'Guayabos Sur','Casa 234','Concepcion','Union','11504',84848484 

EXEC Register_Address 5,'Avenida Segunda','Casa 11','San Jose','San Jose','11501',80808081 
EXEC Register_Address 6,'Calle Masis','Apartamento 13','Cedros','San Jose','11502',84848482 
EXEC Register_Address 7,'Dulce Nombre','Apartamento 112','Dulce Nombre','Coronado','11503',85858583
EXEC Register_Address 8,'Guayabos Sur','Casa 234','Concepcion','Union','11504',84848485 

---- Registering Payments using the stored proecedure 

EXEC Register_Payment 0123456789123456, '2023-09-01',123,'Francisco Rodriguez',1
EXEC Register_Payment 9876543210123456, '2023-09-02',123,'Josue Gutierrez',2
EXEC Register_Payment 5678901234567890, '2023-09-03',123,'Kevin Araya',3
EXEC Register_Payment 9876540123456789, '2023-09-04',123,'Javier Cordero',4

EXEC Register_Payment 0123456789123451, '2023-09-05',123,'Francisco Rodriguez',5
EXEC Register_Payment 9876543210123452, '2023-09-06',123,'Pedro Alvarado',6
EXEC Register_Payment 5678901234567893, '2023-09-07',123,'David Sosa',7
EXEC Register_Payment 9876540123456784, '2023-09-08',123,'Andres Hernandez',8

---- Registering Products using the stored proecedure 

EXEC Register_Product 'Shampoo para perros',7000,'BM70NAHSF'
EXEC Register_Product 'Shampoo para gatos',7000,'BM70122HSF'
EXEC Register_Product 'Shampoo para conejos',7000,'BM70122AHS'
EXEC Register_Product 'Shampoo para caballos',7000,'B5674NAHSF'

EXEC Register_Product 'Comida para perros',8000,'BN70NAHSF'
EXEC Register_Product 'Comida para gatos',9000,'BN70122HSF'
EXEC Register_Product 'Comida para conejos',10000,'BN70122AHS'
EXEC Register_Product 'Comida para caballos',11000,'BN674NAHSF'

---- Registering Orders using the stored proecedure 

--Day 1 placing orders
EXEC Register_Order 1,4,1,'2023-01-05','TBM923456781'
EXEC Register_Order 2,3,2,'2023-01-06','TBM923456782'
EXEC Register_Order 3,2,3,'2023-01-07','TBM923456783'
EXEC Register_Order 4,1,4,'2023-01-08','TBM923456784'

EXEC Register_Order 5,5,5,'2023-01-09','TBM923456785'
EXEC Register_Order 6,6,6,'2023-01-09','TBM923456786'
EXEC Register_Order 7,7,7,'2023-01-11','TBM923456787'
EXEC Register_Order 8,8,8,'2023-01-12','TBM923456788'


--Day 2 placing orders
EXEC Register_Order 5,5,5,'2023-01-09','TBM923456780'
EXEC Register_Order 6,6,6,'2023-01-09','TBM923456781'
EXEC Register_Order 7,7,7,'2023-01-11','TBM923456782'
EXEC Register_Order 8,8,8,'2023-01-12','TBM923456783'

EXEC Register_Order 1,4,1,'2023-02-05','TBM923456784'
EXEC Register_Order 2,3,2,'2023-02-06','TBM923456785'
EXEC Register_Order 3,2,3,'2023-02-07','TBM923456786'
EXEC Register_Order 4,1,4,'2023-02-08','TBM923456787'

EXEC Register_Order 5,5,5,'2023-03-09','TBM923456788'
EXEC Register_Order 6,6,6,'2023-03-09','TBM923456789'
EXEC Register_Order 7,7,7,'2023-03-11','TBM923456780'
EXEC Register_Order 8,8,8,'2023-03-12','TBM923456781'

EXEC Register_Order 5,5,5,'2023-04-09','TBM923456782'
EXEC Register_Order 6,6,6,'2023-04-09','TBM993456783'
EXEC Register_Order 7,7,7,'2023-04-11','TBM923456784'
EXEC Register_Order 8,8,8,'2023-04-12','TBM923456785'



--Day 3 placing orders
EXEC Register_Order 8,8,8,'2023-05-05','TBM923456781'
EXEC Register_Order 8,8,8,'2023-05-06','TBM923456782'
EXEC Register_Order 8,8,8,'2023-05-07','TBM923456783'
EXEC Register_Order 8,8,8,'2023-05-08','TBM923456784'

EXEC Register_Order 1,1,1,'2023-06-09','TBM923456785'
EXEC Register_Order 1,1,1,'2023-06-09','TBM923456786'
EXEC Register_Order 1,1,1,'2023-06-11','TBM923456787'
EXEC Register_Order 1,1,1,'2023-06-12','TBM923456788'

EXEC Register_Order 3,3,3,'2023-07-09','TBM923456780'
EXEC Register_Order 3,3,3,'2023-07-09','TBM923456781'
EXEC Register_Order 4,3,3,'2023-07-11','TBM923456782'
EXEC Register_Order 4,3,3,'2023-07-12','TBM923456783'

EXEC Register_Order 5,5,5,'2023-08-05','TBM923456784'
EXEC Register_Order 5,5,5,'2023-08-06','TBM923456785'
EXEC Register_Order 6,5,5,'2023-08-07','TBM923456786'
EXEC Register_Order 6,5,5,'2023-08-08','TBM923456787'

EXEC Register_Order 6,6,6,'2023-09-09','TBM923456788'
EXEC Register_Order 6,6,6,'2023-09-09','TBM923456789'
EXEC Register_Order 7,7,7,'2023-09-11','TBM923456780'
EXEC Register_Order 7,7,7,'2023-09-12','TBM923456781'

EXEC Register_Order 7,7,7,'2023-10-09','TBM923456782'
EXEC Register_Order 7,7,7,'2023-10-09','TBM993456783'
EXEC Register_Order 7,7,7,'2023-10-11','TBM923456784'
EXEC Register_Order 7,7,7,'2023-10-12','TBM923456785'


---- Linking orders with products using the stored proecedure 

--Day 1 placing orders
EXEC Register_Order_Products 1,4
EXEC Register_Order_Products 1,4
EXEC Register_Order_Products 2,3
EXEC Register_Order_Products 2,3

EXEC Register_Order_Products 3,2
EXEC Register_Order_Products 3,2
EXEC Register_Order_Products 4,1
EXEC Register_Order_Products 4,1


EXEC Register_Order_Products 5,7
EXEC Register_Order_Products 5,7
EXEC Register_Order_Products 5,7
EXEC Register_Order_Products 6,8

EXEC Register_Order_Products 6,2
EXEC Register_Order_Products 6,1
EXEC Register_Order_Products 7,1
EXEC Register_Order_Products 7,5

EXEC Register_Order_Products 7,4
EXEC Register_Order_Products 8,4
EXEC Register_Order_Products 8,1
EXEC Register_Order_Products 8,1

EXEC Register_Order_Products 1,8
EXEC Register_Order_Products 1,8
EXEC Register_Order_Products 2,7
EXEC Register_Order_Products 2,7



--Day 2 placing orders
EXEC Register_Order_Products 9,4
EXEC Register_Order_Products 10,4
EXEC Register_Order_Products 11,3
EXEC Register_Order_Products 12,3

EXEC Register_Order_Products 13,2
EXEC Register_Order_Products 14,2
EXEC Register_Order_Products 15,1
EXEC Register_Order_Products 16,1


EXEC Register_Order_Products 17,7
EXEC Register_Order_Products 18,7
EXEC Register_Order_Products 19,7
EXEC Register_Order_Products 20,8

EXEC Register_Order_Products 21,2
EXEC Register_Order_Products 22,1
EXEC Register_Order_Products 23,1
EXEC Register_Order_Products 24,5

EXEC Register_Order_Products 25,4
EXEC Register_Order_Products 26,4
EXEC Register_Order_Products 27,1
EXEC Register_Order_Products 28,1

EXEC Register_Order_Products 29,8
EXEC Register_Order_Products 30,8
EXEC Register_Order_Products 31,7
EXEC Register_Order_Products 9,7


--Day 3 placing orders

EXEC Register_Order_Products 33,4
EXEC Register_Order_Products 34,4
EXEC Register_Order_Products 35,3
EXEC Register_Order_Products 36,3

EXEC Register_Order_Products 37,2
EXEC Register_Order_Products 38,2
EXEC Register_Order_Products 39,1
EXEC Register_Order_Products 40,1


EXEC Register_Order_Products 41,7
EXEC Register_Order_Products 42,7
EXEC Register_Order_Products 43,7
EXEC Register_Order_Products 44,8

EXEC Register_Order_Products 45,2
EXEC Register_Order_Products 46,1
EXEC Register_Order_Products 47,1
EXEC Register_Order_Products 48,5

EXEC Register_Order_Products 49,4
EXEC Register_Order_Products 50,4
EXEC Register_Order_Products 51,1
EXEC Register_Order_Products 52,1

EXEC Register_Order_Products 53,8
EXEC Register_Order_Products 54,8
EXEC Register_Order_Products 55,7
EXEC Register_Order_Products 56,7

EXEC Register_Order_Products 33,4
EXEC Register_Order_Products 33,4
EXEC Register_Order_Products 33,1
EXEC Register_Order_Products 33,1

EXEC Register_Order_Products 33,8
EXEC Register_Order_Products 33,8
EXEC Register_Order_Products 33,7
EXEC Register_Order_Products 33,7


---- Confirming values registered 
SELECT * FROM Customers
---- Confirming values registered 
SELECT * FROM Address
---- Confirming values registered 
SELECT * FROM Payment
---- Confirming values registered 
SELECT * FROM Products
---- Confirming values registered 
SELECT * FROM Orders
---- Confirming values registered 
SELECT * FROM Order_Products