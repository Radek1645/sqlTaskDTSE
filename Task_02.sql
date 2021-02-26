
--TASK 2--
-- There is  suspision that some orders were wrongly inserted more times. Check if there are any duplicated orders. If so, return duplicates with the following details:
-- first name, last name, email, order id and item


    select 
    cu.first_name
   ,cu.last_name
   ,con.email
   ,q.order_id
   ,q.item
   
   from orders q
   
   left join customers cu 	on cu.customer_id = q.customer_id
   
   --    join contacts  con 	on con.customer_id = cu.customer_id
   left join contacts  con 	on con.customer_id = cu.customer_id

	
    WHERE 1=1
    and q.order_id in (

                      SELECT 
                      o.order_id
                    -- ,count(o.order_id) as order_id_cnt

                     FROM orders o

                     GROUP by 
                     o.order_id

                     HAVING  count(o.order_id)>1
                      ) 
     ;

    

         
