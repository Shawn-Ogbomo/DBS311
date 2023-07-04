/*Name: Shawn Ogbomo
 Student# 022609127
 Date 03/21/2022
 Section DBS311NGG
 Instructor Riyadh Al-Essawi*/
SET SERVEROUTPUT ON;
--QUESTION 1
-- Write a store procedure that gets an integer number n and calculates and displays its factorial.
--Example:
--0! = 1 2! = fact(2) = 2 * 1 = 1 3! = fact(3) = 3 * 2 * 1 = 6 . . . n! = fact(n) = n * (n-1) * (n-2) * . . . * 1

CREATE OR REPLACE PROCEDURE calc_factorial(x NUMBER)
AS
    num_result NUMBER(9, 2) := 1;
    num_temp   NUMBER(9, 2) := x;
    num_temp_2 NUMBER(9, 2) := x;
BEGIN
    FOR num in 1..num_temp
        LOOP
            num_result := (num_result * (num_temp_2));
            num_temp_2 := num_temp_2 - 1;
        END LOOP;
    IF (num_temp = 0) THEN
        num_temp := 1;
        DBMS_OUTPUT.put_line(num_temp);
    ELSIF (num_temp < 0) THEN
        DBMS_OUTPUT.put_line('Factorial cannot be negetive...');
    ELSE
        DBMS_OUTPUT.put_line(num_result);
    END IF;
EXCEPTION
    WHEN OTHERS
        THEN
            DBMS_OUTPUT.put_line('Error');
END;


BEGIN
    calc_factorial(10);
    calc_factorial(0);
    calc_factorial(-1);
END;

--Question 2 
--The company wants to calculate the employees� annual salary:
--The first year of employment, the amount of salary is the base salary which is $10,000.
--Every year after that, the salary increases by 5%.
--Write a stored procedure named calculate_salary which gets an employee ID and for that employee calculates the salary based 
--on the number of years the employee has been working in the company.  
--(Use a loop construct to calculate the salary).
--The procedure calculates and prints the salary.
--Sample output:
--First Name: first_name 
--Last Name: last_name
--Salary: $9999,99
--If the employee does not exists, the procedure displays a proper message.

CREATE OR REPLACE PROCEDURE calculate_salary(emp_id_x NUMBER)
AS
    base_salary  NUMBER(9, 2) := 10000;
    current_year NUMBER(9, 2) := TO_NUMBER(TO_CHAR(sysdate, 'YYYY'));
    num_years    NUMBER(9, 2) := 0;
    yearly_raise NUMBER(9, 2) := 5;
    total_salary NUMBER(9, 2) := 0;
    found        NUMBER(9, 2) := 0;
    CURSOR year_cursor IS
        SELECT HIRE_DATE, FIRST_NAME, LAST_NAME, EMPLOYEE_ID
        FROM EMPLOYEES;
BEGIN
    FOR item in year_cursor
        LOOP
            num_years := current_year - TO_NUMBER(EXTRACT(YEAR FROM TO_DATE(item.HIRE_DATE, 'DD-MON-YY')));
            IF (num_years > 1 AND emp_id_x = item.EMPLOYEE_ID) THEN
                total_salary := (((num_years * yearly_raise) / 100) * base_salary) + base_salary;
                DBMS_OUTPUT.put_line('First Name: ' || item.First_NAME);
                DBMS_OUTPUT.put_line('Last Name: ' || item.LAST_NAME);
                DBMS_OUTPUT.put_line('Salary: ' || total_salary);
                found := 1;
            ELSIF (num_years = 1 AND emp_id_x = item.EMPLOYEE_ID) THEN
                DBMS_OUTPUT.put_line('First Name: ' || item.First_NAME);
                DBMS_OUTPUT.put_line('Last Name: ' || item.LAST_NAME);
                DBMS_OUTPUT.put_line('Salary: ' || base_salary);
                found := 1;
            END IF;
        END LOOP;
    IF (found = 0) THEN
        DBMS_OUTPUT.put_line('Employee id: ' || emp_id_x || ' not found...');
    END IF;
END;

BEGIN
    calculate_salary(107);
    calculate_salary(108);
END;

--Question 3
--Write a stored procedure named warehouses_report to print the warehouse ID, warehouse name, and the 
--city where the warehouse is located in the following format for all warehouses:
--Warehouse ID:
--Warehouse name:
--City:
--State:
--If the value of state does not exist (null), display �no state�.
--The value of warehouse ID ranges from 1 to 9.
--You can use a loop to find and display the information of each warehouse inside the loop.
--(Use a loop construct to answer this question. Do not use cursors.)

CREATE OR REPLACE PROCEDURE warehouses_report
AS
    warehouse_id_temp   warehouses.WAREHOUSE_id %TYPE;
    warehouse_name_temp warehouses.WAREHOUSE_NAME %TYPE;
    city_temp           locations.CITY %TYPE;
    state_temp          locations.STATE %TYPE;
    counter             NUMBER(9, 2) := 0;
BEGIN
    FOR wareohuse in 1..9
        LOOP
            counter := counter + 1;
            SELECT w.warehouse_id, w.warehouse_name, l.city, l.state
            into warehouse_id_temp, warehouse_name_temp,city_temp, state_temp
            from WAREHOUSES w
                     INNER JOIN LOCATIONS l
                                ON w.LOCATION_ID = l.location_id
            WHERE w.warehouse_id = counter;
            DBMS_OUTPUT.put_line('Wareohuse ID: ' || warehouse_id_temp);
            DBMS_OUTPUT.put_line('Wareohuse name: ' || warehouse_name_temp);
            DBMS_OUTPUT.put_line('City: ' || city_temp);
            IF (state_temp IS NOT NULL) THEN
                DBMS_OUTPUT.put_line('State: ' || state_temp);
            ELSE
                DBMS_OUTPUT.put_line('State: no state');
            END IF;
        END LOOP;
END;

BEGIN
    warehouses_report();
END;

