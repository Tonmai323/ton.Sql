SELECT title FROM Employees where FirstName = 'Nancy';

Select * FROM Employees
where Title = (Select Title
FROM Employees
where FirstName = 'Nancy')

Select Firstname, Lastname from Employees
where BirthDate = (Select min(BirthDate) from Employees)

Select ProductName from Products
where UnitPrice > (Select UnitPrice from Products
where ProductName = 'Ikura')

SELECT CompanyName FROM Customers
WHERE City = (Select city from Customers
where CompanyName = 'Around the Horn')

SELECT FirstName, LastName
FROM Employees
WHERE HireDate > (
    SELECT MAX(HireDate)
    FROM Employees);


--ข้อมูลใบสั่งซื้อที่ถูกส่งไปประเทศที่ไม่มีผู้ผลิตสินค้าตั้งอยู่
SELECT *
FROM Orders
WHERE ShipCountry NOT IN (
    SELECT DISTINCT Country
    FROM Suppliers
);

--การใส่ตัวเลขลำดับ
--ต้องการข้อมูลสินค้าที่มีราคาน้อยกว่า 50$
Select ROW_NUMBER() OVER(ORDER BY UnitPrice DESC) AS RowNum,
ProductName, UnitPrice 
from Products
where UnitPrice < 50


SELECT * from Shippers

SELECT * from Employees

Insert into Shippers
VALUES('บริษัทขนสเยอะจำกัด','081-2345678')

insert into Shippers(CompanyName)
VALUES('บริษัทมหาศาลกำจัด')

SELECT * from Customers
--ตารางที่มี PK เป็น Char, nChar
insert into Customers(CustomerID, CompanyName)
VALUES('A0001','บริษัทซื้อเยอะจำกัด')


--จงเพิ่มข้อมูลพนักงาน 1 คน (ใส่ข้อมูลเท่าที่มี)
INsert into Employees (FirstName,LastName)
VALUES ('สมชาย','ใจดี')

--จงเพิ่มสินค้า ปลาแดกบอง ราคา 1.5฿ จำนวน 12
INSERT Into Products (ProductName, UnitPrice, UnitsInStock)
VALUES ('ปลาแดกบอง', 1.5, 12)

Select * from Products

--ปรับปรุงจำนวนสินค้า 
Update Shippers
set Phone = '099-9999999'
where ShipperID = 6

select * from Shippers

Update Products
set UnitsInStock = UnitsInStock + 100
where ProductID = 1

Select * from Products

UPDATE Customers
set City = 'อุดรธานี' , Country = 'Thailand'
where CustomerID = 'A0001'

Select * from Customers

DELETE from Products
where ProductID = 78

DELETE from Shippers
where ShipperID = 6
