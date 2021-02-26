--TASK 6--
-- Please find out if some customer was referred by already existing customer
-- Return results in following format "Customer Last name Customer First name" "Last name First name of customer who recomended the new customer"

--The assignment is a little bit confused...

 SELECT 
 
 --* 
  cu.last_name|| ' '|| cu.first_name   as "Customer Last name Customer First name"
 ,cu1.last_name|| ' '|| cu1.first_name as "Last name First name of customer who recomended the new customer"
 
 FROM customers cu 
 
 join customers cu1 on cu1.referred_by_id = cu.customer_id
 
 order by
 
 cu.customer_id
 
 ;
  
  
  
  
  
  
  