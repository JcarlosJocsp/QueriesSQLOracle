

/*Utilizando funções hierárquicas*/
SELECT LEVEL,
       UPPER(LPAD(' ',2 * LEVEL - 1) || FIRST_NAME || ' ' || LAST_NAME)         AS NOME,
       ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE ))                               AS MESES,
       SALARY + (SALARY * NVL(COMMISSION_PCT, 0))                               AS SAL_COMM,
       TO_CHAR(HIRE_DATE, 'DD/MON/YYYY, HH24:MI:SS')                            AS DATA_HORA,
       CASE WHEN SALARY + (SALARY * NVL(COMMISSION_PCT, 0)) <= 3000 THEN 'Um Salario Ruim'
            WHEN SALARY + (SALARY * NVL(COMMISSION_PCT, 0)) BETWEEN 3001 AND 6000 THEN 'Um Salario Regular'
            WHEN SALARY + (SALARY * NVL(COMMISSION_PCT, 0)) BETWEEN 6001 AND 11000 THEN 'Um Salario Bom'
            WHEN SALARY + (SALARY * NVL(COMMISSION_PCT, 0)) >= 11001 THEN 'Um Salario Ótimo'   
            ELSE NULL                                                
            END                                                                 AS CONTA,
            DEPARTMENT_ID                                                       AS DEPARTAMENTO
FROM   HR.EMPLOYEES
WHERE  (DEPARTMENT_ID, SALARY) IN (SELECT DEPARTMENT_ID, MAX(SALARY)
                                   FROM   HR.EMPLOYEES
                                   GROUP BY DEPARTMENT_ID)            
START WITH EMPLOYEE_ID = (SELECT EMPLOYEE_ID
                          FROM   HR.EMPLOYEES
                          WHERE  EMPLOYEE_ID = 100)
                          CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID
                          ORDER BY DEPARTMENT_ID;
