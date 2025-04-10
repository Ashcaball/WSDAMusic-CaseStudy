/* The situation: For a long time, Adams Andrew, Manager of WSDA Music, has been unable to account for a discrepancy in his company’s financials. The furthest he has gotten in his own 
attempts to analyze the company data is figuring out that the discrepancy occurred between the years 2011 and 2012. But that’s about all that Adams knows for certain. 

You have been called in to do what you do best—apply your SQL skills:
 • Analyze WSDA Music’s Data to:
 − Get a list of suspects
 − Narrow your list
 − Pinpoint your prime suspect(s)*/

        /* CHALLENGE 1 | Queries to gain a high level context. */

/*  1. How many transactions took place between the years 2011 and 2012? RESULT: 167*/ 

SELECT 
	count(invoiceid)
FROM
	Invoice
WHERE 
  InvoiceDate BETWEEN '2011-01-01 00:00:00' AND '2012-12-31 00:00:00';

/*  2. How much money did WSDA Music make during the same period?  RESULT: $1947.97 */

SELECT 
	sum(total)
FROM
	Invoice
WHERE 
  InvoiceDate BETWEEN '2011-01-01 00:00:00' AND '2012-12-31 00:00:00';

        /* CHALLENGE 2 | More targeted questions that query tables containing data about customers and employees. */

/*  1. Get a list of customers who made purchases between 2011 and 2012. */

SELECT 
	C.CustomerId,
	C.FirstName,
	C.LastName,
	I.InvoiceDate
FROM
	Customer C
JOIN Invoice I 
ON C.CustomerId = I.CustomerId
WHERE 
 InvoiceDate BETWEEN '2011-01-01 00:00:00' AND '2012-12-31 00:00:00';

/* 2. Get a list of customers, sales reps, and total transaction amounts for each customer between 2011 and 2012. */

SELECT 
	C.CustomerId,
	C.FirstName 'CustomerFirstName',
	C.LastName 'CustomerLastName',
	I.InvoiceDate,
	sum(I.total) 'TotalTransactionAmount',
	C.SupportRepId,
	E.FirstName 'RepFirstName',
	E.LastName 'RepLastName'
FROM
	Customer C
JOIN Invoice I 
ON c.CustomerId = i.CustomerId
JOIN Employee E
ON E.EmployeeId = C.SupportRepId
WHERE InvoiceDate BETWEEN '2011-01-01 00:00:00' AND '2012-12-31 00:00:00'
group by 1;

/* 3. How many transactions are above the average transaction amount during the same time period? */
  /* First I have to find the average transaction amout with this query. RESULT: $11.66 */
SELECT 
	round(AVG(TOTAL),2)
FROM 
	Invoice
WHERE 
	InvoiceDate BETWEEN '2011-01-01 00:00:00' AND '2012-12-31 00:00:00';

 /* With the result from the previous query I can now find how many transactions are above the average. RESULT: 26 */

SELECT 
	C.CustomerId, C.FirstName 'CustomerFirstName', 
	C.LastName 'CustomerLastName', 
	I.InvoiceDate,
	I.total 'TotalTransactionAmount', 
	C.SupportRepId, 
	E.FirstName 'RepFirstName',
	E.LastName 'RepLastName'
FROM
	Customer C
JOIN Invoice I 
ON C.CustomerId = I.CustomerId
JOIN Employee E
ON E.EmployeeId = C.SupportRepId
WHERE I.total > 11.66 AND
InvoiceDate BETWEEN '2011-01-01 00:00:00' AND '2012-12-31 00:00:00'
order by 1;

/*  4. What is the average transaction amount for each year that WSDA Music has been in business? */

SELECT
strftime ('%Y', InvoiceDate) AS Year,
round(avg(total),2) AS 'Average Total'
FROM Invoice
group by 1;

        /* CHALLENGE 3 | Queries to perform an in depth analysis with the aim of finding employees who may have been finacially motivated to commit crime */

/*  1. Get a list of employees who exceeded the average transaction amount from sales they  
generated during 2011 and 2012. */
 /* Using the previous query I was able to find that the average transaction amount for 2011 was $17.72 and for 2012 it was $5.75, using those amounts I created this query*/
SELECT 
	C.CustomerId,
	I.InvoiceDate,
	I.total 'TotalTransactionAmount', 
	C.SupportRepId, 
	E.FirstName 'RepFirstName',
	E.LastName 'RepLastName'
FROM
	Customer C
JOIN Invoice I 
ON C.CustomerId = I.CustomerId
JOIN Employee E
ON E.EmployeeId = C.SupportRepId
WHERE 
I.total > 17.51 AND
InvoiceDate BETWEEN '2011-01-01 00:00:00' AND '2011-12-31 00:00:00'
OR 
I.total > 5.75 AND
InvoiceDate BETWEEN '2012-01-01 00:00:00' AND '2012-12-31 00:00:00'
order by 2;

/* 2. Create a Commission Payout column that displays each employee’s commission based on 15% of the sales transaction amount. */

SELECT 
	C.CustomerId,
	I.InvoiceDate,
	I.total 'TotalTransactionAmount', 
	C.SupportRepId, 
	E.FirstName 'RepFirstName',
	E.LastName 'RepLastName',
	round((I.total*0.15),2) AS 'Commission'
FROM
	Customer C
JOIN Invoice I 
ON C.CustomerId = I.CustomerId
JOIN Employee E
ON E.EmployeeId = C.SupportRepId
WHERE 
I.total > 17.51 AND
InvoiceDate BETWEEN '2011-01-01 00:00:00' AND '2011-12-31 00:00:00'
OR 
I.total > 5.75 AND
InvoiceDate BETWEEN '2012-01-01 00:00:00' AND '2012-12-31 00:00:00'
order by 7 DESC;

/*  3. Which employee made the highest commission? */

Based on the previous query ordering the 'Commission' field in descending order Jane Peacock 
had the highest commosion of $150.00.

/*  4. List the customers that the employee identified in the last question. */

	SELECT 
	C.CustomerId,
	C.FirstName,
	C.LastName,
	I.InvoiceDate,
	I.total 'TotalTransactionAmount', 
	C.SupportRepId, 
	E.FirstName 'RepFirstName',
	E.LastName 'RepLastName',
	round((I.total*0.15),2) AS 'Commission'
FROM
	Customer C
JOIN Invoice I 
ON C.CustomerId = I.CustomerId
JOIN Employee E
ON E.EmployeeId = C.SupportRepId
WHERE
C.SupportRepId = '3' AND
(I.total > 17.51 AND
InvoiceDate BETWEEN '2011-01-01 00:00:00' AND '2011-12-31 00:00:00'
OR 
I.total > 5.75 AND
InvoiceDate BETWEEN '2012-01-01 00:00:00' AND '2012-12-31 00:00:00')
order by 5 DESC;

/*  5. Which customer made the highest purchase? */

Based on the previous query I ideantified all customers Jane Peacock worked with. Then, ordering the 
'TotalTransactionAmount' in desceinging order i found that 'John Doeein' made the highest purchase of $1000.86.
	
/*  6. Look at this customer record—do you see anything suspicious? */

Yes, the next highest purchase amount is only $21.86, which is significatly lower.
	
/*  7. Who do you conclude is our primary person of interest? */

'Jane Peacock' is the Primary person of interest for having earned a commission significatly higher than any other 
employee.
