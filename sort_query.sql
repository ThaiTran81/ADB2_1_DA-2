USE qlbh

-- Sort san pham theo tên
SELECT * 
FROM Product p
WHERE p.pname = 'aaaaa'
-- Sort san pham theo giá tăng dần
SELECT * 
FROM Product p
ORDER BY p.price ASC
-- Sort san pham theo giá giảm dần
SELECT * 
FROM Product p
ORDER BY  p.price DESC

-- Sort san pham theo sản phẩm có lượng rating tăng dần
SELECT p.proID,p.ptype,p.pname,p.price, COUNT(r.proID) AS N'Tổng số đánh giá'
FROM Rating r JOIN Product p ON(r.proID = p.proID)
GROUP BY p.proID,p.pname,p.price,p.ptype
ORDER BY COUNT(r.proID) ASC

-- Sort san pham theo sản phẩm có lượng rating giảm dần
SELECT p.proID,p.ptype,p.pname,p.price, COUNT(r.proID) AS N'Tổng số đánh giá'
FROM Rating r JOIN Product p ON(r.proID = p.proID)
GROUP BY p.proID,p.pname,p.price,p.ptype
ORDER BY COUNT(r.proID) DESC
