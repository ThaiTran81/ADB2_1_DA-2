use master
go

DROP DATABASE IF EXISTS qlbh;
create database qlbh;
go

use qlbh
go

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like '[User]')  
   DROP TABLE [dbo].[User];  
GO
create table [User] (
	[uid] char(9) primary key,
	fullname nvarchar(50),
	dob date,
	[address] nvarchar(100),
	telephone char(10),
	email nvarchar(50),
	score float
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'Account')  
   DROP TABLE [dbo].Account;  
GO
create table Account(
	username nvarchar(50) primary key,
	[password] nvarchar(100),
	[role] int,
	datefounded datetime,
	userid char(9)
);


IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'Product')  
   DROP TABLE [dbo].Product;  
GO
create table Product(
proID varchar(9) primary key,
pname nvarchar(50),
title nvarchar(30),
[description] nvarchar(100),
stocks int,
ptype char(5)
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'Category')  
   DROP TABLE [dbo].Category;  
GO
create table Category(
categoryId varchar(9) primary key,
categoryName nvarchar(50)
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'ProductType')  
   DROP TABLE [dbo].ProductType;  
GO
create table ProductType(
	tId char(5) primary key,
	tName nvarchar(50),
	category char(5)
);


IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'PriceProduct')  
   DROP TABLE [dbo].PriceProduct;  
GO
create table PriceProduct(
proID varchar(9),
[date] datetime,
Price float,
Discount float,
	constraint PK_PriceProduct primary key (proID, [date])
);


IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'Salary')  
   DROP TABLE [dbo].Salary;  
GO
create table Salary(
[uID] varchar(9),
salary float,
sales float,
DateS date,
	constraint PK_Salary primary key ([uID], DateS)
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'Supplier')  
   DROP TABLE [dbo].Supplier;  
GO
create table Supplier(
supID varchar(9) primary key,
supName nvarchar(50),
addr nvarchar(50)
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'Rating')  
   DROP TABLE [dbo].Rating;  
GO
create table Rating(
proID varchar(9),
[uID] varchar(9),
score float,
feedback nvarchar(100),
timeRating datetime,
	constraint PK_Rating primary key (proID, [uID])
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'Import')  
   DROP TABLE [dbo].Import;  
GO
create table Import(
	imID char(9) primary key,
	supID char(5),
	imDate date,
	total money
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'Import_detailed')  
   DROP TABLE [dbo].Import_detailed;  
GO
create table Import_detailed(
	ImID varchar(9),
	proID varchar(9),
	Quantity int,
	price money,
	total money,
	constraint PK_Import_detailed primary key (ImID, proID)
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like '[Order]')  
   DROP TABLE [dbo].[Order];  
GO
create table [Order](
	orderID char(5) primary key,
	[uID] char(9),
	discount float,
	dateBill date,
	empID varchar(9),
	total money,
	isPay bit
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like '[Order_detail]')  
   DROP TABLE [dbo].Order_detail;  
GO
create table Order_detail(
orderID varchar(9),
proID varchar(9),
quantity int,
price money,
discount float,
total money,
	constraint PK_Order_detail primary key (orderID, proID)
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like '[Attendance]')  
   DROP TABLE [dbo].Attendance;  
GO
create table Attendance(
[uid] varchar(9),
timeStart datetime,
timeEnd datetime,
[status] bit,
	constraint PK_Attendance primary key ([uid], timeStart)
);




-- create foreign key
IF (OBJECT_ID('dbo.FK_Account_User', 'F') IS NOT NULL) ALTER TABLE dbo.Account DROP CONSTRAINT FK_Account_User
ALTER TABLE Account ADD CONSTRAINT FK_Account_User FOREIGN KEY (userid) REFERENCES [User]([uid]);

IF (OBJECT_ID('dbo.FK_Product_ProductType', 'F') IS NOT NULL) ALTER TABLE dbo.Product DROP CONSTRAINT FK_Product_ProductType
ALTER TABLE Product ADD CONSTRAINT FK_Product_ProductType FOREIGN KEY (ptype) REFERENCES ProductType(tid);

IF (OBJECT_ID('dbo.FK_ProductType_Category', 'F') IS NOT NULL) ALTER TABLE dbo.ProductType DROP CONSTRAINT FK_ProductType_Category
ALTER TABLE ProductType ADD CONSTRAINT FK_ProductType_Category FOREIGN KEY (category) REFERENCES Category(categoryId);

IF (OBJECT_ID('dbo.FK_PriceProduct_Product', 'F') IS NOT NULL) ALTER TABLE dbo.PriceProduct DROP CONSTRAINT FK_PriceProduct_Product
ALTER TABLE PriceProduct ADD CONSTRAINT FK_PriceProduct_Product FOREIGN KEY (proID) REFERENCES Product(proID);

IF (OBJECT_ID('dbo.FK_PriceProduct_Product', 'F') IS NOT NULL) ALTER TABLE dbo.PriceProduct DROP CONSTRAINT FK_PriceProduct_Product
ALTER TABLE PriceProduct ADD CONSTRAINT FK_PriceProduct_Product FOREIGN KEY (proID) REFERENCES Product(proID);

IF (OBJECT_ID('dbo.FK_Rating_Product', 'F') IS NOT NULL) ALTER TABLE dbo.Rating DROP CONSTRAINT FK_Rating_Product
ALTER TABLE Rating ADD CONSTRAINT FK_Rating_Product FOREIGN KEY (proID) REFERENCES Product(proID);

IF (OBJECT_ID('dbo.FK_Rating_User', 'F') IS NOT NULL) ALTER TABLE dbo.Rating DROP CONSTRAINT FK_Rating_User
ALTER TABLE Rating ADD CONSTRAINT FK_Rating_User FOREIGN KEY ([uID]) REFERENCES [User]([uid]);

IF (OBJECT_ID('dbo.FK_Import_Supplier', 'F') IS NOT NULL) ALTER TABLE dbo.Import DROP CONSTRAINT FK_Import_Supplier
ALTER TABLE Import ADD CONSTRAINT FK_Import_Supplier FOREIGN KEY (supID) REFERENCES Supplier(supID);

IF (OBJECT_ID('dbo.FK_ImportDetailed_Import', 'F') IS NOT NULL) ALTER TABLE dbo.Import_detailed DROP CONSTRAINT FK_ImportDetailed_Import
ALTER TABLE Import_detailed ADD CONSTRAINT FK_ImportDetailed_Import FOREIGN KEY (ImID) REFERENCES Import(imID);

IF (OBJECT_ID('dbo.FK_ImportDetailed_Product', 'F') IS NOT NULL) ALTER TABLE dbo.Import_detailed DROP CONSTRAINT FK_ImportDetailed_Product
ALTER TABLE Import_detailed ADD CONSTRAINT FK_ImportDetailed_Product FOREIGN KEY (proID) REFERENCES Product(proID);

IF (OBJECT_ID('dbo.FK_Order_User', 'F') IS NOT NULL) ALTER TABLE dbo.[Order] DROP CONSTRAINT FK_Order_User
ALTER TABLE [Order] ADD CONSTRAINT FK_Order_User FOREIGN KEY ([uID]) REFERENCES [User]([uid]);

IF (OBJECT_ID('dbo.FK_Order_EmpID', 'F') IS NOT NULL) ALTER TABLE dbo.[Order] DROP CONSTRAINT FK_Order_EmpID
ALTER TABLE [Order] ADD CONSTRAINT FK_Order_EmpID FOREIGN KEY ([uID]) REFERENCES [User]([uid]);

IF (OBJECT_ID('dbo.FK_OrderDetail_Order', 'F') IS NOT NULL) ALTER TABLE dbo.Order_detail DROP CONSTRAINT FK_OrderDetail_Order
ALTER TABLE Order_detail ADD CONSTRAINT FK_OrderDetail_Order FOREIGN KEY ([orderID]) REFERENCES [Order]([orderID]);

IF (OBJECT_ID('dbo.FK_OrderDetail_Produc', 'F') IS NOT NULL) ALTER TABLE dbo.Order_detail DROP CONSTRAINT FK_OrderDetail_Produc
ALTER TABLE Order_detail ADD CONSTRAINT FK_OrderDetail_Produc FOREIGN KEY ([proID]) REFERENCES Product([proID]);

IF (OBJECT_ID('dbo.FK_Attendance_User', 'F') IS NOT NULL) ALTER TABLE dbo.Attendance DROP CONSTRAINT FK_Attendance_User
ALTER TABLE Attendance ADD CONSTRAINT FK_Attendance_User FOREIGN KEY ([uid]) REFERENCES [User]([uid]);

IF (OBJECT_ID('dbo.FK_Salary_User', 'F') IS NOT NULL) ALTER TABLE dbo.Salary DROP CONSTRAINT FK_Salary_User
ALTER TABLE Salary ADD CONSTRAINT FK_Salary_User FOREIGN KEY ([uID]) REFERENCES [User]([uid]);









