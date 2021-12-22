USE qlbh
GO

DROP TRIGGER trg_update_sales

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