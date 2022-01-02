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

--insert into Import_detailed (ImID, proID, Quantity) values (1, 1, 5000)
--delete from Import_detailed
--update Import_detailed set Quantity = 100 where proID = 1
--insert into Product (proID) values (1),(2),(3) 
--select*from Import_detailed
--select*from Product
