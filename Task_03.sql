--TASK 3-	
-- As you found out, there are some duplicated order which are incorrect, adjust query from previous task so it does following:
-- Show first name, last name, email, order id and item
-- Does not show duplicates.
-- Order result by customer last name

WITH
sub_01 as (
            SELECT 
             o.*
            ,rank() over(partition by o.order_id order by rowid) as r_rnk


            FROM orders o
  
  		 )
         
   select 
    cu.first_name
   ,cu.last_name
   ,con.email
   ,q.order_id
   ,q.item
   
   from sub_01 q
   
   left join customers cu 	on cu.customer_id = q.customer_id
   
   --    join contacts  con 	on con.customer_id = cu.customer_id
   left join contacts  con 	on con.customer_id = cu.customer_id
   
   where 1=1
   and q.r_rnk >1
   
   order by 2
   ;