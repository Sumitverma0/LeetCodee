select t.customer_id from (select customer_id,count(distinct product_key) countt from Customer group 
by customer_id) t where t.countt = (select count(product_key) from Product);
{"headers":{"Customer":["customer_id","product_key"],"Product":["product_key"]},"rows":{"Customer":[[1,5],[2,6],[3,5],[3,6],[1,6]],"Product":[[5],[6]]}}
| customer_id |
| ----------- |
| 1           |
| 3           |
| customer_id |
| ----------- |
| 1           |
| 3           |