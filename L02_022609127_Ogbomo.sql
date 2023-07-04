/*Name: Shawn Ogbomo
 Student# 022609127
 Date 02/4/2022
 Section DBS311NGG
 Instructor Riyadh Al-Essawi*/

--QUESTION 1 
--For each job title display the number of employees. Sort the result according to the number of employees.
--Solution
SELECT job_title,
       COUNT(*) AS employees
FROM employees
GROUP BY job_title
ORDER BY EMPLOYEES;

--Question 2 
--Display the highest, lowest, and average customer credit limits. Name these results high, low, and average. 
--Add a column that shows the difference between the highest and the lowest credit limits named �High and Low Difference�. 
--Round the average to 2 decimal places.
--Solution
SELECT MAX(credit_limit)           AS high,
       MIN(credit_limit)           AS low,
       round(AVG(credit_limit), 2) AS average,
       (
           MAX(credit_limit) - MIN(credit_limit)
           )
                                   AS "high low difference"
FROM customers;

--QUESTION 3 
--Display the order id, the total number of products, and the total order amount for orders with the total amount over $1,000,000. 
--Sort the result based on total amount from the high to low values.
--Solution
SELECT ORDER_ID,
       SUM(quantity)              AS "TOTAL_ITEMS",
       SUM(UNIT_PRICE * QUANTITY) AS "TOTAL_AMOUNT"
FROM ORDER_ITEMS
GROUP BY order_id
HAVING SUM(UNIT_PRICE * QUANTITY) > 1000000
ORDER BY "TOTAL_AMOUNT" DESC;

--QUESTION 4  
--Display the warehouse id, warehouse name, and the total number of products for each warehouse. 
--Sort the result according to the warehouse ID.
SELECT w.WAREHOUSE_ID,
       w.WAREHOUSE_NAME,
       SUM(i.QUANTITY) AS "TOTAL_PRODUCTS"
FROM WAREHOUSES w
         LEFT OUTER JOIN
     INVENTORIES i
     ON w.warehouse_id = i.warehouse_id
GROUP BY w.warehouse_id,
         w.warehouse_name
ORDER BY w.warehouse_id;

--QUESTION 5
/*For each customer display customer number, customer full name, and the total number of orders issued by the customer.
� If the customer does not have any orders, the result shows 0.
� Display only customers whose customer name starts with �O� and contains �e�.
� Include also customers whose customer name ends with �t�.
� Show the customers with highest number of orders first.*/

SELECT C.CUSTOMER_ID,
       C.NAME               AS "customer name",
       COUNT(O.CUSTOMER_ID) AS "total number OF orders"
FROM CUSTOMERS C
         LEFT OUTER JOIN
     ORDERS O
     ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY c.customer_id,
         C.NAME
HAVING (C.NAME LIKE 'O%'
    AND C.NAME LIKE '%e%')
    or (
    C.NAME LIKE '%t'
    )
order by "total number OF orders" desc;
QUESTION 6
--SELECT pr.CATEGORY_ID, sum(p.standard_cost * p.list_price)  as TOTAL_AMOUNT,AVG(sum(p.standard_cost * p.list_price)/ count(p.category_id))
--FROM product_categories pr
--RIGHT OUTER JOIN PRODUCTS p
--ON pr.category_id = p.category_id
--GROUP BY pr.category_id
--ORDER BY "TOTAL_AMOUNT" DESC;

SELECT DISTINCT CATEGORY_ID,
                SUM(standard_cost * list_price)           AS TOTAL_AMOUNT,
                ROUND(AVG(standard_cost * list_price), 2) AS "AVERAGE_AMOUNT"
FROM PRODUCTS
GROUP BY category_id
ORDER BY "TOTAL_AMOUNT" DESC;