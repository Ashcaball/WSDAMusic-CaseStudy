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

/*Putting together Customer Mailing Address*/
SELECT 
	FirstName,
	LastName,
	Address,
	FirstName ||' '|| LastName ||' '|| Address||','||City||','||State||' '||PostalCode AS MailingAddress
FROM
	Customer
WHERE 
	Country = 'USA';

/* Practice with string functions */

SELECT 
	FirstName,
	LastName,
	Address,
	FirstName ||' '|| LastName ||' '|| Address||','||City||','||State||' '||PostalCode AS MailingAddress,
	length (postalcode),
	substr(postalcode,1,5) AS '5 Digit Zip',
	upper(firstname) AS 'AllCapFistName',
	lower(lastname) AS 'AllCapLastName'
FROM
	Customer
WHERE 
	Country = 'USA';

SELECT  
	FirstName || ' ' || LastName AS "CUSTOMERFULLNAME",
	substr('ZIPCODE',1,5) AS "STANDARDIZEDPOSTALCODE"
FROM 
	Customer;
/* Claculating e,ployee age using the strftime() function */

SELECT 
	FirstName,
	LastName,
	BirthDate,
	strftime('%Y-%m-%d',Birthdate) AS 'BirthDate No Timecode',
	strftime ('%Y-%m-%d','now') - strftime('%Y-%m-%d',Birthdate) AS EmployeeAge
FROM
	Employee;

/* Practice with aggregate functions */
SELECT
	sum(total) AS 'TotalSales',
	round((avg(total)),2) AS 'AverageSales',
	max(total) AS 'MaxSale',
	min(total) AS 'MinTotal',
	Count(*) AS 'Sale Count'
FROM 
	Invoice
	

/* What is the average invoice total for each city? */

SELECT 
	BillingCity, round(avg(total),2)
FROM
	Invoice
group by 1
order by 1;

/* What are the averae invoice totals by country and city? */
SELECT 
	BillingCountry, 
	BillingCity, 
	round(avg(total),2)
FROM 
	Invoice
GROUP BY BillingCountry, BillingCity 
ORDER BY BillingCountry;

/* Subquery | Gather data about all invoices that are less than the average total */

SELECT 
	InvoiceDate,
	BillingAddress,
	BillingCity,
	total
FROM
	Invoice
WHERE 
	total < (SELECT avg(total) FROM Invoice)
ORDER BY 
	total DESC;

/* Subquery | How is each individual city performing against the global averaeg sales? */

SELECT 
	BillingCity,
	round((AVG(total)),2) AS 'City Average',
	(SELECT round((AVG(total)),2) FROM INVOICE) AS 'Global Average'
FROM
	Invoice
GROUP BY 
	BillingCity 
ORDER BY 
	BillingCity;

/* Subquery | Non- Agregate */

SELECT
	InvoiceDate,
	BillingAddress,
	BillingCity
FROM
	Invoice
WHERE 
	InvoiceDate >
(SELECT 
	InvoiceDate FROM Invoice WHERE InvoiceId = 251);

/* Subquery | Returning Multiple Values */

SELECT 
	InvoiceDate,
	BillingAddress,
	BillingCity
FROM
	Invoice
WHERE
	InvoiceDate IN
(SELECT InvoiceDate FROM Invoice WHERE InvoiceId IN (251, 252, 254));

/* Subquery | Using DISTINCT - Which tracks are not selling? */

SELECT 
	TrackId,
	Composer,
	Name
FROM 
	Track
WHERE TrackId
NOT IN
(SELECT 
	DISTINCT
	TrackId
FROM 
	InvoiceLine
ORDER BY 
	TrackId);

/* Subquery | Identify track that have never been sold, by using a JOIN and DISTINCT */

SELECT 
	t.TrackID AS "TrackId",
	t.Name AS "TrackName",
	t.Composer,
	g.Name AS Genre
FROM 
	Track t
JOIN 
	Genre g ON t.GenreId = g.GenreId
WHERE 
	t.TrackId NOT IN 
	(SELECT DISTINCT li.TrackId
	FROM InvoiceLine li)
	ORDER BY 2 ASC;

/* Creating Views */

CREATE VIEW V_AvgTotal AS 
SELECT
	round(avg(total),2) AS "Average Total"
FROM
	Invoice;

/* DML | Inserting Data */

INSERT INTO
	Artist(Name)
	VALUES ("Rauw Alejandro");

/* DML | Updating Data */
UPDATE
Artist
SET Name = "Bad Bunny"
WHERE ArtistId = 276;
