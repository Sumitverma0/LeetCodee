select distinct(l3.num) as ConsecutiveNums from Logs l3 join ( select l1.id,l1.num from Logs l1 join 
Logs l2 on (l1.id=l2.id+1) where l1.num = l2.num) t on (l3.id=t.id+1) where l3.num = t.num;
{"headers":{"Logs":["id","num"]},"rows":{"Logs":[[1,1],[2,1],[3,1],[4,2],[5,1],[6,2],[7,2]]}}
| consecutivenums |
| --------------- |
| 1               |
| ConsecutiveNums |
| --------------- |
| 1               |