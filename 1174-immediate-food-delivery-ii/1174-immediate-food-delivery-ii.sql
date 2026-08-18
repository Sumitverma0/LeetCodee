-- select count(customer_id) from (select customer_id,min(order_date) first,
customer_pref_delivery_date dilv from Delivery group by customer_id ) t where t.first=t.dilv ;
SELECT ROUND( 100.0 * SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) /
COUNT(*),2) AS immediate_percentage FROM Delivery WHERE (customer_id, order_date) IN (SELECT 

customer_id, MIN(order_date) FROM Delivery GROUP BY customer_id);
{"headers":{"Delivery":["delivery_id","customer_id","order_date","customer_pref_delivery_date"]},"rows":{"Delivery":[[1,1,"2019-08-01","2019-08-02"],[2,2,"2019-08-02","2019-08-02"],[3,1,"2019-08-11","2019-08-12"],[4,3,"2019-08-24","2019-08-24"],[5,3,"2019-08-21","2019-08-22"],[6,2,"2019-08-11","2019-08-13"],[7,4,"2019-08-09","2019-08-09"]]}}
| immediate_percentage |
| -------------------- |
| 50                   |
| immediate_percentage |
| -------------------- |
| 50                   |