USE qlbh
-- username_pw_login
SELECT a.username,a.password
FROM Account a
WHERE a.userid = '12345678'
-- signup

create PROC SIGN_UP @username VARCHAR(30), @password VARCHAR(100), 
                    @fullname NVARCHAR(50), @dob DATE, @address NVARCHAR(100), @telephone CHAR(10), @email VARCHAR(50), @datefounded DATETIME
AS
   INSERT INTO [User](fullname, dob, address, telephone, email, datefounded) VALUES(@fullname, @dob, @address, @telephone, @email, @datefounded)
   DECLARE @userid_sign int = (SELECT SCOPE_IDENTITY())
   INSERT INTO Account (username, password, userid, role) VALUES (@username,@password,@userid_sign, 1)
GO
DROP PROC SIGN_UP
EXEC SIGN_UP @username = 'trhuutrong'
            ,@password = 'trhuutrong'
            ,@fullname = N'Tran Huu Trong'
            ,@dob = '2021-06-05'
            ,@address = N'Viet Nam'
            ,@telephone = '123456789'
            ,@email = 'trhuutrong@gmail.com'
            ,@datefounded = '2021-12-22 16:20:14.669'

