--TASK 4--
--Our company distinguishes orders to sizes by value like so:
--order with value less or equal to 25 euro is marked as SMALL
--order with value more than 25 euro but less or equal to 100 euro is marked as MEDIUM
--order with value more than 100 euro is marked as BIG
--Write query which shows only three columns: full_name (first and last name divided by space), order_id and order_size
--Make sure the duplicated values are not shown

-- first way 

  SELECT 
        --  o.*,
          DISTINCT
           cu.first_name || ' ' || cu.last_name as full_name
          ,o.order_id
          ,case when o.order_value > 100 then 'BIG'
               when o.order_value > 25   then 'MEDIUM'
               ELSE
               'SMALL'
               END AS order_size
          --,rank() over(partition by o.order_id order by o.ROWID) as r_rnk

          from orders o

          LEFT JOIN customers cu on cu.customer_id = o.customer_id

          where 1=1
          
          ;


-- second way 
  with 
  sub_01 as (

            SELECT 

          --  o.*,
             cu.first_name || ' ' || cu.last_name as full_name
            ,o.order_id
            ,case when o.order_value > 100 then 'BIG'
                 when o.order_value > 25   then 'MEDIUM'
                 ELSE
                 'SMALL'
                 END AS order_size
            ,rank() over(partition by o.order_id order by o.ROWID) as r_rnk

            from orders o

            LEFT JOIN customers cu on cu.customer_id = o.customer_id

            where 1=1

                    )


                    select 
                     w.full_name
                    ,w.order_id
                    ,w.order_size
                    from
                    sub_01 w

                    where 1=1
                          and r_rnk = 1

                          ;
    