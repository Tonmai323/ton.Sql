1. จงแสดงให้เห็นว่าพนักงานแต่ละคนขายสินค้าประเภท Beverage ได้เป็นจำนวนเท่าใด และเป็นจำนวนกี่ชิ้น เฉพาะครึ่งปีแรกของ 2540(ทศนิยม 4 ตำแหน่ง)
  SELECT
  e.EmployeeID,
  e.FirstName + ' ' + e.LastName AS EmployeeFullName,
  CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS TotalAmount_Beverage,
  CAST(SUM(od.Quantity) AS DECIMAL(18,4)) AS TotalQuantity_Beverage
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages'
  AND o.OrderDate >= '1997-01-01' AND o.OrderDate < '1997-07-01'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY e.EmployeeID;

2. จงแสดงชื่อบริษัทตัวแทนจำหน่าย เบอร์โทร เบอร์แฟกซ์ ชื่อผู้ติดต่อ จำนวนชนิดสินค้าประเภท Beverage ที่จำหน่าย โดยแสดงจำนวนสินค้า จากมากไปน้อย 3 อันดับแรก
  SELECT TOP(3)
  s.SupplierID,
  s.CompanyName,
  s.Phone,
  s.Fax,
  s.ContactName,
  COUNT(DISTINCT p.ProductID) AS Beverage_Product_Count
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages'
GROUP BY s.SupplierID, s.CompanyName, s.Phone, s.Fax, s.ContactName
ORDER BY Beverage_Product_Count DESC;

3.   จงแสดงข้อมูลชื่อลูกค้า ชื่อผู้ติดต่อ เบอร์โทรศัพท์ ของลูกค้าที่ซื้อของในเดือน สิงหาคม 2539 ยอดรวมของการซื้อโดยแสดงเฉพาะ ลูกค้าที่ไม่มีเบอร์แฟกซ์
  SELECT
  cu.CompanyName,
  cu.ContactName,
  cu.Phone,
  CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS TotalAmount_Aug_1996
FROM Customers cu
JOIN Orders o ON cu.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE MONTH(o.OrderDate) = 8 AND YEAR(o.OrderDate) = 1996
  AND (cu.Fax IS NULL OR LTRIM(RTRIM(cu.Fax)) = '')
GROUP BY cu.CompanyName, cu.ContactName, cu.Phone
HAVING SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) > 0
ORDER BY TotalAmount_Aug_1996 DESC;

4.   แสดงรหัสสินค้า ชื่อสินค้า จำนวนที่ขายได้ทั้งหมดในปี 2541 ยอดเงินรวมที่ขายได้ทั้งหมดโดยเรียงลำดับตาม จำนวนที่ขายได้เรียงจากน้อยไปมาก พรอ้มทั้งใส่ลำดับที่ ให้กับรายการแต่ละรายการด้วย
  WITH SalesByProduct AS (
  SELECT
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalQuantity,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalAmount
  FROM Products p
  JOIN [Order Details] od ON p.ProductID = od.ProductID
  JOIN Orders o ON od.OrderID = o.OrderID
  WHERE YEAR(o.OrderDate) = 1998
  GROUP BY p.ProductID, p.ProductName
)
SELECT
  ROW_NUMBER() OVER (ORDER BY TotalQuantity ASC) AS RankByQuantity,
  ProductID,
  ProductName,
  CAST(TotalQuantity AS INT) AS TotalQuantity,
  CAST(TotalAmount AS DECIMAL(18,4)) AS TotalAmount
FROM SalesByProduct
ORDER BY TotalQuantity ASC;

5.   จงแสดงข้อมูลของสินค้าที่ขายในเดือนมกราคม 2540 เรียงตามลำดับจากมากไปน้อย 5 อันดับใส่ลำดับด้วย รวมถึงราคาเฉลี่ยที่ขายให้ลูกค้าทั้งหมดด้วย
  WITH JanSales AS (
  SELECT
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalQty,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalAmount
  FROM [Order Details] od
  JOIN Orders o ON od.OrderID = o.OrderID
  JOIN Products p ON od.ProductID = p.ProductID
  WHERE o.OrderDate >= '1997-01-01' AND o.OrderDate < '1997-02-01'
  GROUP BY p.ProductID, p.ProductName
)
SELECT TOP 5
  ROW_NUMBER() OVER (ORDER BY TotalQty DESC) AS RankDesc,
  ProductID,
  ProductName,
  TotalQty,
  CAST(TotalAmount / NULLIF(TotalQty,0) AS DECIMAL(18,4)) AS AvgPricePerUnit,
  CAST(TotalAmount AS DECIMAL(18,4)) AS TotalAmount
FROM JanSales
ORDER BY TotalQty DESC;

6.   จงแสดงชื่อพนักงาน จำนวนใบสั่งซื้อ ยอดเงินรวมทั้งหมด ที่พนักงานแต่ละคนขายได้ ในเดือน ธันวาคม 2539 โดยแสดงเพียง 5 อันดับที่มากที่สุด
  SELECT TOP 5
  e.EmployeeID,
  e.FirstName + ' ' + e.LastName AS EmployeeName,
  COUNT(DISTINCT o.OrderID) AS OrderCount,
  CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS TotalSalesAmount
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= '1996-12-01' AND o.OrderDate < '1997-01-01'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY TotalSalesAmount DESC;

7.   จงแสดงรหัสสินค้า ชื่อสินค้า ชื่อประเภทสินค้า ที่มียอดขาย สูงสุด 10 อันดับแรก ในเดือน ธันวาคม 2539 โดยแสดงยอดขาย และจำนวนที่ขายด้วย
  SELECT TOP 10
  p.ProductID,
  p.ProductName,
  c.CategoryName,
  SUM(od.Quantity) AS TotalQty,
  CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS TotalSalesAmount
FROM [Order Details] od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE o.OrderDate >= '1996-12-01' AND o.OrderDate < '1997-01-01'
GROUP BY p.ProductID, p.ProductName, c.CategoryName
ORDER BY TotalSalesAmount DESC;

8.   จงแสดงหมายเลขใบสั่งซื้อ ชื่อบริษัทลูกค้า ที่อยู่ เมืองประเทศของลูกค้า ชื่อเต็มพนักงานผู้รับผิดชอบ ยอดรวมในแต่ละใบสั่งซื้อ จำนวนรายการสินค้าในใบสั่งซื้อ และเลือกแสดงเฉพาะที่จำนวนรายการในใบสั่งซื้อมากกว่า 2 รายการ
SELECT
  o.OrderID,
  c.CompanyName,
  c.Address,
  c.City,
  c.Country,
  e.FirstName + ' ' + e.LastName AS EmployeeFullName,
  CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS OrderTotalAmount,
  COUNT(od.ProductID) AS ItemCount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Employees e ON o.EmployeeID = e.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, c.CompanyName, c.Address, c.City, c.Country, e.FirstName, e.LastName
HAVING COUNT(od.ProductID) > 2
ORDER BY o.OrderID;

  9.   จงแสดง ชื่อบริษัทลูกค้า ชื่อผู้ติดต่อ เบอร์โทร เบอร์แฟกซ์ ยอดที่สั่งซื้อทั้งหมดในเดือน ธันวาคม 2539 แสดงผลเฉพาะลูกค้าที่มีเบอร์แฟกซ์
    SELECT
  c.CompanyName,
  c.ContactName,
  c.Phone,
  c.Fax,
  CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS TotalOrderedAmount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= '1996-12-01' AND o.OrderDate < '1997-01-01'
  AND c.Fax IS NOT NULL AND LTRIM(RTRIM(c.Fax)) <> ''
GROUP BY c.CompanyName, c.ContactName, c.Phone, c.Fax
ORDER BY TotalOrderedAmount DESC;

10.  จงแสดงชื่อเต็มพนักงาน จำนวนใบสั่งซื้อที่รับผิดชอบ ยอดขายรวมทั้งหมด เฉพาะในไตรมาสสุดท้ายของปี 2539 เรียงตามลำดับ มากไปน้อยและแสดงผลตัวเลขเป็นทศนิยม 4 ตำแหน่ง
  SELECT
  e.EmployeeID,
  e.FirstName + ' ' + e.LastName AS EmployeeFullName,
  COUNT(DISTINCT o.OrderID) AS OrderCount,
  CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS TotalSalesAmount
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= '1996-10-01' AND o.OrderDate < '1997-01-01'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY TotalSalesAmount DESC;

11.  จงแสดงชื่อพนักงาน และแสดงยอดขายรวมทั้งหมด ของสินค้าที่เป็นประเภท Beverage ที่ส่งไปยังประเทศ ญี่ปุ่น
  SELECT
  e.EmployeeID,
  e.FirstName + ' ' + e.LastName AS EmployeeFullName,
  CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS BeverageSalesToJapan
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages'
  AND o.ShipCountry = 'Japan'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY BeverageSalesToJapan DESC;

12.  แสดงรหัสบริษัทตัวแทนจำหน่าย ชื่อบริษัทตัวแทนจำหน่าย ชื่อผู้ติดต่อ เบอร์โทร ชื่อสินค้าที่ขาย เฉพาะประเภท Seafood ยอดรวมที่ขายได้แต่ละชนิด แสดงผลเป็นทศนิยม 4 ตำแหน่ง เรียงจาก มากไปน้อย 10 อันดับแรก
SELECT TOP 10
  s.SupplierID,
  s.CompanyName AS SupplierCompany,
  s.ContactName,
  s.Phone,
  p.ProductName,
  CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS TotalSalesAmount
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE c.CategoryName = 'Seafood'
GROUP BY s.SupplierID, s.CompanyName, s.ContactName, s.Phone, p.ProductName
ORDER BY TotalSalesAmount DESC;

13.  จงแสดงชื่อเต็มพนักงานทุกคน วันเกิด อายุเป็นปีและเดือน พร้อมด้วยชื่อหัวหน้า
SELECT
  e.EmployeeID,
  e.FirstName + ' ' + e.LastName AS EmployeeFullName,
  CONVERT(varchar(10), e.BirthDate, 23) AS BirthDate,
  -- Age in years and months
  DATEDIFF(year, e.BirthDate, GETDATE())
    - CASE
        WHEN (MONTH(e.BirthDate) > MONTH(GETDATE())) OR (MONTH(e.BirthDate) = MONTH(GETDATE()) AND DAY(e.BirthDate) > DAY(GETDATE()))
        THEN 1 ELSE 0 END
    AS AgeYears,
  (
    DATEDIFF(month, e.BirthDate, GETDATE())
    - (DATEDIFF(year, e.BirthDate, GETDATE())
       - CASE
         WHEN (MONTH(e.BirthDate) > MONTH(GETDATE())) OR (MONTH(e.BirthDate) = MONTH(GETDATE()) AND DAY(e.BirthDate) > DAY(GETDATE()))
         THEN 1 ELSE 0 END
       ) * 12
  ) AS AgeMonths,
  mgr.FirstName + ' ' + mgr.LastName AS ManagerName
FROM Employees e
LEFT JOIN Employees mgr ON e.ReportsTo = mgr.EmployeeID
ORDER BY e.EmployeeID;
  
14.  จงแสดงชื่อบริษัทลูกค้าที่อยู่ในประเทศ USA และแสดงยอดเงินการซื้อสินค้าแต่ละประเภทสินค้า
  SELECT
  c.CustomerID,
  c.CompanyName,
  cat.CategoryName,
  CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS TotalByCategory
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE c.Country = 'USA'
GROUP BY c.CustomerID, c.CompanyName, cat.CategoryName
ORDER BY c.CompanyName, TotalByCategory DESC;

15.  แสดงข้อมูลบริษัทผู้จำหน่าย ชื่อบริษัท ชื่อสินค้าที่บริษัทนั้นจำหน่าย จำนวนสินค้าทั้งหมดที่ขายได้และราคาเฉลี่ยของสินค้าที่ขายไปแต่ละรายการ แสดงผลตัวเลขเป็นทศนิยม 4 ตำแหน่ง
  SELECT
  s.SupplierID,
  s.CompanyName AS SupplierName,
  p.ProductID,
  p.ProductName,
  SUM(od.Quantity) AS TotalQtySold,
  CAST(AVG(od.UnitPrice * (1 - od.Discount)) AS DECIMAL(18,4)) AS AvgSoldPricePerUnit
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY s.SupplierID, s.CompanyName, p.ProductID, p.ProductName
ORDER BY s.CompanyName, TotalQtySold DESC;

16.  ต้องการชื่อบริษัทผู้ผลิต ชื่อผู้ต่อต่อ เบอร์โทร เบอร์แฟกซ์ เฉพาะผู้ผลิตที่อยู่ประเทศ ญี่ปุ่น พร้อมทั้งชื่อสินค้า และจำนวนที่ขายได้ทั้งหมด หลังจาก 1 มกราคม 2541
  SELECT
  s.SupplierID,
  s.CompanyName,
  s.ContactName,
  s.Phone,
  s.Fax,
  p.ProductID,
  p.ProductName,
  SUM(od.Quantity) AS TotalQtySoldAfter1998
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE s.Country = 'Japan'
  AND o.OrderDate > '1998-01-01'
GROUP BY s.SupplierID, s.CompanyName, s.ContactName, s.Phone, s.Fax, p.ProductID, p.ProductName
ORDER BY s.CompanyName, TotalQtySoldAfter1998 DESC;

17.  แสดงชื่อบริษัทขนส่งสินค้า เบอร์โทรศัพท์ จำนวนรายการสั่งซื้อที่ส่งของไปเฉพาะรายการที่ส่งไปให้ลูกค้า ประเทศ USA และ Canada แสดงค่าขนส่งโดยรวมด้วย
  SELECT
  sh.ShipperID,
  sh.CompanyName AS ShipperName,
  sh.Phone,
  COUNT(o.OrderID) AS ShipOrderCount,
  CAST(SUM(o.Freight) AS DECIMAL(18,4)) AS TotalFreight
FROM Shippers sh
JOIN Orders o ON sh.ShipperID = o.ShipVia
WHERE o.ShipCountry IN ('USA','Canada')
GROUP BY sh.ShipperID, sh.CompanyName, sh.Phone
ORDER BY ShipOrderCount DESC;

18.  ต้องการข้อมูลรายชื่อบริษัทลูกค้า ชื่อผู้ติดต่อ เบอร์โทรศัพท์ เบอร์แฟกซ์ ของลูกค้าที่ซื้อสินค้าประเภท Seafood แสดงเฉพาะลูกค้าที่มีเบอร์แฟกซ์เท่านั้น
  SELECT DISTINCT
  c.CustomerID,
  c.CompanyName,
  c.ContactName,
  c.Phone,
  c.Fax
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE cat.CategoryName = 'Seafood'
  AND c.Fax IS NOT NULL AND LTRIM(RTRIM(c.Fax)) <> '';

19.  จงแสดงชื่อเต็มของพนักงาน  วันเริ่มงาน (รูปแบบ 105) อายุงานเป็นปี เป็นเดือน ยอดขายรวม เฉพาะสินค้าประเภท Condiment ในปี 2540
  SELECT
  e.EmployeeID,
  e.FirstName + ' ' + e.LastName AS EmployeeFullName,
  CONVERT(varchar(10), e.HireDate, 105) AS HireDate_105,
  -- Employment duration (years and months) up to end of 1997
  DATEDIFF(year, e.HireDate, '1997-12-31')
    - CASE WHEN (MONTH(e.HireDate) > MONTH('1997-12-31')) OR (MONTH(e.HireDate) = MONTH('1997-12-31') AND DAY(e.HireDate) > DAY('1997-12-31')) THEN 1 ELSE 0 END
    AS EmploymentYears,
  (
    DATEDIFF(month, e.HireDate, '1997-12-31')
    - (
        DATEDIFF(year, e.HireDate, '1997-12-31')
        - CASE WHEN (MONTH(e.HireDate) > MONTH('1997-12-31')) OR (MONTH(e.HireDate) = MONTH('1997-12-31') AND DAY(e.HireDate) > DAY('1997-12-31')) THEN 1 ELSE 0 END
      ) * 12
  ) AS EmploymentMonths,
  CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS CondimentSales1997
FROM Employees e
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
LEFT JOIN Products p ON od.ProductID = p.ProductID
LEFT JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE o.OrderDate >= '1997-01-01' AND o.OrderDate < '1998-01-01'
  AND cat.CategoryName = 'Condiments'
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.HireDate;

20.  จงแสดงหมายเลขใบสั่งซื้อ  วันที่สั่งซื้อ(รูปแบบ 105) ยอดขายรวมทั้งหมด ในแต่ละใบสั่งซื้อ โดยแสดงเฉพาะ ใบสั่งซื้อที่มียอดจำหน่ายสูงสุด 10 อันดับแรก
SELECT TOP 10
  o.OrderID,
  CONVERT(varchar(10), o.OrderDate, 105) AS OrderDate_105,
  CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,4)) AS OrderTotalAmount
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.OrderDate
ORDER BY OrderTotalAmount DESC;

