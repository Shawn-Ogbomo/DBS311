/*Name: Shawn Ogbomo
 Student# 022609127
 Date 02/11/2022
 Section DBS311NGG
 Instructor Riyadh Al-Essawi*/

--Question 1 
/*Write a SQL query to display the last name and hire date of all employees who were hired before the employee with ID 107 got hired but after March 2016. 
Sort the result by the hire date and then employee ID.*/
SELECT LAST_NAME, HIRE_DATE
FROM EMPLOYEES
WHERE HIRE_DATE < (SELECT HIRE_DATE
                   FROM EMPLOYEES
                   WHERE EMPLOYEE_ID = 107)
  AND hire_date > TO_DATE('30 March 2016', 'DD MONTH YY')
ORDER BY HIRE_DATE, EMPLOYEE_ID;

--Question 2
--Write a SQL query to display customer name and credit limit for customers with lowest credit limit. Sort the result by customer ID.

SELECT NAME, MIN(CREDIT_LIMIT)
FROM CUSTOMERS
GROUP BY NAME, customer_id, credit_limit
HAVING CREDIT_LIMIT = (SELECT MIN(CREDIT_LIMIT)
                       FROM CUSTOMERS)
ORDER BY CUSTOMER_ID;

-- Question 3
--Write a SQL query to display the product ID, product name, and list price of the highest paid product(s) in each category. Sort by category ID and the product ID.
SELECT category_id, product_id, product_name, MAX(LIST_PRICE)
FROM PRODUCTS
GROUP BY CATEGORY_ID, product_id, product_name, LIST_PRICE
HAVING LIST_PRICE IN (SELECT MAX(LIST_PRICE)
                      FROM PRODUCTS
                      GROUP BY category_id)
ORDER BY CATEGORY_ID, PRODUCT_ID;


-- Question 4 
--Write a SQL query to display the category ID and the category name of the most expensive (highest list price) product(s).
SELECT P.category_id, CATEGORY_NAME
FROM PRODUCTS P
         LEFT JOIN product_categories PR
                   ON p.category_id = pr.category_id
group by P.category_id, CATEGORY_NAME, LIST_PRICE
HAVING LIST_PRICE = (SELECT MAX(LIST_PRICE)
                     FROM PRODUCTS);

-- Question 5
/*Write a SQL query to display product name and list price for products in category 1 which have the list price less than the lowest list price in ANY category. 
Sort the output by top list prices first and then by the product ID*/
SELECT PRODUCT_NAME, LIST_PRICE
FROM PRODUCTS
WHERE LIST_PRICE < ANY (SELECT MIN(LIST_PRICE)
                        FROM PRODUCTS
                        GROUP BY category_id)
  AND category_id = 1
ORDER BY list_price DESC, product_id;

-- Question 6
--Display the maximum price (list price) of the category(s) that has the lowest price product.
SELECT MAX(LIST_PRICE)
FROM PRODUCTS
GROUP BY category_id
HAVING category_id = (SELECT CATEGORY_ID
                      FROM PRODUCTS
                      WHERE LIST_PRICE = (SELECT MIN(LIST_PRICE)
                                          FROM PRODUCTS));