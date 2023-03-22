######## Summarizing Data Using the GROUPING sets Operator  ########
## you summarize data by using the GROUP BY clause within an
# aggregate query. 
##This clause creates groupings which are defined by a set of expressions.

####One row per unique combination of the expressions in the GROUP BY clause is returned,
##and aggregate functions such as COUNT or SUM may be used on any columns in the query

### SYNTAX FOR GROUPING ##
#  SELECT   column1, column2, column3, .. 
#  FROM     table_name
#  GROUP BY column1, column2, column3,…

##### OR ####
# SELECT column_name(s)
# FROM table_name
# WHERE condition
# GROUP BY column_name(s)
# ORDER BY column_name(s);

### ORDER BY -- sort the result in either ASCENDING ORDER (ASC) OR DESCENDING ORDER (DESC).
##controls the presentation of the columns
### GROUP BY -- Its groups rows that have the same values. It is often use with aggregate functions 
##e.g count(), max(), min(), sum(), avg(). groupby control the presentation of the rows
## The GROUP BY statement groups rows that have the same values into summary rows, like 
## "find the number of customers in each country".
##

use classicmodels;

select * from employees;

######### Using the Group by Clause #############
select lastName, count(*) 
from employees 
group by lastName;

-- select all not null vaues based on a column

select * from orders;
select * from orders where  comments is not null;

select shippedDate, count(shippedDate)
from orders
group by shippedDate;

select * from orders;

select  orderNumber, count(*)
from orders
group by orderNumber;

### to check how many time a customer appears and the total sum
select * from payments;

select customernumber,count(customernumber), sum(amount) as total_amount
from payments
group by customernumber
order by total_amount desc;

# now using the productLines table
select * from productLines;

### we want to get the productline and the count
select productLine, count(productLine)
from productLines
group by productLine;

desc productLines;

-- count the jobtitles  
select * from employees;

select jobTitle, count(*) 
from employees 
group by jobTitle;

######## Using the order by clause ########
## note by default the the order by will come out in ascending order
select jobTitle
from employees 
order by jobTitle desc;

select * from orderdetails;

select productCode,count(*) 
from orderdetails 
group by productCode
order by count(*) desc;

/*
########  class-work #############
1. from customer table select the customer name, 
phonenumber and city and arrange it in descending order using
the city. 
2. from customer table select the customerNumber, lastname,
firstname and city and order them by city.
3. from the employees table get the total number of employees with the job title salesrep;
4. from the employees table get the name of employess tha thier lastname start with "P"
5. from the office table select all the columns and order them by country
6. select the orderNumber, and the average price and group by their 
orderNumber from orderdetails.
*/

#################### Using Aliase ############## 
SELECT * FROM payments;

SELECT
	YEAR(paymentDate) AS paymentYear,
	MONTH(paymentDate) AS paymentMonth
	-- SUM(amount) AS paymentSum
FROM payments;


SELECT
	YEAR(paymentDate) AS paymentYear,
	MONTH(paymentDate) AS paymentMonth,
	SUM(amount) AS paymentSum
FROM payments
GROUP BY YEAR(paymentDate), MONTH(paymentDate)
ORDER BY YEAR(paymentDate) desc, MONTH(paymentDate) desc;


SELECT
	YEAR(paymentDate) AS paymentYear,
	MONTH(paymentDate) AS paymentMonth,
	SUM(amount) AS paymentSum
FROM payments
GROUP BY paymentYear, paymentMonth
ORDER BY paymentYear, paymentMonth;

select * from orders;

######### Using the Having Clause #############
#The HAVING clause was added to SQL because the WHERE 
#keyword cannot be used with aggregate functions.

# SELECT column_name(s)
# FROM table_name
# WHERE condition
# GROUP BY column_...name(s)
# HAVING condition.....
# ORDER BY column_name(s);

-- get order frequency groups greater than 27
select * from orderdetails;

select productCode, count(*) as order_count 
from orderdetails 
group by productCode 
having order_count > 27;

select productCode, count(*) as orders 
from orderdetails 
group by productCode 
having orders > 27 
order by orders asc;

-- get orders by each each customer from 2004 gretaer than 1000000
select * from payments;

select customerNumber, sum(amount) from payments
where year(paymentDate) > '2003'
group by customerNumber 
having sum(amount) > 100000 
order by sum(amount) desc;

############### HOME FUN ##################
#What was the highest payment made?
#Which customer made the highest payment?
#Retrieve in the order of customers in Process?

select * from orders;

-- highest one time payment
select max(amount) from payments;

-- highest payment by customer over time
select customerNumber , max(amount)
from payments
group by customerNumber
order by max(amount) desc;

select distinct(status) from orders;
select * from orders where status = 'Disputed';

############# SQL JOIN ################
/* 
A JOIN clause is used to combine rows from two or more tables,
based on a related column between them.

Different Types of SQL JOINs
Here are the different types of the JOINs in SQL:

(INNER) JOIN: Returns records that have matching values in both tables
LEFT (OUTER) JOIN: Returns all records from the left table, and the matched records from the right table
RIGHT (OUTER) JOIN: Returns all records from the right table, and the matched records from the left table
FULL (OUTER) JOIN: Returns all records when there is a match in either left or right table
*/

use classicmodels;

select * from employees;
select * from offices;

select employees.employeeNumber, employees.lastname, employees.jobTitle, 
offices.officeCode, offices.city, offices.phone
from employees
join offices 
on employees.officeCode = offices.officeCode;

-- Join products and orderdetails tables
select * from products;
select * from orderdetails;

SELECT * FROM
products
INNER JOIN 
 orderdetails
 ON products.productCode = orderdetails.productCode;
 
/*
Using JOIN (Give same Result because the 
default join for SQL is Inner Join 
*/
SELECT * FROM
products
JOIN 
orderdetails
ON products.productCode = orderdetails.productCode;

## Using Table Alias with Join 
SELECT * FROM
products as p
JOIN 
orderdetails as o
ON p.productCode = o.productCode;


## Using Table Alias WITHOUT THE 'AS' Keyword
SELECT * FROM
products p_table
JOIN 
orderdetails ord_table
ON p_table.productCode = ord_table.productCode;

### JOINING TWO OR MORE TABLES TOGETHER
SELECT * FROM products;
select * from orderdetails;
select * from productlines;

SELECT * FROM
products as p_table
JOIN 
orderdetails as ord_table
ON p_table.productCode = ord_table.productCode
JOIN
productLines  as Line
ON Line.productLine = p_table.productLine;

##### ORDERING JOIN QUERRY #############
select * from customers;
select * from payments;
select * from orders;

SELECT customerName,paymentDate,shippedDate,amount 
FROM customers AS cust
 JOIN 
 payments AS pyt
 ON cust.customerNumber = pyt.customerNumber
 JOIN 
 orders AS ord
 ON ord.customerNumber = cust.customerNumber
 order by amount desc; 

## Using the WHERE clause with oins #########
SELECT customerName,contactFirstName,paymentDate,shippedDate,amount 
FROM
customers AS cust
 JOIN 
 payments AS pyt
 ON cust.customerNumber = pyt.customerNumber
 JOIN 
 orders AS ord
 ON ord.customerNumber = cust.customerNumber
 WHERE
 cust.contactFirstName = 'Rosa' 
 order by amount desc;
 
 ######## WHERE & AND CLAUSE with JOIN QUERY ##########
 select * from orders;
 select * from customers;
 select * from payments;
 
SELECT customerName,contactFirstName,paymentDate,shippedDate,amount 
FROM
customers AS cust
 JOIN 
 payments AS pyt
 ON cust.customerNumber = pyt.customerNumber
 JOIN 
 orders AS ord
 ON ord.customerNumber = cust.customerNumber
 WHERE
 cust.contactFirstName = 'Rosa'
 AND amount > 20000
 order by amount desc;
 
 ########## More on Joins ############
 select * from orders;
 select * from customers;
 select * from payments;
 select * from orderdetails;
 
 SELECT 
	customerName,contactFirstName,quantityOrdered, requiredDate,paymentDate
FROM 
	customers AS cust,
    orderdetails AS detail, 
    orders AS ord, 
    payments AS pyt   
WHERE
    cust.customerNumber = ord.customerNumber AND
    ord.orderNumber = detail.orderNumber AND
    pyt.customerNumber = cust.customerNumber
ORDER BY contactFirstName,quantityOrdered;   
 
######### USING COUNT WITH JOIN QUERRY ##########
SELECT count(*)
FROM 
	customers AS cust,
    orderdetails AS detail, 
    orders AS ord, 
    payments AS pyt   
WHERE
    cust.customerNumber = ord.customerNumber AND
    ord.orderNumber = detail.orderNumber AND
    pyt.customerNumber = cust.customerNumber AND
    cust.contactFirstName LIKE 'c%' AND
    ord.requiredDate = '2004-10-05' AND 
    pyt.paymentDate = '2004-10-19'
ORDER BY contactFirstName,quantityOrdered;

select customerNumber from orders;
select customerNumber from customers;

#### Customers who are yet to make any order ######
select * from customers 
where customerNumber not in (select customerNumber from orders);

select customerNumber from orders;

SELECT cust.customerNumber , ord.customerNumber
FROM customers as cust
  INNER JOIN orders as ord	 -- left join ie it exists on the customer table
  ON cust.customerNumber = ord.customerNumber;

######## CLASS FUN ################
select * from products;
#Extract customer First Name whose product have not be
#shipped ("in process"). Get the amount they paid and when they 
#required their goods to be delivered. We are also interested in
#the goods they ordered for.

select * from customers;
# Is there any relationship between customer who have a low 
#creditLimit (set the threshold yourself) and 
#frequency of their ordering,


