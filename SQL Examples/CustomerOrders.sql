
--Write a SQL query that will produce a reverse-sorted list (alphabetically by name) of 
--customers (first and last names) whose last name begins with the letter ‘S.’
SELECT m.LastName,
       m.FirstName
FROM dbo.tblCustomer m
WHERE m.LastName LIKE 'S%'
ORDER BY m.LastName DESC,
         m.FirstName DESC;
GO
--Write a SQL query that will show the total value of all orders each 
--customer has placed in the past six months. Any customer without any 
--orders should show a $0 value.
DECLARE @now DATETIME = GETDATE();
WITH OrderLastSixMonths
AS (SELECT oh.OrderID,
           oh.CustID,
           SUM(ol.Cost * ol.Quantity) OrderTotal
    FROM dbo.tblOrderHeader oh
        JOIN dbo.tblOrderLine ol
            ON ol.OrderID = oh.OrderID
    WHERE DATEDIFF(MONTH, oh.OrderDate, @now) = 6
    GROUP BY oh.OrderID,
             oh.CustID)
SELECT m.FirstName,
       m.LastName,
       SUM(ISNULL(o.OrderTotal, 0)) TotalOrderTotal
FROM dbo.tblCustomer m
    LEFT OUTER JOIN OrderLastSixMonths o
        ON o.CustID = m.CustID_FK
GROUP BY m.FirstName,
         m.LastName
ORDER BY m.LastName DESC,
         m.FirstName DESC;
GO
--Amend the query from the previous question to only show those customers 
--who have a total order value of more than $100 and 
--less than $500 in the past six months.
DECLARE @now DATETIME = GETDATE();
WITH OrderLastSixMonths
AS (SELECT oh.OrderID,
           oh.CustID,
           SUM(ol.Cost * ol.Quantity) OrderTotal
    FROM dbo.tblOrderHeader oh
        JOIN dbo.tblOrderLine ol
            ON ol.OrderID = oh.OrderID
    WHERE DATEDIFF(MONTH, oh.OrderDate, @now) = 6
    GROUP BY oh.OrderID,
             oh.CustID)
SELECT m.FirstName,
       m.LastName,
       SUM(ISNULL(o.OrderTotal, 0)) TotalOrderTotal
FROM dbo.tblCustomer m
    LEFT OUTER JOIN OrderLastSixMonths o
        ON o.CustID = m.CustID_FK
GROUP BY m.FirstName,
         m.LastName
HAVING SUM(ISNULL(o.OrderTotal, 0)) > 100
       AND SUM(ISNULL(o.OrderTotal, 0)) > 500
ORDER BY m.LastName DESC,
         m.FirstName DESC;
GO


