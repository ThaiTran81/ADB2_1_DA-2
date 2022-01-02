use qlbh
go


-----Kha
--trigger order detail cập nhật stock bên bảng available
--trigger import detail cập nhật stock bên bảng available

create or alter trigger Product_Stock_Insert on Order_Detail
for insert
as
begin
	update a
	set a.stocks -= (select i.quantity from inserted i join Available a on i.proID = a.proID JOIN [Order] o ON i.orderID = o.orderID AND a.storeID = o.storeID)
	where proID = (select proID from inserted)
end
go

create or alter trigger Product_Stock_Delete on Order_Detail
for delete
as
begin
	update a
	set a.stocks += (select de.quantity from DELETED de join Available a on de.proID = a.proID JOIN [Order] o ON de.orderID = o.orderID AND a.storeID = o.storeID)
	where proID = (select proID from DELETED)
end
go

create or alter trigger Product_Stock_Update on Order_Detail
for update
as
begin
	update a
	set a.stocks += (select de.quantity from DELETED de join Available a on de.proID = a.proID JOIN [Order] o ON de.orderID = o.orderID AND a.storeID = o.storeID) - (select i.quantity from inserted i join Available a on i.proID = a.proID JOIN [Order] o ON i.orderID = o.orderID AND a.storeID = o.storeID)
	where proID = (select proID from inserted)
end
go

----- 

create or alter trigger ImportDetailed_Product_Stock_Insert on Import_detailed
for insert
as
begin
	UPDATE a 
	set a.stocks += (select i.Quantity from inserted i join Available a  on i.proID = a.proID JOIN Import i1 ON a.storeID = i1.storeID)
	where proID = (select proID from inserted)
end
go

create or alter trigger ImportDetail_Product_Stock_Delete on Import_detailed
for delete
as
begin
	update a
	set a.stocks -= (select i.Quantity from DELETED i join Available a  on i.proID = a.proID JOIN Import i1 ON a.storeID = i1.storeID)
	where proID = (select proID from deleted)
end
go

create or alter trigger ImportDetailed_Product_Stock_Update on Import_detailed
for update
as
begin
	select * from inserted
	select * from deleted
	update a
	set a.stocks -= (select i.Quantity from DELETED i join Available a  on i.proID = a.proID JOIN Import i1 ON a.storeID = i1.storeID) + (select i.Quantity from inserted i join Available a  on i.proID = a.proID JOIN Import i1 ON a.storeID = i1.storeID)
	where proID = (select proID from inserted)
end
go


--trigger sales
CREATE TRIGGER trg_update_sales
ON [Order]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
  DECLARE @time DATETIME;
  DECLARE @empid INT;
	SELECT @empid = empID, @time = dateBill FROM INSERTED
  UPDATE Salary 
  SET sales = sales + 1
  WHERE uID = @empid AND TRY_CONVERT(DATE,@time) >= dateStart AND TRY_CONVERT(DATE,@time) <=dateEnd

  SELECT @empid = empID, @time = dateBill FROM DELETED
  UPDATE Salary 
  SET  sales = sales - 1
  WHERE uID = @empid AND TRY_CONVERT(DATE,@time) >= dateStart AND TRY_CONVERT(DATE,@time) <=dateEnd
END

DROP TRIGGER trg_Salary

CREATE TRIGGER trg_Salary
ON Salary
FOR INSERT, UPDATE
AS
BEGIN
	UPDATE s
  SET sales = (SELECT COUNT(*) FROM [Order] o WHERE o.empID=i.uID AND TRY_CONVERT(DATE,o.dateBill) >= i.dateStart AND TRY_CONVERT(DATE,o.dateBill) <= i.dateEnd)
  FROM Salary s INNER JOIN INSERTED i ON s.uID = i.uID
END


Create trigger trg_import_Total --trigger tính tổng tiền của bảng import_detailed = quantity*price
on Import_detailed
for Insert, update
as
begin
	update Import_detailed
	set Import_detailed.total = Import_detailed.Quantity*Import_detailed.price
	from Import_detailed join inserted i on i.ImID = Import_detailed.ImID and i.proID = Import_detailed.proID	

  UPDATE Import
  SET Import.total = (SELECT SUM(id.total) FROM Import_detailed id WHERE id.ImID = Import.imID)
end

go

--DROP TRIGGER trg_Odetail_Total
Create trigger trg_Odetail_Total --trigger tính tổng tiền của bảng Order_detail = quantity*price
on Order_detail 
for INSERT, update
as
BEGIN
   DECLARE @total FLOAT
	 update Order_detail
	 set Order_detail.total = Order_detail.quantity*(Order_detail.price - i.discount)
	 from Order_detail join inserted i on i.orderID = Order_detail.orderID and i.proID = Order_detail.proID
    
  
   update [Order]
   SET [Order].total = (SELECT SUM(Order_detail.total)
              FROM Order_detail
              WHERE Order_detail.orderID = i.orderID) - [Order].discount
   FROM Inserted i
   JOIN [Order]
    ON [Order].orderID = i.orderID
end

go

--DROP TRIGGER trg_Order_Total
Create trigger trg_Order_Total	-- trigger tính tổng tiền của bảng Order = sum(total) của bảng order_detail
on Order_detail
FOR delete
AS
BEGIN
  update [Order]
  SET [Order].total = [Order].total - (SELECT SUM(d.total)
              FROM DELETED d
              WHERE [Order].orderID = d.orderID)
END
go

Create trigger trig_check_priceProduct
on PriceProduct
for insert, update
as
begin
	declare @discount float,
	@price float
	select @discount = discount from inserted
	if(@discount > ANY(select price from PriceProduct))
		begin 
		ROLLBACK TRAN
		PRINT 'Lỗi! giá giảm phải bé hơn giá của sản phẩm'
		end
end
go
--trigger total bảng import detail: tổng tiền 
--triger total bảng order
--trigger total bảng order detail
--trigger discount bảng priceProduct > phải bé hơn price

--Stored function
-- CREATE PROCEDURE update_TotalOrdered(@orderID int)
--  AS
--  BEGIN
--   update [Order]
--   SET [Order].total = (SELECT SUM(Order_detail.total)
--              FROM Order_detail
--              WHERE Order_detail.orderID = @orderID)

--insert into Import_detailed (ImID, proID, Quantity) values (1, 1, 5000)
--delete from Import_detailed
--update Import_detailed set Quantity = 100 where proID = 1
--insert into Product (proID) values (1),(2),(3) 
--select*from Import_detailed
--select*from Product
