use qlbh
go


-----Kha
--trigger order detail cập nhật stock bên bảng product
--trigger import detail cập nhật stock bên bảng product

create or alter trigger Product_Stock_Insert on Order_Detail
for insert
as
begin
	update Product
	set stocks -= (select i.quantity from inserted i join Product p on i.proID = p.proID)
	where proID = (select proID from inserted)
end
go

create or alter trigger Product_Stock_Delete on Order_Detail
for delete
as
begin
	update Product
	set stocks += (select d.quantity from deleted d join Product p on d.proID = p.proID)
	where proID = (select proID from deleted)
end
go

create or alter trigger Product_Stock_Update on Order_Detail
for update
as
begin
	update Product
	set stocks += (select d.quantity from deleted d join Product p on d.proID = p.proID) - (select i.quantity from inserted i join Product p on i.proID = p.proID)
	where proID = (select proID from inserted)
end
go

----- 

create or alter trigger ImportDetailed_Product_Stock_Insert on Import_detailed
for insert
as
begin
	update Product
	set stocks += (select i.Quantity from inserted i join Product p on i.proID = p.proID)
	where proID = (select proID from inserted)
end
go

create or alter trigger ImportDetail_Product_Stock_Delete on Import_detailed
for delete
as
begin
	update Product
	set stocks -= (select d.Quantity from deleted d join Product p on d.proID = p.proID)
	where proID = (select proID from deleted)
end
go

create or alter trigger ImportDetailed_Product_Stock_Update on Import_detailed
for update
as
begin
	select * from inserted
	select * from deleted
	update Product
	set stocks -= (select d.Quantity from deleted d join Product p on d.proID = p.proID) + (select i.Quantity from inserted i join Product p on i.proID = p.proID)
	where proID = (select proID from inserted)
end
go

--insert into Import_detailed (ImID, proID, Quantity) values (1, 1, 5000)
--delete from Import_detailed
--update Import_detailed set Quantity = 100 where proID = 1
--insert into Product (proID) values (1),(2),(3) 
--select*from Import_detailed
--select*from Product
