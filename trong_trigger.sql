-- trigger luu gia cap nhat
USE qlbh
GO
    DROP TRIGGER insertprice
  go
CREATE TRIGGER dbo.insertprice
ON dbo.Product
AFTER INSERT, update
AS
BEGIN
  INSERT INTO PriceProduct(proID, date, Price)
  SELECT i.proID,GETDATE(), i. price
  FROM INSERTED AS i
END
GO
--test 
INSERT INTO Product(price) VALUES(100)

SELECT *
FROM Product p
WHERE p.proID = (SELECT SCOPE_IDENTITY())

 SELECT *
 FROM PriceProduct pp

UPDATE Product
SET price = 200
WHERE proID = 12


