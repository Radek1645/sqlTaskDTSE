 --TASK 5--
-- Show all items from orders table which containt in their name 'ea' or start with 'Key'

-- first way 
  select 
  --DISTINCT
   o.item
  --,o.*
  from orders o
  
  where 1=1
  --and (lower(o.item) like '%ea%' or o.item like 'Key%')
  and (        o.item like '%ea%' or o.item like 'Key%')
  ;
  
  
 -- second way 
 
  select 
--DISTINCT 
  o.item
  --,o.*
  from orders o
  
  where 1=1
  --and (lower(o.item) like '%ea%' or o.item like 'Key%')
  and  o.item like '%ea%'
  
  UNION
  
  select 
  --DISTINCT 
  o.item
  --,o.*
  from orders o
  
  where 1=1
  --and (lower(o.item) like '%ea%' or o.item like 'Key%')
  and  o.item like 'Key%';