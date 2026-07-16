select round(count(distinct(second_day))*1.0/count(distinct(tt.player_id)),2) "fraction" from 
Activity tt left join ( select b.player_id second_day from Activity b join (select a.player_id , min
(a.event_date) from Activity a group by (a.player_id)) t on (b.player_id = t.player_id ) and b.
event_date = t.min+1) ss on (tt.player_id=ss.second_day) ;
[object Object]
[object Object]
{"headers":{"Activity":["player_id","device_id","event_date","games_played"]},"rows":{"Activity":[[1,2,"2016-03-01",5],[1,2,"2016-03-02",6],[2,3,"2017-06-25",1],[3,1,"2016-03-02",0],[3,4,"2018-07-03",5]]}}
{"headers":{"Activity":["player_id","device_id","event_date","games_played"]},"rows":{"Activity":[[1,8,"1970-01-01",0],[2,9,"1970-01-01",0]]}}
| fraction |
| -------- |
| 0.33     |
| fraction |
| -------- |
| 0        |
| fraction |
| -------- |
| 0.33     |
| fraction |
| -------- |
| 0        |