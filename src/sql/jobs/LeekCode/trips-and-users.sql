

# Write your MySQL query statement below
/*

Input
{"headers": {"Trips": ["Id", "Client_Id", "Driver_Id", "City_Id", "Status", "Request_at"], "Users": ["Users_Id", "Banned", "Role"]}, "rows": {"Trips": [["1", "1", "10", "1", "cancelled_by_client", "2013-10-04"]], "Users": [["1", "No", "client"], ["10", "No", "driver"]]}}
Output
{"headers": ["Day", "Cancellation Rate"], "values": [["2013-10-04", 1.00]]}
Expected
{"headers":["Day","Cancellation Rate"],"values":[]}


*/

select
DISTINCT a.Request_at as Day ,

ROUND( IFNULL (b.cancelled,0) /
      count(a.Id)
                ,2) as 'Cancellation Rate'
from Trips a
left outer join 


(
    select 
    DISTINCT Request_at,
     count(Id)

            as cancelled
    from
    Trips 
    
    inner join Users  p
    on 
    p.Users_Id = Client_Id  and p.Banned ='No'
    
    inner join Users  q
    on 
    q.Users_Id = Driver_Id   and q.Banned ='No'
    
    
    
   where Status in ('cancelled_by_driver','cancelled_by_client')
    group by Request_at  
   -- having Status in ('cancelled_by_driver','cancelled_by_client')
    order by  Request_at  asc
)  b
    
    on a.Request_at =b.Request_at
        
  
    inner join Users  p
    on 
    p.Users_Id = Client_Id  and p.Banned ='No'
    
    inner join Users  q
    on 
    q.Users_Id = Driver_Id   and q.Banned ='No'

    
       group by a.Request_at  
      order by  a.Request_at  asc



/*
----------- Different annswer

select
DISTINCT a.Request_at as Day ,

ROUND(b.cancelled/
     -- count(a.Id)
     --   count(case Banned when 'No' then 1 else null end)
     count(IF(Banned = 'No' , 1, NULL)) 
                ,2) as 'Cancellation Rate'
from Trips a
inner join 


(
    select 
    DISTINCT Request_at,
    -- count(Id)
   -- count(case Banned when 'No' then 1 else null end)
       count(IF(Banned = 'No' && Status in ('cancelled_by_driver','cancelled_by_client') , 1, NULL)) 
            as cancelled
    from
    Trips 
    
    left outer join Users 
    on 
    Users_Id = Client_Id --  and Banned ='No'
    
  --  where Status in ('cancelled_by_driver','cancelled_by_client')
    group by Request_at  
   -- having Status in ('cancelled_by_driver','cancelled_by_client')
    order by  Request_at  asc
)  b
    
    on a.Request_at =b.Request_at
        
    left outer join Users 
    on 
    Users_Id = Client_Id -- and Banned ='No'
    
    
       group by a.Request_at  
      order by  a.Request_at  asc
      
      
      */