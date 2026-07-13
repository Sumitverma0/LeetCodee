-- Write your PostgreSQL query statement below
select s.score,DENSE_RANK() over (order by s.score desc) as rank from Scores s ;
{"headers":{"Scores":["id","score"]},"rows":{"Scores":[[1,3.5],[2,3.65],[3,4],[4,3.85],[5,4],[6,3.65]]}}
| score | rank |
| ----- | ---- |
| 4     | 1    |
| 4     | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.5   | 4    |
| score | rank |
| ----- | ---- |
| 4     | 1    |
| 4     | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.5   | 4    |