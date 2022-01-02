use qlbh
 go
--drop trigger trg_import_Total
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
--
--  END

