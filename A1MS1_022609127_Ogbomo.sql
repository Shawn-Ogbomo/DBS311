--QUESTION 1
--1. Display the employee number, full employee name, job title, 
--and hire date of all employees hired in September with the most recently hired employees displayed first.

SELECT EMPLOYEE_ID, first_name || ' ' || LAST_NAME AS FULL_NAME, JOB_TITLE, HIRE_DATE
FROM EMPLOYEES
WHERE HIRE_DATE > TO_DATE('31-AUG-16', 'DD-MON-RR')
  AND HIRE_DATE < TO_DATE('01-OCT-16', 'DD-MON-RR')
ORDER BY HIRE_DATE ASC;

--QUESTION 2
--The company wants to see the total sale amount per sales person (salesman) for all orders. 
--Assume that online orders do not have any sales representative. 
--For online orders (orders with no salesman ID), consider the salesman ID as 0. 
--Display the salesman ID and the total sale amount for each employee
--Sort the result according to employee number

SELECT O.SALESMAN_ID, SUM(QUANTITY * UNIT_PRICE)
FROM ORDERS O
         INNER JOIN ORDER_ITEMS OI
                    ON O.ORDER_ID = OI.ORDER_ID
WHERE SALESMAN_ID > 0
GROUP BY O.salesman_id
ORDER BY o.salesman_id ASC;

--Question 3
--Display customer Id, customer name and total number of orders for customers that the value of their customer ID is in values from 35 to 45. 
--Include the customers with no orders in your report if their customer ID falls in the range 35 and 45.
--Sort the result by the value of total orders.
SELECT C.CUSTOMER_ID, C.NAME, COUNT(O.CUSTOMER_ID) AS TOTAL_ORDERS
FROM CUSTOMERS C
         LEFT JOIN ORDERS O
                   ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE C.CUSTOMER_ID >= 35
  AND C.CUSTOMER_ID < 46
GROUP BY O.CUSTOMER_ID, C.NAME, C.CUSTOMER_ID
ORDER BY "TOTAL_ORDERS";

--QUESTION 4                        --check this...
--Display customer ID, customer name, and the order ID and the order date of all orders for customer whose ID is 44.
--a. Show also the total quantity and the total amount of each customer�s order.
--b. Sort the result from the highest to lowest total order amount.

SELECT C.CUSTOMER_ID, C.NAME, O.ORDER_ID, O.ORDER_DATE, SUM(OI.QUANTITY), SUM(oi.quantity * OI.UNIT_PRICE)
FROM CUSTOMERS C
         RIGHT JOIN ORDERS O
                    ON C.CUSTOMER_ID = o.customer_id
         INNER JOIN ORDER_ITEMS OI
                    ON O.ORDER_ID = OI.ORDER_ID
WHERE C.CUSTOMER_ID = 44
GROUP BY O.CUSTOMER_ID, C.NAME, C.CUSTOMER_ID, O.ORDER_DATE, O.ORDER_ID
order by SUM(oi.quantity * OI.UNIT_PRICE) DESC;

-- Question 5               --check this...
--Display customer Id, name, total number of orders, the total number of items ordered, and the total order amount for customers who have more than 30 orders. 
--Sort the result based on the total number of orders.
SELECT C.CUSTOMER_ID, C.NAME, COUNT(O.CUSTOMER_ID), SUM(QUANTITY), SUM(quantity * UNIT_PRICE)
FROM CUSTOMERS C
         RIGHT JOIN ORDERS O
                    ON C.CUSTOMER_ID = O.CUSTOMER_ID
         INNER JOIN ORDER_ITEMS OI
                    ON O.ORDER_ID = OI.ORDER_ID
GROUP BY C.CUSTOMER_ID, C.NAME, O.CUSTOMER_ID
HAVING COUNT(O.CUSTOMER_ID) > 30
order by COUNT(O.CUSTOMER_ID) ASC;

--QUESTION 6                                            --check this...
--Display Warehouse Id, warehouse name, product category Id, product category name, and the lowest product standard cost for this combination.
SELECT W.WAREHOUSE_ID, W.WAREHOUSE_NAME, PR.CATEGORY_ID, PR.CATEGORY_NAME, MIN(P.STANDARD_COST)
FROM warehouses W
         INNER JOIN INVENTORIES I
                    ON W.WAREHOUSE_ID = I.WAREHOUSE_ID
         INNER JOIN PRODUCTS P
                    ON I.PRODUCT_ID = P.PRODUCT_ID
         INNER JOIN PRODUCT_CATEGORIES PR
                    ON PR.CATEGORY_ID = P.CATEGORY_ID
group by W.WAREHOUSE_ID, W.WAREHOUSE_NAME, PR.CATEGORY_ID, PR.CATEGORY_NAME;


--QUESTION 7 -- why use sub-queries here???
--Display the total number of orders per month. Sort the result from January to December.
SELECT DISTINCT extract(month From order_date) AS "MONTH", COUNT(extract(month From order_date)) AS "ORDERS_PER_MONTH"
FROM ORDERS
GROUP BY extract(month From order_date)
ORDER BY "MONTH" ASC;
--GROUP BY extract(month From order_date)

--Question 8
--Display product Id, product name for products that their list price is more than any highest product standard cost per warehouse outside Americas regions.
--(You need to find the highest standard cost for each warehouse that is located outside the Americas regions. 
--Then you need to return all products that their list price is higher than any highest standard cost of those warehouses.)
--Sort the result according to list price from highest value to the lowest.

SELECT PRODUCT_ID, PRODUCT_NAME
FROM PRODUCTS
WHERE LIST_PRICE > ANY (SELECT MAX(P.STANDARD_COST) -- Return group of standard costs per warehouse
                        FROM PRODUCTS P
                                 INNER JOIN INVENTORIES I
                                            ON P.PRODUCT_ID = I.product_id
                                 INNER JOIN WAREHOUSES W
                            --LEFT JOIN LOCATIONS
                            --ON L.LOCATION_ID = W.LOCATION_ID
                                            ON W.WAREHOUSE_ID = I.WAREHOUSE_ID
                        WHERE W.WAREHOUSE_ID IN (SELECT WAREHOUSE_ID
                                                 FROM WAREHOUSES
                                                 WHERE WAREHOUSE_ID > 5)
                        GROUP BY i.warehouse_id)
ORDER BY LIST_PRICE DESC;
-- exclude americas
--QUESTION 9
--Write a SQL statement to display the most expensive and the cheapest product (list price). Display product ID, product name, and the list price


SELECT department_name
FROM departments d
         INNER JOIN employees e ON (d.employee_id = e.employee_id)
GROUP BY department_name;