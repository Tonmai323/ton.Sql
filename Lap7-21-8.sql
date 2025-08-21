Select c.CategortNAme, p.ProductName, p.UnitPrice
From Products as p, Categores as c
where p.CatrgoryID = c.CategoryID
and CatrgoryName = 'saefood'

Select c.CategortName, p.ProductName, p.UnitPrice
From Products as p join Categores as c
on p.CategoryID = c.CategoryID
where p.CatrgoryName = 'sefood'

Select ComepanyName , OrderID
From OrderID, Shipers
where Shipers.ShipersID = OrderID.Shipvia
and OrderID = 10275

SELECT CompanyName, OrderID 
FROM Orders JOIN Shippers 
ON Shippers.ShipperID=Orders.Shipvia 
WHERE OrderID=102753

SELECT O.OrderID เลขใบสั่งซื้อ, C.CompanyName ลูกค้า,
E.FirstName พนักงาน, O.ShipAddress ส่งไปที่
FROM Orders O, Customers C, Employees E
WHERE O.CustomerID=C.CustomerID
AND O.EmployeeID=E.EmployeeID

SELECT * from p.roductsID, p.ProductName,ComepanyNameb s.Country
from Products join Suppliers s on p.SuppliersID = s.SuppliersID
where Country in ('usa','uk')

SELECT e.EmployeeID, FirstName, OrderID
from EmployeeID, e join Order on e.EmployeeID = o.EmployeeID
order by EmployeeID

SELECT O.OrderID เลขใบสั่งซื้อ, C.CompanyName ลูกค้า,
       E.FirstName พนักงาน, O.ShipAddress ส่งไปที่ 
FROM Orders O 
join Customers C on O.CustomerID=C.CustomerID 
join Employees E on O.EmployeeID=E.EmployeeID

select e.EmployeeID, FirstName , count(*) as [จ านวน order]
, sum(freight) as [Sum of Freight]
from Employees e join Orders o on e.EmployeeID = o.EmployeeID
where year(orderdate) = 1998
group by e.EmployeeID, FirstName

SELECT s.ComepanyName, coun(*) จำนวนoeders
from Shipers s join ordero on s.ShipersID = o.Shipvia
group by     s.ComepanyName
order by     2 desc

SELECT p.ProductID, p.ProductName, sum(Quantity)จำนวนที่ขายได้
From Products p join [Order DETAILS] od on p.ProductsID = od.ProductsID
group by p.ProductsID, p.ProductsName
