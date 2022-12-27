use ipl;
select * from IPL_BIDDER_DETAILS;
select * from IPL_BIDDER_POINTS;
select * from IPL_BIDDING_DETAILS;
select * from IPL_MATCH;
select * from IPL_MATCH_SCHEDULE;
select * from IPL_PLAYER;
select * from IPL_STADIUM;
select * from   IPL_TEAM;
select	 * from IPL_TEAM_PLAYERS;
select * from IPL_TEAM_STANDINGS;
select * from IPL_TOURNAMENT;
select * from IPL_USER;



-- 1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.

select * from IPL_BIDDER_DETAILS;
select * from IPL_BIDDING_DETAILS;




-- percentage of wins of each bidder / total no of bidding of each bidder
with t1 as
(select bidder_id, count(*) as ct from ipl_bidding_details where bid_status = 'Won' group by bidder_id),
 t2 as (select bidder_id, count(*) as ct from ipl_bidding_details group by bidder_id)

select tb1.bidder_id, tb1.bidder_name, ifnull(tb2.percentage,0)*100 as percentages from ipl_bidder_details as tb1 left join
(select t1.bidder_id, round(t1.ct / t2.ct,2) as percentage 
from t1, t2 
where t1.bidder_id = t2.bidder_id) as tb2
on tb1.bidder_id = tb2.bidder_id
order by tb2.percentage desc;




select * from IPL_BIDDER_DETAILS;
select * from IPL_BIDDING_DETAILS;
select * from IPL_BIDDER_POINTS;


SELECT A.BIDDER_ID,A.BIDDER_NAME,
(SELECT COUNT(BIDDER_ID) FROM IPL_BIDDING_DETAILS B 
WHERE B.BID_STATUS='WON' AND A.BIDDER_ID = B.BIDDER_ID)
/
(SELECT NO_OF_BIDS FROM IPL_BIDDER_POINTS C
WHERE A.BIDDER_ID = C.BIDDER_ID)
* 100 AS 'WIN_PERCENTAGE'
FROM IPL_BIDDER_DETAILS A
ORDER BY WIN_PERCENTAGE DESC;








/* 2.	Display the number of matches conducted at each stadium with stadium name, city 
	from the database.*/
    
    
    /*  From//
	Tables used :-
select * from IPL_STADIUM;
select * from IPL_MATCH_SCHEDULE;

Step_1:
I have joined tables IPL_STADIUM and IPL_MATCH_SCHEDULE using inner join 
based On columns stadium_id  from both the tables

Step_2:
I grouped the values based on stadium_name 


Step_3:
columns selected from both the tables are
stadium _name and city from table ipl_stadium and
 aggregated count of each  stadium_id as number_of _matches_conducted from table ipl_match_schedule.


 */
 
select * from IPL_STADIUM;
select * from IPL_MATCH_SCHEDULE;


select a.stadium_name, a.city ,count(b.STADIUM_ID) as number_of_matches_conducted
from ipl_stadium a  join ipl_match_schedule b
on a.stadium_id= b.stadium_id
group by stadium_name;










-- 3.	In a given stadium, what is the percentage of wins by a team which has won the toss?

select * from IPL_STADIUM;
 select * from IPL_MATCH;
 select * from IPL_TEAM;
select * from ipl_team_standings;

 

 
/*
 -- Tables used 
			- IPL_STADIUM
            - IPL_MATCH_SCHEDULE
            - IPL_MATCH
            - IPL_TEAM
            - IPL_TEAM_STANDINGS
 
 */

 
 
 SELECT A.STADIUM_ID,A.STADIUM_NAME,CITY,
(SELECT COUNT(*) 
FROM IPL_MATCH B 
JOIN IPL_MATCH_SCHEDULE C
ON B.MATCH_ID = C.MATCH_ID
WHERE B.TOSS_WINNER = B.MATCH_WINNER
AND C.STADIUM_ID=A.STADIUM_ID)
/
(SELECT COUNT(*) 
FROM IPL_MATCH_SCHEDULE C
WHERE C.STADIUM_ID = A.STADIUM_ID)
* 100 AS 'WIN_%'
FROM IPL_STADIUM A;
 
 
 
 
 
 
 
 
 
 
 -- 4.	Show the total bids along with bid team and team name.
 
 /* 
 From//
    Tables used :-
 select * from IPL_BIDDING_DETAILS; 
 select * from IPL_TEAM;

Step_1:
I have joined tables IPL_BIDDING_DETAILS  and IPL_TEAM tables using inner join
based On columns bid_team from both the tables

Step_2:
I grouped the values based on column bid_team

Step_3:
columns selected from both the tables are bid_team and 
aggregate count of each  bid_team as total bids from table IPL_BIDDING_DETAILS 
and 
team_ name from table IPL_TEAM


Step_4:
I have sorted the total_bids column in dessending  order



*/
 
 
 select * from IPL_BIDDING_DETAILS; 
 select * from IPL_TEAM;
 
 select count(a.bid_team)total_bids,(a.bid_team),b.team_name 
 from IPL_BIDDING_DETAILS a inner join IPL_TEAM b
 on a.bid_team = b.team_id
 group by a.bid_team
 order by total_bids desc;
 
 

 
 
 
 
 
 
 -- 5.	Show the team id who won the match as per the win details.
 
 /* From//
  Tables used :-
 select * from IPL_MATCH;
 select * from IPL_TEAM;

Step_1:
I have joined tables IPL_MATCH and IPL_TEAM tables using inner join
 based On columns team_id from table IPL_MATCH 
 and column  match_winner from table IPL_TEAM


Step_2:
columns selected from both the tables are
Match_id and team_id  from table IPL_MATCH 
and
Team_name as match winner from table IPL_TEAM.



 */


select (case when MATCH_WINNER = 1 then TEAM_ID1
	when match_winner = 2  then TEAM_ID2
    else match_winner end) as team_id, count(*) as 'won'
from IPL_MATCH
group by if(MATCH_WINNER = 1, TEAM_ID1, TEAM_ID2)
order by if(MATCH_WINNER = 1, TEAM_ID1, TEAM_ID2);

select * from IPL_MATCH;
 select * from IPL_TEAM;

-- another approach
select team_name, team_id1, team_id2, toss_winner, match_winner, win_details
from ipl_match inner join ipl_team on trim(left(substr(win_details,6), position(' ' in substr(win_details,6)))) = ipl_team.remarks
and win_details like '%35%';
 
 -- substr(win_details,6) as st, position(' ' in substr(win_details,6)) as pt, trim(left(substr(win_details,6), position(' ' in substr(win_details,6)))) as word
 
 -- another approach
 select *,(ipl_match.match_winner = 1, team_id1, team_id2) as team_id  from ipl_match inner join ipl_team
 on ipl_team.team_id = ipl_match.match_winner;
 -- -----------------------------------------------------------------------------------
 
 -- Show the team id who won the match as per the win details.
 

select * from ipl_team;
select * from ipl_match;
 
 
 select team_id, team_name, match_winner, win_details
 from IPL_TEAM a inner join IPL_MATCH b
 on a.team_id = if(b.match_winner=1, team_id1, team_id2);
 
 
 -- Show the team id who won the match as per the win details and team has won by 35runs
 
 
 select team_id, team_name, match_winner, win_details
 from IPL_TEAM a inner join IPL_MATCH b
 on a.team_id = if(b.match_winner=1, team_id1, team_id2) and win_details like '%35%';
 
 
 
 -- IPL_match details of team who has won by 35runs
 
 select * from ipl_match where win_details like '%35%';
 
 
 
 
 
 /* 6.	Display total matches played, total matches won and 
    total matches lost by team along with its team name.*/
    
    /* 
    From//
Tables used :-
select * from IPL_TEAM:
select * from IPL_TEAM_STANDINGS;

Step_1:
I have joined tables IPL_TEAM and IPL_TEAM_STANDINGS  using inner join 
based On columns team_id from both the tables

Step_2:
I grouped the values based on column team_id

Step_3:
columns selected from both the tables are
Team_id and team_name from table IPL_TEAM and
Matches_played,matches_won and matches_lost from table IPL_TEAM_STANDINGS.

 */
    
select * from IPL_TEAM_STANDINGS;
select * from IPL_TEAM;

select a.team_id,a.team_name ,b.MATCHES_PLAYED,b.MATCHES_WON,b.MATCHES_LOST
from IPL_TEAM a inner join IPL_TEAM_STANDINGS b
on a.team_id= b.team_id
group by team_id;













 -- 7.	Display the bowlers for Mumbai Indians team.
 
 
 /* 
 From//
Tables used :-
select * from IPL_TEAM_PLAYERS; 
select * from IPL_PLAYER;
select * from IPL_TEAM; 


Step_1:
I have joined tables IPL_TEAM_PLAYERS and IPL_PLAYER using inner join 
based On columns player_id from both the tables
and 
joind tables IPL_PLAYER and IPL_TEAM_PLAYERS using inner join 
based On columns team_id from both the tables

Step_2:
I have filtered the values based on player_role and team_name 


Step_3:
columns selected from the three tables are
 team_name from table IPL_TEAM   and 
Player_role from table IPL_TEAM_PLAYERS and 
Player_id and player_name from table IPL_PLAYER 

 */
 
 select * from IPL_TEAM_PLAYERS;
 select * from IPL_TEAM;
 select * from IPL_PLAYER;

 
 select c.team_name, a.player_role,b.player_id,b.player_name
 from IPL_TEAM_PLAYERS a join IPL_PLAYER b 
 on a.player_id = b.player_id
 join ipl_team c 
 on c.team_id = a.team_id
 where player_role = 'Bowler' and team_name = 'Mumbai Indians' ;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
/*  8.	How many all-rounders are there in each team, 
     Display the teams with more than 4 all-rounder in descending order.*/
     
     
     /* 
     From//

Tables used :-
select * from IPL_TEAM_PLAYERS;      
select * from IPL_TEAM; 


Step_1:
I have joined tables IPL_TEAM_PLAYERS and IPL_TEAM tables using inner join
 based On columns team_id from both the tables

Step_2:
I have filtered the values based on player_role 

Step_3:
I grouped the values based on column team_name

Step_3:
filtering aggregate count of each player_role as (no of allrounders)  
of team having  more than four all rounders 
 
Step_4:
columns selected from both the tables are 
team_id and aggregate count of each  player_role as (no of allrounders) from table IPL_TEAM_PLAYERS  
and 
Team_name from table IPL_TEAM


Step_5:
I have sorted the aggregated count for each  player_role column in dessending order


     */
     
select * from IPL_TEAM_PLAYERS;
select * from IPL_TEAM;
 

 select a.team_id,count(a.player_role)no_of_all_rounders,b.team_name
 from IPL_TEAM_PLAYERS a join IPL_team b 
 on a.team_id = b.team_id
 where player_role like 'all-rounder' 
 group by team_name
 having  count(a.player_role)  > 4
  order by count(a.player_role) desc;		
  
 
 
