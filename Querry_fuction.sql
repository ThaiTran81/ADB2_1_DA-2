USE qlbh
  USE qlbh

-- Sort san pham theo t�n
SELECT * 
FROM Product p
WHERE p.pname = 'aaaaa'
-- Sort san pham theo gi� tang d?n
SELECT * 
FROM Product p
ORDER BY p.price ASC
-- Sort san pham theo gi� gi?m d?n
SELECT * 
FROM Product p
ORDER BY  p.price DESC

-- Sort san pham theo s?n ph?m c� lu?ng rating tang d?n
SELECT p.proID,p.ptype,p.pname,p.price, COUNT(r.proID) AS N'T?ng s? d�nh gi�'
FROM Rating r JOIN Product p ON(r.proID = p.proID)
GROUP BY p.proID,p.pname,p.price,p.ptype
ORDER BY COUNT(r.proID) ASC

-- Sort san pham theo s?n ph?m c� lu?ng rating gi?m d?n
SELECT p.proID,p.ptype,p.pname,p.price, COUNT(r.proID) AS N'T?ng s? d�nh gi�'
FROM Rating r JOIN Product p ON(r.proID = p.proID)
GROUP BY p.proID,p.pname,p.price,p.ptype
ORDER BY COUNT(r.proID) DESC
  USE qlbh

-- Sort san pham theo t�n
SELECT * 
FROM Product p
WHERE p.pname = 'aaaaa'
-- Sort san pham theo gi� tang d?n
SELECT * 
FROM Product p
ORDER BY p.price ASC
-- Sort san pham theo gi� gi?m d?n
SELECT * 
FROM Product p
ORDER BY  p.price DESC
-- Sort san pham theo s?n ph?m c� lu?ng rating tang d?n
SELECT p.proID,p.ptype,p.pname,p.price, COUNT(r.proID) AS N'T?ng s? d�nh gi�'
FROM Rating r JOIN Product p ON(r.proID = p.proID)
GROUP BY p.proID,p.pname,p.price,p.ptype
ORDER BY COUNT(r.proID) ASC
-- Sort san pham theo s?n ph?m c� lu?ng rating gi?m d?n
SELECT p.proID,p.ptype,p.pname,p.price, COUNT(r.proID) AS N'T?ng s? d�nh gi�'
FROM Rating r JOIN Product p ON(r.proID = p.proID)
GROUP BY p.proID,p.pname,p.price,p.ptype
ORDER BY COUNT(r.proID) DESC
--Doanh Thu th�ng
go
alter PROC DoanhThuThang @year CHAR(4)
AS
 SELECT MONTH(o.dateBill) AS N'Th�ng',YEAR(o.dateBill) AS N'Nam', SUM(od.total) AS N'Doanh thu' 
FROM [Order] o JOIN Order_detail od ON o.orderID = od.orderID
--WHERE YEAR(o.dateBill) LIKE @year
GROUP BY MONTH(o.dateBill), YEAR(o.dateBill)
ORDER BY MONTH(o.dateBill) DESC, yEAR(o.dateBill) DESC
EXEC DoanhThuThang @year = '2021'

--Doanh thu nam
  SELECT YEAR(o.dateBill) AS N' Nam', SUM(od.total) AS N'Doanh Thu'
FROM [Order] o JOIN Order_detail od ON o.orderID = od.orderID
GROUP BY YEAR(o.dateBill)
ORDER BY YEAR(o.dateBill) desc

