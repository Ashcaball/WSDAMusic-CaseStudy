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

