/*Name: Shawn Ogbomo
 Student# 022609127
 Date 01/30/2022
 Section DBS311NGG
 Instructor Riyadh Al-Essawi*/

-- Q1: Write a query to display the tomorrow�s date in the following format: 
--January 10th of year 2019
select to_char(sysdate + 1, 'Month DD "of year" YYYY') as Tomorrow
from dual;

-- Q2: For each product in category 2, 3, and 5, show product ID, product name, list price, and the new list price increased by 2%. 
--Display a new list price as a whole number.define New_price = (LIST_PRICE * 0.02) + LIST_PRICE;
SELECT PRODUCT_ID,
       PRODUCT_NAME,
       LIST_PRICE,
       ROUND((LIST_PRICE * 0.02) + (LIST_PRICE), 0)              AS "New Price",
       ROUND((LIST_PRICE * 0.02) + (LIST_PRICE), 0) - List_Price as "Price Difference"
FROM PRODUCTS
WHERE CATEGORY_ID = 2
   OR CATEGORY_ID = 3
   OR CATEGORY_ID = 5
ORDER BY CATEGORY_ID, PRODUCT_ID;

-- Q3: For employees whose manager ID is 2, write a query that displays the employee�s Full Name and Job Title in the following format:

--Summer, Payne is Public Accountant.

--Sort the result based on employee ID.

SELECT CONCAT(CONCAT(LAST_NAME, ', '), FIRST_NAME) || ' is ' || job_title as "Employee info"
FROM EMPLOYEES
WHERE MANAGER_ID = 2
ORDER BY EMPLOYEE_ID;

-- Q4: For each employee hired before October 2016, display the employee�s last name, hire date and calculate the number of YEARS between TODAY and the date the employee was hired.

-- Label the column Years worked.

-- Order your results by the number of years employed. Round the number of years employed up to the closest whole number.

SELECT LAST_NAME AS "Last Name", HIRE_DATE AS "Hire Date", ROUND((SYSDATE - HIRE_DATE) / 365) as "Years Worked"
FROM EMPLOYEES
WHERE HIRE_DATE < TO_DATE('2016/10', 'yy/mm')
ORDER BY HIRE_DATE, "Years Worked";

-- Q5: Display each employee�s last name, hire date, and the review date, which is the first Tuesday after a year of service, but only for those hired after January 1, 2016.
--Label the column REVIEW DAY.
--Format the dates to appear in the format like: TUESDAY, August the Thirty-First of year 2016
--You can use ddspth to have the above format for the day.
--Sort by review date

SELECT LAST_NAME,
       HIRE_DATE                                         AS "Hire Date",
       TO_CHAR(NEXT_DAY(LAST_DAY(ADD_MONTHS(HIRE_DATE, -1)), 'TUESDAY'),
               ' DAY,Month"the",ddspth" of year "YYYY ') AS "Review Date"
FROM EMPLOYEES
WHERE HIRE_DATE > TO_DATE('01/01/2016', 'mm/dd/yy')
ORDER BY "Review Date";

---- Q6: For all warehouses, display warehouse id, warehouse name, city, and state. For warehouses with the null value for the state column, display �unknown�. 
--Sort the result based on the warehouse ID.

SELECT w.warehouse_id, w.warehouse_name, l.city, NVL(l.state, 'Unknown')
FROM warehouses w
         LEFT OUTER JOIN locations l
                         ON w.location_id = l.location_id
ORDER BY w.warehouse_id;
  