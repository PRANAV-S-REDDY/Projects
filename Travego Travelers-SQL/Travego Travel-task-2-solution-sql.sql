use travego;

-- Perform read operation on the designed table created in the above task using SQL script. 
select * from passenger;

select * from price;


-- 2)a.	How many females and how many male passengers traveled a minimum distance of 600 KMs?

select count(Gender)count_of_gender, Gender, Distance from passenger 
where distance >= 600
group by gender;


-- 2)b.	Find the minimum ticket price of a Sleeper Bus. 

select bus_type,min(price)minimum_ticket_price from price 
where Bus_type like 'sleeper';


-- 2)c.	Select passenger names whose names start with character 'S' 

select * from passenger 
where Passenger_name like 'S%';


/*  2)d.	Calculate price charged for each passenger displaying Passenger name,
            Boarding City, Destination City, Bus_Type, Price in the output            */
        
select a.passenger_id,a.Passenger_name,a.Boarding_City, a.Destination_City, a.Bus_Type, b.Price 
from passenger a left join price b
on a.distance = b.distance and a.bus_type = b.bus_type;


 /* 2)e.	What are the passenger names and the ticket price 
            for those who traveled 1000 KMs Sitting in a bus?      */
            
select a.Passenger_id,a.passenger_name ,a.distance, b.price , a.Bus_Type    
from passenger a join price b 
on a.distance=b.distance
group by a.Passenger_id
having a.distance = 1000 and Bus_Type = 'sitting';


/* 2)f.	What will be the Sitting and Sleeper bus charge 
	    for Pallavi to travel from Bangalore to Panaji?   */
        
 select b.bus_type, a.boarding_city, a.Destination_City,b.distance,b.price
 from passenger a join price b
 on a.distance = b.distance
 where a.Boarding_City = 'panaji' and  a.Destination_City = 'bengaluru';
 
 
 
/* 2)g.	List the distances from the "Passenger" table which are unique (non-repeated distances) 
	    in descending order */
        
select distinct  distance from passenger
order by Distance desc ;   




 /* 2)h. Display the passenger name and percentage of distance traveled
          by that passenger from the total distance traveled 
          by all passengers without using user variables */
 

 select Passenger_id,passenger_name ,
sum(distance)distance_traveled,
(select sum(distance) from passenger)'total distance traveled by all passengers',
 (sum(Distance)*100)/(select sum(distance) from passenger) as 'percentage of distance traveled'
 from
 passenger
 group by Passenger_name;


-- Rounding of decimals 

 select Passenger_id,passenger_name , 
 sum(distance)distance_traveled,
 (select sum(distance) from passenger)'total distance traveled by all passengers',
 round((sum(Distance))/(select sum(distance) from passenger)*100)  as 'percentage of distance traveled'
 from passenger
 group by Passenger_name;



