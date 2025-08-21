//ไพรัตน์ หลวงจุมพล 67040233125//
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

Select ComepanyName , OrderID
From OrderID, Shipers
where Shipers.ShipersID = OrderID.Shipvia
and OrderID = 10275
