select max(SecondHighestSalary) as SecondHighestSalary from (select salary as SecondHighestSalary,
DENSE_RANK() over (order by salary desc) as rnk from Employee order by salary desc) where rnk = 2;
{"headers":{"Employee":["id","salary"]},"rows":{"Employee":[[1,100],[2,200],[3,300]]}}
{"headers":{"Employee":["id","salary"]},"rows":{"Employee":[[1,100]]}}
| secondhighestsalary |
| ------------------- |
| 200                 |
| secondhighestsalary |
| ------------------- |
| null                |
| SecondHighestSalary |
| ------------------- |
| 200                 |
| SecondHighestSalary |
| ------------------- |
| null                |