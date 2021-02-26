--TASK 1--
--Write query which will match contacts and orders to our customers

--select * from contacts;
--select * from orders;
select 

cu.*
,co.address
,co.city
,co.phone_number
,co.email
,o.order_id
,o.item
,o.order_value
,o.order_currency
,order_date


from customers cu

left join contacts co 	on co.customer_id = cu.customer_id

left join orders o 		on o.customer_id = cu.customer_id
;
