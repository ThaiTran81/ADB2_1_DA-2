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
	uid char(9) primary key,
	fullname nvarchar(50),
	dob date,
	address nvarchar(100),
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
proID char(9) primary key,
pname nvarchar(50),
title nvarchar(30),
description nvarchar(100),
stocks int,
categoryId char(5)
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'Category')  
   DROP TABLE [dbo].Category;  
GO
create table Category(
categoryId char(5) primary key,
categoryName nvarchar(50)
);


IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'PriceProduct')  
   DROP TABLE [dbo].PriceProduct;  
GO
create table PriceProduct(
proID char(9),
[date] datetime,
Price float,
Discount float,
	constraint FK_PriceProduct primary key (proID, [date])
);


IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'Salary')  
   DROP TABLE [dbo].Salary;  
GO
create table Salary(
[uID] char(9),
salary float,
sales float,
DateS date,
	constraint FK_Salary primary key ([uID], DateS)
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'Supplier')  
   DROP TABLE [dbo].Supplier;  
GO
create table Supplier(
supID char(5) primary key,
supName nvarchar(50),
addr nvarchar(50)
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'Rating')  
   DROP TABLE [dbo].Rating;  
GO
create table Rating(
proID char(9),
[uID] char(9),
score float,
feedback nvarchar(100),
timeRating datetime,
	constraint FK_Rating primary key (proID, [uID])
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'Import')  
   DROP TABLE [dbo].Import;  
GO
create table Import(
	imID char(9),
	supID char(5),
	imDate date,
	total money
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'Import_detailed')  
   DROP TABLE [dbo].Import_detailed;  
GO
create table Import_detailed(
	ImID char(9),
	proID char(9),
	Quantity int,
	price money,
	total money,
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like '[Order]')  
   DROP TABLE [dbo].[Order];  
GO
create table [Order](
	orderID char(5) primary key,
	uID char(9),
	discount float,
	dateBill date,
	empID char(9),
	total money,
	isPay bit
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like '[Order_detail]')  
   DROP TABLE [dbo].Order_detail;  
GO
create table Order_detail(
orderID char(5),
proID char(9),
quantity int,
price money,
discount float,
total money,
	constraint FK_Order_detail primary key (orderID, proID)
);

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like '[Attendance]')  
   DROP TABLE [dbo].Attendance;  
GO
create table Attendance(
[uid] char(9),
timeStart datetime,
timeEnd datetime,
[status] bit,
	constraint FK_Attendance primary key ([uid], timeStart)
);

















