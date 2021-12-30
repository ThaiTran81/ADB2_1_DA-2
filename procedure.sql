-- insert an account
--CREATE PROCEDURE InsertAccount 
--@username varchar(30), @password varchar(100),@role int, @userid int
--AS
--	INSERT INTO dbo.Account VALUES (@username, @password, @role, @userid)
--GO

-- insert an user 
--CREATE PROCEDURE InsertUser 
--@fullname nvarchar(50), @dob DATE,@address NVARCHAR(100), @telephone char(15),
--@email varchar(50), @datefounded datetime
--AS
--	INSERT INTO dbo.[User] VALUES (@fullname, @dob, @address, @telephone, @email, @datefounded, 0)
--GO

-- insert an attendance
--CREATE PROCEDURE InsertAttendance 
--@uid int, @timeStart DATETIME, @status BIT
--AS
--	INSERT INTO ATTENDANCE ([uid],timeStart,[status]) VALUES (@uid,@timeStart, @status)
--GO

--CREATE PROCEDURE UpdateAttendance 
--@uid int,@timeStart DATETIME, @timeEnd DATETIME, @status BIT
--AS
--	UPDATE ATTENDANCE SET timeEnd = @timeEnd,[status] = @status
--	WHERE CAST (timeStart AS DATE) = cast (@timeStart AS DATE) AND [uid]= @uid
--GO


--CREATE PROCEDURE SelectSpecificAttendance 
--@uid int,@timeStart DATETIME
--AS
--	SELECT * FROM dbo.Attendance WHERE CAST (timeStart AS DATE) = CAST(@timeStart AS DATE) AND [uid] = @uid
--GO	

-- select a specific user from database to check login
--CREATE PROCEDURE SelectUID
--	@fullname nvarchar(50), @dob DATE,@address NVARCHAR(100), @telephone char(15),
--	@email varchar(50), @datefounded datetime
--AS  
	
--	RETURN (SELECT TOP 1 [uid] FROM dbo.[user]
--	WHERE fullname = @fullname AND dob = @dob AND [address] = @address
--	AND telephone = @telephone AND email = @email AND datefounded = @datefounded)
--GO  


--CREATE PROCEDURE SelectAttendance
--@date DATETIME, @uid INT	
--AS  
--BEGIN	
--	(SELECT * FROM dbo.Attendance WHERE [uid] = @uid AND timeStart = @date)
--END	
--GO  

--CREATE PROCEDURE SelectAttendanceUID
--@uid INT	
--AS  
--BEGIN	
--	(SELECT * FROM dbo.Attendance WHERE [uid] = @uid)
--END	
--GO 



--select top 20 * from (
--	SELECT *, ROW_NUMBER() OVER 
--	 (order BY proID) 
--	AS r_n_n 
--    from product 
--	WHERE {OTHER OPTIONAL FILTERS}
--) xx where r_n_n >= 40
--{OFFSET HERE}

