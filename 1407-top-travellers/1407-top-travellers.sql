select u.name name , coalesce(sum(r.distance),0) travelled_distance from Users u left join Rides r on
(u.id=r.user_id)  group by u.name,u.id order by travelled_distance desc , name asc;
{"headers":{"Users":["id","name"],"Rides":["id","user_id","distance"]},"rows":{"Users":[[1,"Alice"],[2,"Bob"],[3,"Alex"],[4,"Donald"],[7,"Lee"],[13,"Jonathan"],[19,"Elvis"]],"Rides":[[1,1,120],[2,2,317],[3,3,222],[4,7,100],[5,13,312],[6,19,50],[7,7,120],[8,19,400],[9,7,230]]}}
| name     | travelled_distance |
| -------- | ------------------ |
| Elvis    | 450                |
| Lee      | 450                |
| Bob      | 317                |
| Jonathan | 312                |
| Alex     | 222                |
| Alice    | 120                |
| Donald   | 0                  |
| name     | travelled_distance |
| -------- | ------------------ |
| Elvis    | 450                |
| Lee      | 450                |
| Bob      | 317                |
| Jonathan | 312                |
| Alex     | 222                |
| Alice    | 120                |
| Donald   | 0                  |