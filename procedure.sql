
CREATE PROCEDURE InsertAccount 
@username varchar(30), @password varchar(100),@role int, @userid int
AS
	INSERT INTO dbo.Account VALUES (@username, @password, @role, @userid)
GO

CREATE PROCEDURE InsertUser 
@fullname nvarchar(50), @dob DATE,@address NVARCHAR(100), @telephone char(15),
@email varchar(50), @datefounded datetime
AS
	INSERT INTO dbo.[User] VALUES (@fullname, @dob, @address, @telephone, @email, @datefounded, 0)
GO

CREATE PROCEDURE InsertAttendance 
@uid int, @timeStart DATETIME, @status BIT
AS
	INSERT INTO ATTENDANCE ([uid],timeStart,[status]) VALUES (@uid,@timeStart, @status)
GO

CREATE PROCEDURE UpdateAttendance 
@uid int,@timeStart DATETIME, @timeEnd DATETIME, @status BIT
AS
	IF ((SELECT TOP 1 ([status]) FROM dbo.Attendance WHERE CAST (timeStart AS DATE) = cast (@timeStart AS DATE) AND [uid]= @uid) = 1)
		SET @status = 1;
	UPDATE ATTENDANCE SET timeEnd = @timeEnd,[status] = @status
	WHERE CAST (timeStart AS DATE) = cast (@timeStart AS DATE) AND [uid]= @uid
GO

CREATE PROCEDURE SelectSpecificAttendance 
@uid int,@timeStart DATETIME
AS
	SELECT * FROM dbo.Attendance WHERE CAST (timeStart AS DATE) = CAST(@timeStart AS DATE) AND [uid] = @uid
GO	

 select a specific user from database to check login
CREATE PROCEDURE SelectUID
	@fullname nvarchar(50), @dob DATE,@address NVARCHAR(100), @telephone char(15),
	@email varchar(50), @datefounded datetime
AS  
	
	RETURN (SELECT TOP 1 [uid] FROM dbo.[user]
	WHERE fullname = @fullname AND dob = @dob AND [address] = @address
	AND telephone = @telephone AND email = @email AND datefounded = @datefounded)
GO  


CREATE PROCEDURE SelectAttendance
@date DATETIME, @uid INT	
AS  
BEGIN	
	(SELECT * FROM dbo.Attendance WHERE [uid] = @uid AND timeStart = @date)
END	
GO  

CREATE PROCEDURE SelectAttendanceUID
@uid INT	
AS  
BEGIN	
	(SELECT * FROM dbo.Attendance WHERE [uid] = @uid)
END	
GO 

CREATE PROCEDURE SelectStaffStoredID
@uid INT	
AS  
BEGIN	
	SELECT TOP 1 storeID FROM dbo.staff WHERE [uID] = @uid;
END	
GO

CREATE PROCEDURE SelectOrderByStoredID
@storeid INT	
AS  
BEGIN	
	SELECT orderID,uID,dateBill, isPay FROM [Order] WHERE storeID = @storeid and empID = null;
END	
GO

CREATE PROCEDURE updateOrderWithEmpID
@orderid INT, @empid INT  	
AS  
BEGIN	
	UPDATE dbo.[Order] SET empID = @empid WHERE orderID = @orderid 
END	
GO

CREATE PROCEDURE FindAllSalaryStaffID
@uid INT	
AS  
BEGIN	
	(SELECT * FROM dbo.Salary WHERE [uid] = @uid)
END	
GO  

CREATE PROCEDURE FindAllSalaryByYear
@uid INT, @year INT	
AS  
BEGIN	
	(SELECT * FROM dbo.Salary WHERE [uid] = @uid AND YEAR(DateStart) = @year)
END	
GO  

CREATE PROCEDURE SelectProductWithOffset
@limit INT, @offset INT
AS
BEGIN 
	select top (@limit) * from (
		SELECT proID, pname, title, description, ROW_NUMBER() OVER 
		 (order BY proID) 
		AS offset
		from dbo.Product 
	) AS d WHERE d.offset >= @offset
END
GO	

CREATE PROCEDURE SelectPriceProductByProID
@proID int
as
	SELECT TOP 1 date, price, discount FROM dbo.PriceProduct WHERE proID = @proID
	ORDER BY date desc
GO 

CREATE PROCEDURE SelectProductWithSpecificType
@limit int, @offset int, @tid int 
AS
BEGIN	
	select top (@limit) * from (
		SELECT p.proID, p.pname, p.title, p.description, ROW_NUMBER() OVER 
		 (order BY proID) 
		AS offset 
		from ProductType pt 
		JOIN dbo.Product p ON p.ptype = pt.tId
		WHERE pt.tId = @tid
	) xx where offset > @offset
END
GO

CREATE PROCEDURE DoanhThuThang
AS
 SELECT MONTH(o.dateBill) AS N'month',YEAR(o.dateBill) AS N'year', SUM(od.total) AS N'total' 
FROM [Order] o JOIN Order_detail od ON o.orderID = od.orderID
--WHERE YEAR(o.dateBill) LIKE @year
GROUP BY MONTH(o.dateBill), YEAR(o.dateBill)
ORDER BY MONTH(o.dateBill) DESC, yEAR(o.dateBill) DESC
GO

CREATE PROCEDURE SelectProductAvailableStoredID
@storeID INT
AS 
	SELECT Available.proID, stock, p.pname FROM dbo.Available JOIN product p ON p.proID = Available.proID AND storeID = @storeID
GO

SELECT * FROM dbo.Available JOIN product p ON p.proID = Available.proID

CREATE PROCEDURE SelectQuantityProductBySearch
@key nvarchar(50)
as
	SELECT count(*) as soluong from product where pname like ('%' + @key +'%')
GO 

CREATE PROCEDURE SelectProductWithSearchKey
@limit int, @offset int, @key nvarchar(50)
AS
BEGIN	
	select top (@limit) * from (
		SELECT p.proID, p.pname, p.title, p.description, ROW_NUMBER() OVER 
		 (order BY proID) 
		AS offset 
		from dbo.Product p
		WHERE p.pname like ('%' + @key + '%')
	) xx where offset > @offset
END
GO

CREATE PROCEDURE InsertOrder
@uid int, @date DATETIME
AS
BEGIN	
	INSERT INTO dbo.[Order]([uID], dateBill,isPay)
	VALUES(@uid,@date,0)

	SELECT orderID FROM dbo.[Order] WHERE @uid = [uID] AND @date = dateBill AND isPay = 0;
END
GO

CREATE PROCEDURE InsertOrderDetail
@orderid int, @proID INT, @quantity INT, @price FLOAT, @discount INT 
AS
BEGIN	
	INSERT INTO dbo.Order_detail
	(
	    orderID,
	    proID,
	    quantity,
	    price,
	    discount
	)
	VALUES
	(   @orderid,   -- orderID - int
	    @proID,   -- proID - int
	    @quantity,   -- quantity - int
	    @price, -- price - float
	    @discount -- discount - float-- total - float
	    )
END
GO

