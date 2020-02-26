USE Lin_Serena_TEST;


--Drop Tables
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Orders')
BEGIN
 DROP TABLE Orders
END

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Comment')
BEGIN
 DROP TABLE Comment
END

IF EXISTS (SELECT * FROM sysobjects WHERE name = 'FK_Bidding_ProductID')
BEGIN
ALTER TABLE Bidding DROP CONSTRAINT FK_Bidding_ProductID
END

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Bidding')
BEGIN
 DROP TABLE Bidding
END

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Product')
BEGIN
 DROP TABLE Product
END

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Seller')
BEGIN
 DROP TABLE Seller
END

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Buyer')
BEGIN
 DROP TABLE Buyer
END

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'User_Wishlist')
BEGIN
 DROP TABLE User_Wishlist
END

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'UserAccount')
BEGIN
 DROP TABLE UserAccount
END

IF EXISTS (SELECT * FROM sysobjects WHERE name = 'FK_Brand_BrandID')
BEGIN
ALTER TABLE Product_Type DROP CONSTRAINT FK_Brand_BrandID
END

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Brand')
BEGIN
 DROP TABLE Brand
END


IF EXISTS (SELECT * FROM sysobjects WHERE name = 'FK_Product_Category_ProductCategoryID')
BEGIN
ALTER TABLE Product_Type DROP CONSTRAINT FK_Product_Category_ProductCategoryID
END

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Product_Category')
BEGIN
 DROP TABLE Product_Category
END

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Product_Type')
BEGIN
 DROP TABLE Product_Type
END

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Product')
BEGIN
 DROP TABLE Product
END

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Address')
BEGIN
 DROP TABLE Address
END


--Create Tables
CREATE TABLE Address(
AddressID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Apt varchar(20),
Street varchar(20),
City varchar(20),
State varchar(20),
Country varchar(20),
Zipcode varchar(20)
)

CREATE TABLE UserAccount(
UserID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
AddressID INT NOT NULL,
FirstName varchar(20) NOT NULL,
LastName varchar(20) NOT NULL,
Phone varchar(20),
Birthdate DATE,
Email varchar(20),
Gender varchar(20) NOT NULL CONSTRAINT DF_UserAccount_Gender DEFAULT 'N',
CreatedDate DATE NOT NULL,
CONSTRAINT FK_User_AddressID FOREIGN KEY (AddressID) REFERENCES Address(AddressID),
)

CREATE TABLE Brand(
BrandID int IDENTITY(1,1) NOT NULL,
BrandName nvarchar(255),
CONSTRAINT PK_BrandID PRIMARY KEY (BrandID),
)



CREATE TABLE Seller(
SellerID int IDENTITY(1,1) NOT NULL PRIMARY KEY, 
UserID int,
CONSTRAINT fk_Seller_UserID FOREIGN KEY (UserID)
REFERENCES UserAccount(UserID)
)

CREATE TABLE Buyer(
BuyerID int IDENTITY(1,1) NOT NULL PRIMARY KEY, 
UserID int,
CONSTRAINT fk_Buyer_UserID FOREIGN KEY (UserID)
REFERENCES UserAccount(UserID)
)

CREATE TABLE Product_Category(
ProductCategoryID int IDENTITY(1,1) NOT NULL,
ProductCategoryName nvarchar(255),
Gender varchar(40),
CONSTRAINT PK_ProductCategoryID PRIMARY KEY (ProductCategoryID),
CONSTRAINT CHK_Product_Category_Gender CHECK (Gender IN ('F','M','N'))
)

CREATE TABLE Product_Type(
ProductTypeID int IDENTITY(1,1) NOT NULL,
BrandID int NOT NULL,
ProductCategoryID int NOT NULL,
ProductTypeName nvarchar(255),
Size varchar(40),
Color varchar(40),
CONSTRAINT PK_ProductTypeID PRIMARY KEY (ProductTypeID),
CONSTRAINT FK_Brand_BrandID FOREIGN KEY (BrandID) REFERENCES Brand(BrandID),
CONSTRAINT FK_Product_Category_ProductCategoryID FOREIGN KEY (ProductCategoryID) REFERENCES Product_Category(ProductCategoryID)
)

CREATE TABLE Product(
ProductID int IDENTITY(1,1) NOT NULL 
CONSTRAINT PK_Product_ProductID PRIMARY KEY,
ProductTypeID int NOT NULL 
CONSTRAINT FK_Productype_ProductTypeID FOREIGN KEY REFERENCES Product_Type(ProductTypeID),
SellerID int NOT NULL 
	CONSTRAINT FK_Seller_SellerID FOREIGN KEY REFERENCES Seller(SellerID),
OriginalPrice money NOT NULL,
ProductName varchar(100) NOT NULL,
ProductDesc varchar(500) NOT NULL,
DueDate datetime NOT NULL
	CONSTRAINT DF_Product_DueDate DEFAULT(DateAdd(day, 14, CURRENT_TIMESTAMP)),
CreatedDate datetime NOT NULL  
	CONSTRAINT DF_Product_CreatedDate DEFAULT(CURRENT_TIMESTAMP),
Status varchar(100) NOT NULL)


CREATE TABLE Comment(
CommentID int IDENTITY(1,1) NOT NULL,
UserID int NOT NULL,
ProductID int NOT NULL,
CommentContent nvarchar(255),
Ranking decimal(2,1),
CONSTRAINT PK_CommentID PRIMARY KEY (CommentID),
CONSTRAINT FK_UserAccount_UserID FOREIGN KEY (UserID) REFERENCES UserAccount(UserID),
CONSTRAINT FK_Product_ProductID FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
CONSTRAINT CHK_Comment_Ranking_Range CHECK (Ranking BETWEEN 0 AND 5)
)


CREATE TABLE Bidding(
BiddingID int IDENTITY(1,1) NOT NULL
	CONSTRAINT PK_Bidding_BiddingID PRIMARY KEY,
BuyerID int NOT NULL
	CONSTRAINT FK_Buyer_BuyerID FOREIGN KEY REFERENCES Buyer(BuyerID),
ProductID int NOT NULL
	CONSTRAINT FK_Bidding_ProductID FOREIGN KEY REFERENCES Product(ProductID),
BiddingPrice money NOT NULL,
BiddingDate datetime NOT NULL 
	CONSTRAINT DF_Bidding_BiddingDate DEFAULT(CURRENT_TIMESTAMP),
Status varchar(100) NOT NULL)


CREATE TABLE User_Wishlist(
WishListID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserID INT NOT NULL,
ProductTypeID INT NOT NULL,
CreatedDate DATE NOT NULL CONSTRAINT DF_User_Wishlist_CreatedDate DEFAULT(CURRENT_TIMESTAMP),
CONSTRAINT FK_Wishlist_UserID FOREIGN KEY (UserID) REFERENCES UserAccount(UserID),
CONSTRAINT FK_Wishlist_ProductTypeID FOREIGN KEY (ProductTypeID) REFERENCES Product_Type(ProductTypeID)
)

CREATE TABLE Orders(
OrderID int IDENTITY(1,1) NOT NULL PRIMARY KEY, 
SellerID int NOT NULL,
ProductID int NOT NULL,
BiddingID int NOT NULL,
BuyerID int NOT NULL,
AddressID int NOT NULL,
OrderDate date,
BiddingPrice money DEFAULT 10,
ServiceFee money,
FinalPrice AS BiddingPrice + ServiceFee,
CONSTRAINT fk_Order_SellerID FOREIGN KEY (SellerID)
REFERENCES Seller(SellerID),
CONSTRAINT fk_Order_ProductID FOREIGN KEY (ProductID)
REFERENCES Product(ProductID),
CONSTRAINT fk_Order_BiddingID FOREIGN KEY (BiddingID)
REFERENCES Bidding(BiddingID),
CONSTRAINT fk_Order_AddressID FOREIGN KEY (AddressID)
REFERENCES Address(AddressID)
)



--Insert data into Address
DBCC CHECKIDENT ('dbo.Address', RESEED, 1)
INSERT Address VALUES ('Apt402', '41th Ave', 'Seattle', 'WA', 'US', '98105')
INSERT Address VALUES ('AptB', '4217 9th Ave NE', 'Seattle', 'WA', 'US', '98105')
INSERT Address VALUES ('Apt202', '4710 18th Ave N', 'Seattle', 'WA', 'US', '98105')
INSERT Address VALUES ('4326', '9 Ave NE', 'NYC', 'NY', 'US', '')
INSERT Address VALUES ('Apt 201', '5019 17th Ave NE', 'Seattle', 'WA', 'US', '98216')
INSERT Address VALUES ('Apt A', '41th Ave', 'NYC', 'NY', 'US', '')
INSERT Address VALUES ('', '', 'Seattle', 'WA', 'US', '98216')
INSERT Address VALUES ('', '4217 9th Ave NE', 'Kirkland', 'WA', 'US', '98102')
INSERT Address VALUES ('', '9 Ave NE', 'Bellevue', 'WA', 'US', '')
INSERT Address VALUES ('Apt603', '1283 7th Ave S', 'Seattle', 'WA', 'US', '98203')

--Insert data into User
DBCC CHECKIDENT ('dbo.UserAccount', RESEED, 1)
INSERT UserAccount VALUES ('1', 'Regina', 'Yin', '2017304923', '1996-12-03', 'wenyyin@uw.edu','F', '2012-01-20')
INSERT UserAccount VALUES ('2', 'Serena', 'Lin', '2062931834', '1995-11-12', 'serena@gmail.com','F', '2014-12-23')
INSERT UserAccount VALUES ('3', 'Karvie', 'Xia', '2023948104', '1996-06-13', 'Karvie@gmail.com','F', '2015-06-06')
INSERT UserAccount VALUES ('4', 'Qiupan', 'Jin', '2063840273', '1996-07-24', 'qpj@gmail.com','F', '2012-05-15')
INSERT UserAccount VALUES ('5', 'Rachel', 'Yin', '2982046183', '1993-06-05', 'rachely@uw.edu','F', '2015-05-04')
INSERT UserAccount VALUES ('6', 'Jason', 'Anabii', '2234829648', '1989-02-17', 'jasona17@gmail.com','M', '2018-08-12')
INSERT UserAccount VALUES ('7', 'Sean', 'Sean', '2346247368', '1978-10-28', 'sean0312@yahoo.com','M', '2012-02-23')
INSERT UserAccount VALUES ('8', 'Mike', '', '', '2002-05-02', 'mike@icloud.com','', '2013-02-20')
INSERT UserAccount VALUES ('9', 'Molly', 'Ross', '2375246373', '1998-10-31', 'mollyross@gmail.com','F', '2019-07-26')
INSERT UserAccount VALUES ('10', 'Joel', 'White', '', '2000-03-09', 'joelwhite@icloud.com','M', '2019-11-20')

--Insert data into Brand
DBCC CHECKIDENT ('dbo.Brand', RESEED, 1)
INSERT INTO Brand(
BrandName)
VALUES('Adidas'),
('Nike'),
('Reebok'),
('Puma'),
('Converse'),
('ALDO'),
('UGG'),
('ecco'),
('LACOSTE'),
('Clarks'),
('Hunter'),
('Dr.Martens'),
('AllSaints'),
('Bershka')


--Insert data into Product_Category
DBCC CHECKIDENT ('dbo.Product_Category', RESEED, 1)
INSERT INTO Product_Category(
ProductCategoryName,
Gender)
VALUES('Boots','F'),
('Boots','M'),
('Flat Sandals','M'),
('Flat Sandals','F'),
('Flat Shoes','M'),
('Flat Shoes','F'),
('Heels','M'),
('Heels','F'),
('Sandals','F'),
('Sandals','M'),
('Flip Flops','F'),
('Flip Flops','M'),
('Sneakers','F'),
('Sneakers','M')


--Insert data for Seller
DBCC CHECKIDENT ('dbo.Seller', RESEED, 1)
INSERT Seller Values('1'),('2'),('3'),('4'),('5'),('6'),('7'),('8'),('9'),('10')

--Insert data into Buyer
DBCC CHECKIDENT ('dbo.Buyer', RESEED, 1)
INSERT Buyer values('1'),('2'),('3'),('4'),('5'),('6'),('7'),('8'),('9'),('10')


--Insert data into Product_Type
DBCC CHECKIDENT ('dbo.Product_Type', RESEED, 1)
INSERT INTO Product_Type VALUES
(2, 14, 'Nike React Element 55', 12, 'Indigo Fog Mystic Navy'),
(12, 1, '2976 Smooth Chelsea Boots', 7, 'Black'),
(2, 14, 'Air Force 1 Gore-tex High', 11.5, 'Phantom White'),
(1, 13, 'Adidas Yeezy 500', 6.5, 'Bone White'),
(5, 13, 'Converse Chuck Taylor All-Star', 7, '70s Hi Off-White'),
(2, 14, 'Air Max 90', 11, 'Mars Landing'),
(1, 13, 'Adidas Yeezy 500', 8.5, 'Super Moon Yellow'),
(12, 2, 'Made In England 1490 Ripple Sole', 13, 'Cherry Red'),
(6, 8, 'AlDO Stessy', 7, 'Black-Gold Multi'),
(2, 14, 'Nike Blazer Mid Sacai', 11.5, 'White Grey')

--Insert data into User_Wishlist
DBCC CHECKIDENT ('dbo.User_Wishlist', RESEED, 1)
INSERT INTO User_Wishlist(
UserID,
ProductTypeID)
VALUES(1,4),
(2,7),
(3,1),
(4,9),
(5,2),
(9,6),
(10,3),
(1,5),
(1,8),
(1,9),
(2,9),
(3,3),
(3,7),
(6,2)

-- Insert data into Product
DBCC CHECKIDENT ('dbo.Product', RESEED, 1)
INSERT INTO Product VALUES
(4, 3, 150, 'Yeezy 500 in good condition', 'I bought this last month and only used several times when hanging out.', '2019-12-30', '2019-11-02', 'Used and good condition'),
(3, 5, 285, 'Brand new air force 1', 'Good packaging, delivery fee included.',  '2019-12-28', '2019-11-29', 'Brand new'),
(10, 4, 200, '[Urgent] New Nike Blazer sneaker 10% off', 'Need to sell it immediately. Completely new sneaker, 10% off.', '2019-12-15', '2019-12-01', 'Brand new'),
(1, 5, 415, 'Super discount!! Nike React sneaker', 'Used but keep it in good condition! Super discount!', '2020-01-01', '2019-10-20', 'Used with light scratches'),
(1, 6, 215, 'Used Nike React sneaker 50% off', 'Bought a new sneaker and want to sell this old one. A very good price for those who want to have limited this version.', '2019-12-15', '2019-10-15',  'Used with light scratches'), 
(5, 2, 225, 'Converse chuck taylor wore only once', 'Trending design and limited version owned by your favorite idles', '2019-12-15', '2019-12-01', 'Brand new'),
(9, 3, 405, 'New ALDO Stessy bought last Christmas Eve', 'Bought it last year but have never worn it', '2019-12-15', '2019-11-15', 'Brand new'),
(6, 1, 285, 'Never miss this Air Max 90', 'Limited version, same one with James Lebron', '2019-12-30', '2019-10-10', 'Brand new'),
(10, 5, 99, '[Sale] Nike Blazer sneaker with original box and tags', 'Good packaging with tags. Urgent sales and good price.', '2019-12-10', '2019-11-28', 'Brand new'),
(2, 7, 185, 'INSTAGRAM trending Chelsea boots Dr.Martens', 'Good shape, good price!', '2020-01-15', '2019-11-15', 'Used with good condition')


-- Insert data into Bidding
DBCC CHECKIDENT ('dbo.Bidding', RESEED, 1)
INSERT Bidding VALUES
('1','1',230, '2019-10-12','Closed'),
('1','3',200, '2019-09-12','Closed'),
('1','1',250, '2019-10-15','Completed'),
('1','5',240, '2019-11-13','Closed'),
('1','9',275, '2019-11-25','Completed'),
('2','1',240, '2019-10-13','Closed'),
('3','3',220, '2019-09-15','Completed'),
('4','4',200, '2019-10-28','Completed'),
('5','7',170, '2019-08-22','Closed'),
('6','2',300, '2019-10-06','Completed'),
('6','5',250, '2019-08-25','Completed'),
('6','7',200, '2019-10-15','Closed'),
('7','6',250, '2019-09-30','Completed'),
('7','10',110, '2019-11-28','Completed'),
('9','7',220, '2019-09-01','Completed')


-- Insert data into Comment
DBCC CHECKIDENT ('dbo.Comment', RESEED, 1)
INSERT INTO Comment(
UserID,
ProductID,
CommentContent,
Ranking)
VALUES(1,2,'Nice! I like it a lot!',4.5),
(2,5,'Mission accomplished. excellent',5),
(9,4,'I hate the product',1.5),
(8,3,'Awesome and comfortable',4.2),
(5,10,'Not comfortable at all',2.5),
(9,6,'This is amazing. Love the texture',4.8),
(7,1,'',4),
(3,8,'meh',2.8),
(6,8,'\?\?',2),
(5,5,'Love love love',4.9),
(4,3,'Hard to tell the actual color',4)

-- Insert data into Orders
DBCC CHECKIDENT ('dbo.Orders', RESEED, 1)
INSERT INTO Orders(
SellerID, ProductID, BiddingID, BuyerID, AddressID, OrderDate, BiddingPrice, ServiceFee)
SELECT p.SellerID, b.ProductID, b.BiddingID, b.BuyerID, u.AddressID, b.BiddingDate, b.BiddingPrice, '5' FROM Bidding b
JOIN Product p ON p.ProductID = b.ProductID
JOIN Buyer buy ON buy.BuyerID = b.BuyerID
JOIN UserAccount u ON u.UserID = buy.UserID
WHERE b.Status = 'Closed';


-- Drop Views
IF OBJECT_ID('Customer_Information', 'V') IS NOT NULL
    DROP VIEW Customer_Information;

IF OBJECT_ID('Bidding_Brand', 'V') IS NOT NULL
    DROP VIEW Bidding_Brand;

IF OBJECT_ID('Brand_Wishlist', 'V') IS NOT NULL
    DROP VIEW Brand_Wishlist;

-- Create Views
CREATE VIEW Customer_Information AS
SELECT UserAccount.Gender, (year(CURRENT_TIMESTAMP)- year(USERACCOUNT.Birthdate)) as age, Address.City, Address.State
FROM UserAccount
LEFT JOIN Address
ON Address.AddressID = UserAccount.AddressID;

CREATE VIEW Bidding_Brand AS
SELECT Brand.BrandName, COUNT(Bidding.BiddingID) AS Biddingtimes 
FROM Brand
LEFT JOIN Product_Type
ON Brand.BrandID = Product_Type.BrandID
LEFT JOIN Product 
ON Product_Type.ProductTypeID = Product.ProductTypeID
LEFT JOIN BIDDING
ON Bidding.ProductID = Product.ProductID
GROUP BY Brand.BrandName;

CREATE VIEW Brand_Wishlist AS
SELECT Brand.BrandName, COUNT(user_wishlist.WishListID) AS Brand_Wishlist FROM User_Wishlist
LEFT JOIN Product_Type
ON User_Wishlist.ProductTypeID = Product_Type.ProductTypeID
LEFT JOIN brand
ON Brand.BrandID = Product_Type.BrandID
GROUP BY Brand.BrandName;






