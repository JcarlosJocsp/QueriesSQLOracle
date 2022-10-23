

/*Sub Query na clausula JOIN sendo usado como VIEW */
SELECT E.FIRST_NAME      AS NOME,
       E.SALARY          AS SALARIO,
       E.DEPARTMENT_ID   AS "DEPT COD",
       D.DEPARTMENT_NAME AS "DEPT NOME",
       B.SAL_AVG,
       S.SOMA
  FROM EMPLOYEES E INNER JOIN DEPARTMENTS D
ON(E.DEPARTMENT_ID = D.DEPARTMENT_ID)
  INNER JOIN
     (SELECT ROUND(AVG(SALARY)) AS SAL_AVG,
               DEPARTMENT_ID
          FROM EMPLOYEES
      GROUP BY DEPARTMENT_ID) B
ON(E.DEPARTMENT_ID = B.DEPARTMENT_ID)
AND E.SALARY > B.SAL_AVG
  INNER JOIN 
     (SELECT SUM(SALARY) AS SOMA,
             DEPARTMENT_ID
        FROM EMPLOYEES
        GROUP BY DEPARTMENT_ID) S
ON(E.DEPARTMENT_ID = S.DEPARTMENT_ID);




/*Utilizando a Clausula WITH*/
WITH 
  TAB_DADOS AS (SELECT E.FIRST_NAME, E.SALARY, DEPARTMENT_ID,
                       D.DEPARTMENT_NAME
                  FROM EMPLOYEES E JOIN DEPARTMENTS D 
                   USING (DEPARTMENT_ID)),
  TAB_MAX_DEPT AS (SELECT SALARY, DEPARTMENT_ID
                     FROM TAB_DADOS 
                     WHERE (SALARY,DEPARTMENT_ID) IN (SELECT MAX(SALARY),DEPARTMENT_ID
                                                        FROM TAB_DADOS 
                                                        GROUP BY DEPARTMENT_ID)),
  TAB_AVG_MAX_DEPT AS (SELECT AVG(SALARY) AS AVG_SAL
                         FROM TAB_MAX_DEPT)
    SELECT * 
      FROM TAB_DADOS 
     WHERE SALARY > (SELECT AVG_SAL
                       FROM TAB_AVG_MAX_DEPT)
    ORDER BY SALARY




/*Utilizando CASE e algumas funçoes de linhas*/
SELECT E.EMPLOYEE_ID                  AS COD_EMP,
       E.FIRST_NAME||' '||LAST_NAME   AS NOME,
       NVL(TO_CHAR(E.COMMISSION_PCT), 'SEM COMISSAO') AS COMISSAO,
       TO_CHAR(E.SALARY,'L999999D99') AS SALARIO,
       ROUND(MONTHS_BETWEEN(SYSDATE,E.HIRE_DATE) / 12) AS "ANOS TRAB",
       DEPARTMENT_ID                  AS "DEPT COD",
       D.DEPARTMENT_NAME              AS "NOME DEPT",
  CASE WHEN SALARY BETWEEN 2000 AND 3000  THEN 'TEM UM SALARIO RUIM'
       WHEN SALARY BETWEEN 3001 AND 4500  THEN 'TEM UM SALARIO REGULAR'
       WHEN SALARY BETWEEN 4501 AND 6000  THEN 'TEM UM SALARIO BOM'
       WHEN SALARY BETWEEN 6001 AND 10000 THEN 'TEM UM SALARIO OTIMO'
       WHEN SALARY > 10001 THEN 'TEM UM SALARIO EXELENTE'
  ELSE TO_CHAR(SALARY)
   END AS "NIVEL SALARIO" 
  FROM EMPLOYEES E INNER JOIN DEPARTMENTS D
   USING(DEPARTMENT_ID)
  WHERE TO_CHAR(HIRE_DATE ,'YYYY') BETWEEN 2003 AND 2008
    AND ROUND(MONTHS_BETWEEN(SYSDATE,E.HIRE_DATE) / 12) NOT IN (11,12)
    AND UPPER(SUBSTR(FIRST_NAME,1,1)) IN ('S','T','A','J','N')
ORDER BY SALARY;







/*Funcionarios que foram contratados no ultimo trimestre*/

WITH 
  TAB_DADOS AS (SELECT FIRST_NAME||' '||LAST_NAME    AS NOME,
                       TO_CHAR(SALARY,'L999999D99')  AS SALARIO,
                       HIRE_DATE                     AS DATACON,            
                       DEPARTMENT_ID                 AS DEPARTAMENTO         
                  FROM EMPLOYEES),
  TAB_ThreeMOAGO AS (SELECT MAX(ADD_MONTHS(DATACON,-3)) AS ThreeMOAGO
                     FROM TAB_DADOS)
        SELECT NOME,
               SALARIO,
               DATACON,
               DEPARTAMENTO
          FROM TAB_DADOS
         WHERE DATACON >= (SELECT ThreeMOAGO
                            FROM TAB_ThreeMOAGO)
                        ORDER BY DATACON;
