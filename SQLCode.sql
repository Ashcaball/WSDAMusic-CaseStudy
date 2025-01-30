/* WSDA Music SQL Code */

/* Displaying track offerings with pricing details */

SELECT Name AS "Track Name", UnitPrice AS "PRICE"
FROM Track AS "T"
Order by name
LIMIT 20;

/* Placing the unit prices into categories*/

SELECT 
Name AS "Track Name", 
Composer, 
UnitPrice AS Price,
CASE
WHEN UnitPrice <= .99 THEN 'Budget'
WHEN UnitPrice BETWEEN .99 AND 1.49 THEN 'Regular'
WHEN UnitPrice BETWEEN 1.49 AND 1.99 THEN 'Premium'
ELSE 'Exclusive'
END AS PriceCategory
FROM Track
ORDER BY UnitPrice ASC;

/* Gathering more customer data by combining 'Customer' and 'Invoice' Tables */
SELECT *
FROM Invoice 
JOIN Customer 
ON Invoice.CustomerId = Customer.CustomerId
ORDER BY Customer.CustomerId:
  
SELECT C.CustomerId, C.FirstName, C.LastName, I.InvoiceDate, I.BillingCity, I.total
FROM Customer C
LEFT JOIN Invoice I 
ON C.CustomerId = I.CustomerId;

/* What employees are reponsible for the top 10 individual sales? I will join Invoice, Customer, and Employee tables to find this data. */

SELECT 
E.FirstName,
E.LastName,
C.FirstName,
C.LastName,
C.SupportRepId,
I.CustomerId,
I.total
FROM  
	Invoice I
INNER JOIN 
	Customer C
ON 
I.CustomerId = C.CustomerId
INNER JOIN 
	Employee E
ON 
C.SupportRepId = E.EmployeeId
ORDER BY
 I.total DESC
LIMIT 10;

/* Listing customers along with their support reprisentatives by joinng 'Customer' and 'Employee' Tables. */

SELECT 
    c.FirstName AS CustomerFirstName,
    c.LastName AS CustomerLastName,
    e.FirstName AS SupportRepFirstName,
    e.LastName AS SupportRepLastName
FROM Customer AS c
INNER JOIN Employee AS e
ON c.SupportRepId = e.EmployeeId
ORDER BY e.LastName, c.LastName;

/* Customer Mailing Address*/
SELECT 
	FirstName,
	LastName,
	Address,
	FirstName ||' '|| LastName ||' '|| Address||','||City||','||State||' '||PostalCode AS MailingAddress
FROM
	Customer
WHERE 
	Country = 'USA'


