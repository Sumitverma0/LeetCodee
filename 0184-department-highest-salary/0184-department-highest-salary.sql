select d.name as "Department", ee.name as "Employee",ee.salary as "Salary" from Employee ee join 
(select e.departmentId, max(e.salary) salary from Employee e group by e.departmentId) t on (ee.
departmentID = t.departmentId and ee.salary = t.salary) join Department d ON (ee.departmentID = d.
id);
{"headers":{"Employee":["id","name","salary","departmentId"],"Department":["id","name"]},"rows":{"Employee":[[1,"Joe",70000,1],[2,"Jim",90000,1],[3,"Henry",80000,2],[4,"Sam",60000,2],[5,"Max",90000,1]],"Department":[[1,"IT"],[2,"Sales"]]}}
| Department | Employee | Salary |
| ---------- | -------- | ------ |
| IT         | Max      | 90000  |
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
| Department | Employee | Salary |
| ---------- | -------- | ------ |
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
| IT         | Max      | 90000  |