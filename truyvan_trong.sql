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

-- xuat ra thong tin gia cua moi san pham, check proc ben duoi
 SELECT pp.price, pp.date
FROM PriceProduct pp 
WHERE pp.proID = 4
ORDER BY pp.date DESC
GO
-- Proc Xem thong tin san pham
CREATE PROC XemThongTinSanPham @productID INT
  as
SELECT p.proID AS N'Mã SP'
      ,p.pname AS N'Tên SP'
      ,p.stocks AS N'SL Tồn'
      ,p.ptype AS 'Type'
      ,pp.date AS 'Date'
      ,pp.Price AS N'Giá SP'
      ,pp.Discount AS N'Giảm giá'
FROM PriceProduct pp JOIN Product p ON pp.proID = p.proID
WHERE @productID = pp.proID  AND pp.date >= ALL (SELECT pp1.date FROM PriceProduct pp1 WHERE pp1.proID = pp.proID )
--DROP PROC XemThongTinSanPham
EXECUTE XemThongTinSanPham @productID = 4
