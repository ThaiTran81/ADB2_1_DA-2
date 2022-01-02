CREATE DATABASE qlbh
GO

USE qlbh
GO

IF DB_NAME() <> N'qlbh' SET NOEXEC ON
GO

--
-- Create table [dbo].[User]
--
PRINT (N'Create table [dbo].[User]')
GO
CREATE TABLE dbo.[User] (
  uid int IDENTITY,
  fullname nvarchar(50) NULL,
  dob date NULL,
  address nvarchar(100) NULL,
  telephone char(15) NULL,
  email varchar(50) NULL,
  datefounded datetime NULL,
  score float NULL,
  PRIMARY KEY CLUSTERED (uid),
  UNIQUE (telephone)
)
ON [PRIMARY]
GO

--
-- Create table [dbo].[staff]
--
PRINT (N'Create table [dbo].[staff]')
GO
CREATE TABLE dbo.staff (
  uID int IDENTITY,
  storeID int NULL,
  CONSTRAINT PK_table1_uID PRIMARY KEY CLUSTERED (uID)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_staff_uID] on table [dbo].[staff]
--
PRINT (N'Create foreign key [FK_staff_uID] on table [dbo].[staff]')
GO
ALTER TABLE dbo.staff
  ADD CONSTRAINT FK_staff_uID FOREIGN KEY (uID) REFERENCES dbo.[User] (uid)
GO

--
-- Create table [dbo].[Salary]
--
PRINT (N'Create table [dbo].[Salary]')
GO
CREATE TABLE dbo.Salary (
  uID int NOT NULL,
  salary float NULL,
  sales int NULL DEFAULT (0),
  DateStart date NOT NULL,
  DateEnd date NULL,
  CONSTRAINT PK_Salary PRIMARY KEY CLUSTERED (uID, DateStart)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Salary_User] on table [dbo].[Salary]
--
PRINT (N'Create foreign key [FK_Salary_User] on table [dbo].[Salary]')
GO
ALTER TABLE dbo.Salary WITH NOCHECK
  ADD CONSTRAINT FK_Salary_User FOREIGN KEY (uID) REFERENCES dbo.staff (uID)
GO

--
-- Create table [dbo].[Attendance]
--
PRINT (N'Create table [dbo].[Attendance]')
GO
CREATE TABLE dbo.Attendance (
  uid int NOT NULL,
  timeStart datetime NOT NULL,
  timeEnd datetime NULL,
  status bit NULL,
  CONSTRAINT PK_Attendance PRIMARY KEY CLUSTERED (uid, timeStart)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Attendance_User] on table [dbo].[Attendance]
--
PRINT (N'Create foreign key [FK_Attendance_User] on table [dbo].[Attendance]')
GO
ALTER TABLE dbo.Attendance WITH NOCHECK
  ADD CONSTRAINT FK_Attendance_User FOREIGN KEY (uid) REFERENCES dbo.staff (uID)
GO

--
-- Create table [dbo].[Supplier]
--
PRINT (N'Create table [dbo].[Supplier]')
GO
CREATE TABLE dbo.Supplier (
  supID int IDENTITY,
  supName nvarchar(50) NULL,
  addr nvarchar(50) NULL,
  PRIMARY KEY CLUSTERED (supID)
)
ON [PRIMARY]
GO

--
-- Create table [dbo].[Store]
--
PRINT (N'Create table [dbo].[Store]')
GO
CREATE TABLE dbo.Store (
  storeID int IDENTITY,
  storeAddress varchar(100) NOT NULL,
  manager int NULL,
  CONSTRAINT PK_Store_storeID PRIMARY KEY CLUSTERED (storeID)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Store_manager] on table [dbo].[Store]
--
PRINT (N'Create foreign key [FK_Store_manager] on table [dbo].[Store]')
GO
ALTER TABLE dbo.Store
  ADD CONSTRAINT FK_Store_manager FOREIGN KEY (manager) REFERENCES dbo.staff (uID)
GO

--
-- Create foreign key [FK_table1_storeID] on table [dbo].[staff]
--
PRINT (N'Create foreign key [FK_table1_storeID] on table [dbo].[staff]')
GO
ALTER TABLE dbo.staff
  ADD CONSTRAINT FK_table1_storeID FOREIGN KEY (storeID) REFERENCES dbo.Store (storeID)
GO

--
-- Create table [dbo].[Order]
--
PRINT (N'Create table [dbo].[Order]')
GO
CREATE TABLE dbo.[Order] (
  orderID int IDENTITY,
  uID int NULL,
  discount float NULL,
  dateBill datetime NULL,
  empID int NULL,
  total float NULL,
  isPay bit NULL,
  storeID int NULL,
  address NVARCHAR(50) NULL,
  PRIMARY KEY CLUSTERED (orderID)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Order_EmpID] on table [dbo].[Order]
--
PRINT (N'Create foreign key [FK_Order_EmpID] on table [dbo].[Order]')
GO
ALTER TABLE dbo.[Order] WITH NOCHECK
  ADD CONSTRAINT FK_Order_EmpID FOREIGN KEY (empID) REFERENCES dbo.staff (uID)
GO

--
-- Create foreign key [FK_Order_storeID] on table [dbo].[Order]
--
PRINT (N'Create foreign key [FK_Order_storeID] on table [dbo].[Order]')
GO
ALTER TABLE dbo.[Order]
  ADD CONSTRAINT FK_Order_storeID FOREIGN KEY (storeID) REFERENCES dbo.Store (storeID)
GO

--
-- Create foreign key [FK_Order_User] on table [dbo].[Order]
--
PRINT (N'Create foreign key [FK_Order_User] on table [dbo].[Order]')
GO
ALTER TABLE dbo.[Order] WITH NOCHECK
  ADD CONSTRAINT FK_Order_User FOREIGN KEY (uID) REFERENCES dbo.[User] (uid)
GO

--
-- Create table [dbo].[Import]
--
PRINT (N'Create table [dbo].[Import]')
GO
CREATE TABLE dbo.Import (
  imID int IDENTITY,
  supID int NULL,
  imDate date NULL,
  total float NULL,
  storeID int NULL,
  PRIMARY KEY CLUSTERED (imID)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Import_storeID] on table [dbo].[Import]
--
PRINT (N'Create foreign key [FK_Import_storeID] on table [dbo].[Import]')
GO
ALTER TABLE dbo.Import
  ADD CONSTRAINT FK_Import_storeID FOREIGN KEY (storeID) REFERENCES dbo.Store (storeID)
GO

--
-- Create foreign key [FK_Import_Supplier] on table [dbo].[Import]
--
PRINT (N'Create foreign key [FK_Import_Supplier] on table [dbo].[Import]')
GO
ALTER TABLE dbo.Import WITH NOCHECK
  ADD CONSTRAINT FK_Import_Supplier FOREIGN KEY (supID) REFERENCES dbo.Supplier (supID)
GO

--
-- Create table [dbo].[ROLES]
--
PRINT (N'Create table [dbo].[ROLES]')
GO
CREATE TABLE dbo.ROLES (
  rID int IDENTITY,
  rName nvarchar(20) NULL,
  PRIMARY KEY CLUSTERED (rID)
)
ON [PRIMARY]
GO

--
-- Create table [dbo].[Account]
--
PRINT (N'Create table [dbo].[Account]')
GO
CREATE TABLE dbo.Account (
  username varchar(30) NOT NULL,
  password varchar(100) NULL,
  role int NULL,
  userid int NULL,
  PRIMARY KEY CLUSTERED (username)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Account_Roles] on table [dbo].[Account]
--
PRINT (N'Create foreign key [FK_Account_Roles] on table [dbo].[Account]')
GO
ALTER TABLE dbo.Account WITH NOCHECK
  ADD CONSTRAINT FK_Account_Roles FOREIGN KEY (role) REFERENCES dbo.ROLES (rID)
GO

--
-- Create foreign key [FK_Account_User] on table [dbo].[Account]
--
PRINT (N'Create foreign key [FK_Account_User] on table [dbo].[Account]')
GO
ALTER TABLE dbo.Account WITH NOCHECK
  ADD CONSTRAINT FK_Account_User FOREIGN KEY (userid) REFERENCES dbo.[User] (uid)
GO

--
-- Create table [dbo].[Category]
--
PRINT (N'Create table [dbo].[Category]')
GO
CREATE TABLE dbo.Category (
  categoryId int IDENTITY,
  categoryName nvarchar(50) NULL,
  PRIMARY KEY CLUSTERED (categoryId)
)
ON [PRIMARY]
GO

--
-- Create table [dbo].[ProductType]
--
PRINT (N'Create table [dbo].[ProductType]')
GO
CREATE TABLE dbo.ProductType (
  tId int IDENTITY,
  tName nvarchar(50) NULL,
  category int NULL,
  PRIMARY KEY CLUSTERED (tId)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_ProductType_Category] on table [dbo].[ProductType]
--
PRINT (N'Create foreign key [FK_ProductType_Category] on table [dbo].[ProductType]')
GO
ALTER TABLE dbo.ProductType WITH NOCHECK
  ADD CONSTRAINT FK_ProductType_Category FOREIGN KEY (category) REFERENCES dbo.Category (categoryId)
GO

--
-- Create table [dbo].[Product]
--
PRINT (N'Create table [dbo].[Product]')
GO
CREATE TABLE dbo.Product (
  proID int IDENTITY,
  pname nvarchar(50) NULL,
  title nvarchar(30) NULL,
  description nvarchar(100) NULL,
  ptype int NULL,
  price float NULL,
  PRIMARY KEY CLUSTERED (proID)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Product_ProductType] on table [dbo].[Product]
--
PRINT (N'Create foreign key [FK_Product_ProductType] on table [dbo].[Product]')
GO
ALTER TABLE dbo.Product WITH NOCHECK
  ADD CONSTRAINT FK_Product_ProductType FOREIGN KEY (ptype) REFERENCES dbo.ProductType (tId)
GO

--
-- Create table [dbo].[Rating]
--
PRINT (N'Create table [dbo].[Rating]')
GO
CREATE TABLE dbo.Rating (
  proID int NOT NULL,
  uID int NOT NULL,
  score float NULL,
  feedback nvarchar(100) NULL,
  timeRating datetime NULL,
  CONSTRAINT PK_Rating PRIMARY KEY CLUSTERED (proID, uID)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Rating_Product] on table [dbo].[Rating]
--
PRINT (N'Create foreign key [FK_Rating_Product] on table [dbo].[Rating]')
GO
ALTER TABLE dbo.Rating WITH NOCHECK
  ADD CONSTRAINT FK_Rating_Product FOREIGN KEY (proID) REFERENCES dbo.Product (proID)
GO

--
-- Create foreign key [FK_Rating_User] on table [dbo].[Rating]
--
PRINT (N'Create foreign key [FK_Rating_User] on table [dbo].[Rating]')
GO
ALTER TABLE dbo.Rating WITH NOCHECK
  ADD CONSTRAINT FK_Rating_User FOREIGN KEY (uID) REFERENCES dbo.[User] (uid)
GO

--
-- Create table [dbo].[PriceProduct]
--
PRINT (N'Create table [dbo].[PriceProduct]')
GO
CREATE TABLE dbo.PriceProduct (
  proID int NOT NULL,
  date datetime NOT NULL,
  Price float NULL,
  Discount float NULL,
  CONSTRAINT PK_PriceProduct PRIMARY KEY CLUSTERED (proID, date)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_PriceProduct_Product] on table [dbo].[PriceProduct]
--
PRINT (N'Create foreign key [FK_PriceProduct_Product] on table [dbo].[PriceProduct]')
GO
ALTER TABLE dbo.PriceProduct WITH NOCHECK
  ADD CONSTRAINT FK_PriceProduct_Product FOREIGN KEY (proID) REFERENCES dbo.Product (proID)
GO

--
-- Create table [dbo].[Order_detail]
--
PRINT (N'Create table [dbo].[Order_detail]')
GO
CREATE TABLE dbo.Order_detail (
  orderID int NOT NULL,
  proID int NOT NULL,
  quantity int NULL,
  price float NULL,
  discount float NULL,
  total float NULL,
  CONSTRAINT PK_Order_detail PRIMARY KEY CLUSTERED (orderID, proID)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_OrderDetail_Order] on table [dbo].[Order_detail]
--
PRINT (N'Create foreign key [FK_OrderDetail_Order] on table [dbo].[Order_detail]')
GO
ALTER TABLE dbo.Order_detail WITH NOCHECK
  ADD CONSTRAINT FK_OrderDetail_Order FOREIGN KEY (orderID) REFERENCES dbo.[Order] (orderID)
GO

--
-- Create foreign key [FK_OrderDetail_Produc] on table [dbo].[Order_detail]
--
PRINT (N'Create foreign key [FK_OrderDetail_Produc] on table [dbo].[Order_detail]')
GO
ALTER TABLE dbo.Order_detail WITH NOCHECK
  ADD CONSTRAINT FK_OrderDetail_Produc FOREIGN KEY (proID) REFERENCES dbo.Product (proID)
GO

--
-- Create table [dbo].[Import_detailed]
--
PRINT (N'Create table [dbo].[Import_detailed]')
GO
CREATE TABLE dbo.Import_detailed (
  ImID int NOT NULL,
  proID int NOT NULL,
  Quantity int NULL,
  price float NULL,
  total float NULL,
  CONSTRAINT PK_Import_detailed PRIMARY KEY CLUSTERED (ImID, proID)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_ImportDetailed_Import] on table [dbo].[Import_detailed]
--
PRINT (N'Create foreign key [FK_ImportDetailed_Import] on table [dbo].[Import_detailed]')
GO
ALTER TABLE dbo.Import_detailed WITH NOCHECK
  ADD CONSTRAINT FK_ImportDetailed_Import FOREIGN KEY (ImID) REFERENCES dbo.Import (imID)
GO

--
-- Create foreign key [FK_ImportDetailed_Product] on table [dbo].[Import_detailed]
--
PRINT (N'Create foreign key [FK_ImportDetailed_Product] on table [dbo].[Import_detailed]')
GO
ALTER TABLE dbo.Import_detailed WITH NOCHECK
  ADD CONSTRAINT FK_ImportDetailed_Product FOREIGN KEY (proID) REFERENCES dbo.Product (proID)
GO

--
-- Create table [dbo].[Available]
--
PRINT (N'Create table [dbo].[Available]')
GO
CREATE TABLE dbo.Available (
  proID int NULL,
  storeID int NULL,
  stock int NULL DEFAULT (0)
)
ON [PRIMARY]
GO

--
-- Create foreign key [FK_Available_proID] on table [dbo].[Available]
--
PRINT (N'Create foreign key [FK_Available_proID] on table [dbo].[Available]')
GO
ALTER TABLE dbo.Available
  ADD CONSTRAINT FK_Available_proID FOREIGN KEY (proID) REFERENCES dbo.Product (proID)
GO

--
-- Create foreign key [FK_Available_storeID] on table [dbo].[Available]
--
PRINT (N'Create foreign key [FK_Available_storeID] on table [dbo].[Available]')
GO
ALTER TABLE dbo.Available
  ADD CONSTRAINT FK_Available_storeID FOREIGN KEY (storeID) REFERENCES dbo.Store (storeID)
GO


--
-- Create table [dbo].[Notification]
--
CREATE TABLE qlbh.dbo.Notification (
  notiID INT IDENTITY
 ,uID INT NULL
 ,content NVARCHAR(250) NULL
 ,timeD DATETIME NULL
 ,seen BIT NOT NULL DEFAULT (0)
 ,CONSTRAINT PK_Notification_notiID PRIMARY KEY CLUSTERED (notiID)
) ON [PRIMARY]
GO

ALTER TABLE qlbh.dbo.Notification
ADD CONSTRAINT FK_Notification_uID FOREIGN KEY (uID) REFERENCES dbo.[USER] (uid)
GO


SET NOEXEC OFF
GO

