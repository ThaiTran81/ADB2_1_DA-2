﻿USE qlbh
GO

CREATE NONCLUSTERED INDEX idx_order ON  [Order](uID, dateBill)
CREATE NONCLUSTERED INDEX idx_account ON Account(userid)
CREATE NONCLUSTERED INDEX idx_product ON Product(pname)
CREATE NONCLUSTERED INDEX idx_salary ON Salary(uID)
CREATE NONCLUSTERED INDEX idx_noti ON  [Notification](uid)
