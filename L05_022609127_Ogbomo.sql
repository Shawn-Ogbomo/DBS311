/*Name: Shawn Ogbomo
 Student# 022609127
 Date 03/21/2022
 Section DBS311NGG
 Instructor Riyadh Al-Essawi*/
SET SERVEROUTPUT ON;
--1. Write a store procedure that get an integer number and prints
--The number is even.
--If a number is divisible by 2.
--Otherwise, it prints
--The number is odd.
CREATE OR REPLACE PROCEDURE validate_num(x IN NUMBER) AS
BEGIN
    IF MOD(X, 2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('The number is even');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The number is odd');
    END IF;
END;
BEGIN
    validate_num(5);
END;
--2. Create a stored procedure named find_employee. This procedure gets an employee number and prints the following employee information:
--First name
--Last name
--Email
--Phone
--Hire date
--Job title
--The procedure gets a value as the employee ID of type NUMBER.
CREATE OR REPLACE PROCEDURE find_employee(employee_num NUMBER) AS
    first_name     VARCHAR2(255 BYTE);
    last_name      VARCHAR2(255 BYTE);
    email_address  VARCHAR2(255 BYTE);
    phone_number   VARCHAR2(255 BYTE);
    hire_date      DATE;
    job_title      VARCHAR2(255 BYTE);
    employee_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO employee_count
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = employee_num;
    IF (employee_count = 1) THEN
        SELECT FIRST_NAME,
               LAST_NAME,
               EMAIL,
               PHONE,
               HIRE_DATE,
               JOB_TITLE
        INTO first_name,
            last_name,
            email_address,
            phone_number,
            hire_date,
            job_title
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID = employee_num;
        DBMS_OUTPUT.PUT_LINE('First name: ' || first_name);
        DBMS_OUTPUT.PUT_LINE('Last name: ' || last_name);
        DBMS_OUTPUT.PUT_LINE('Email: ' || email_address);
        DBMS_OUTPUT.PUT_LINE('PHONE: ' || phone_number);
        DBMS_OUTPUT.PUT_LINE('Hire date: ' || hire_date);
        DBMS_OUTPUT.PUT_LINE('Job title: ' || job_title);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Employee number not found...');
    END IF;
END;
BEGIN
    find_employee(107);
END;
--3. Every year, the company increases the price of all products in one category. 
--For example, the company wants to increase the price (list_price) of products in category 1 by $5. 
--Write a procedure named update_price_by_cat to update the price of all products in a given category and the given amount to be added to the current price 
--if the price is greater than 0. 
--The procedure shows the number of updated rows if the update is successful.
--The procedure gets two parameters:
CREATE OR REPLACE PROCEDURE update_price_by_cat(
    category_id_ NUMBER, amount NUMBER
) AS
    category_id_temp_max products.CATEGORY_ID % TYPE;
    Rows_updated         NUMBER;
BEGIN
    SELECT MAX(CATEGORY_ID)
    INTO category_id_temp_max
    FROM PRODUCTS;
    IF (
                category_id_ > 0
            AND category_id_ <= category_id_temp_max
        ) THEN
        UPDATE
            PRODUCTS
        SET LIST_PRICE = LIST_PRICE + amount
        WHERE CATEGORY_ID = category_id_;
        Rows_updated := sql % rowcount;
        DBMS_OUTPUT.PUT_LINE(Rows_updated);
    ELSE
        DBMS_OUTPUT.PUT_LINE(
                'Caregory_id must be greater than 0 and less than or equal to 5'
            );
    END IF;
END;
BEGIN
    update_price_by_cat(0, 25.00);
END;
SELECT MAX(CATEGORY_ID)
FROM PRODUCTS;
--question 4 
--Every year, the company increase the price of products whose price is less than the average price of all products by 1%. 
--(list_price * 1.01). Write a stored procedure named update_price_under_avg. 
--This procedure do not have any parameters. 
--You need to find the average price of all products and store it into a variable of the same type. 
--If the average price is less than or equal to $1000, update products� price by 2% if the price of the product is less than the calculated average. 
--If the average price is greater than $1000, update products� price by 1% if the price of the product is less than the calculated average.
--The query displays an error message if any error occurs. Otherwise, it displays the number of updated rows.
CREATE OR REPLACE PROCEDURE update_price_under_avg AS
    average_price products.LIST_PRICE % TYPE := 0;
BEGIN
    SELECT AVG(LIST_PRICE)
    INTO average_price
    FROM PRODUCTS;
    IF (average_price <= 1000) THEN
        UPDATE
            PRODUCTS
        SET LIST_PRICE = (LIST_PRICE * 0.02)
        WHERE LIST_PRICE < average_price;
    ELSE
        IF (average_price > 1000) THEN
            UPDATE
                PRODUCTS
            SET LIST_PRICE = (LIST_PRICE * 0.01)
            WHERE LIST_PRICE < average_price;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error...');
        END IF;
    END IF;
END;
BEGIN
    update_price_under_avg();
END;
--QUESTION 5... 
--The company needs a report that shows three category of products based their prices. 
--The company needs to know if the product price is cheap, fair, or expensive.
CREATE OR REPLACE PROCEDURE product_price_report AS
    list_price_min NUMBER;
    list_price_max NUMBER;
    list_price_avg products.LIST_PRICE % TYPE;
    cheap_count    NUMBER(9, 2) := 0;
    fair_count     NUMBER(9, 2) := 0;
    exp_count      NUMBER(9, 2) := 0;
    CURSOR list_price_cursor IS
        SELECT LIST_PRICE
        FROM PRODUCTS;
    total_columns  NUMBER(9, 2) := 0;
BEGIN
    SELECT MIN(LIST_PRICE),
           MAX(LIST_PRICE),
           AVG(LIST_PRICE),
           COUNT(*)
    INTO list_price_min,
        list_price_max,
        list_price_avg,
        total_columns
    FROM PRODUCTS;
    FOR item IN list_price_cursor
        LOOP
            IF (
                item.list_price < list_price_avg - list_price_min
                ) THEN
                cheap_count := cheap_count + 1;
            ELSIF (
                item.list_price > (list_price_max - list_price_avg) / 2
                ) THEN
                exp_count := exp_count + 1;
            ELSIF (
                item.list_price >= (list_price_avg - list_price_min) / 2
                ) THEN
                fair_count := fair_count + 1;
            END IF;
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('Cheap: ' || cheap_count);
    DBMS_OUTPUT.PUT_LINE('Fair: ' || fair_count);
    DBMS_OUTPUT.PUT_LINE('Expensive: ' || exp_count);
END;
BEGIN
    product_price_report();
END;
