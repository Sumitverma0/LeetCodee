CREATE OR REPLACE FUNCTION NthHighestSalary(N INT) RETURNS TABLE (Salary INT) AS $$
BEGIN
  RETURN QUERY (
    -- Write your PostgreSQL query statement below.
      
  );
END;
    select distinct(t.salary) from (select e.salary,DENSE_RANK() over (order by e.salary desc) as 
    rnk from Employee e) t where rnk=N
$$ LANGUAGE plpgsql;
{"headers":{"Employee":["id","salary"]},"rows":{"Employee":[[1,100],[2,200],[3,300]]},"argument":2}
{"headers":{"Employee":["id","salary"]},"rows":{"Employee":[[1,100]]},"argument":2}
| getNthHighestSalary(2) |
| ---------------------- |
| 200                    |
| getNthHighestSalary(2) |
| ---------------------- |
| null                   |
| getNthHighestSalary(2) |
| ---------------------- |
| 200                    |
| getNthHighestSalary(2) |
| ---------------------- |
| null                   |