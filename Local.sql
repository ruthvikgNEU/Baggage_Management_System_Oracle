select * from flight;


select * from airport;
select * from terminal where airport_id = 3;

select location,terminal_id from airport a, terminal t where a.airport_id = t.airport_id;
select * from baggage;


select * from baggage where is_claimed = 'Y'; -- claimed baggages

update baggage set last_scan_time = cast(created_on+2 as timestamp) where baggage_id in (1,2,3,4,5);
select * from baggage where is_claimed = 'N' and reached_destination = 'Y' and round(trunc(systimestamp) - trunc(last_scan_time)) > 4; -- unclaimed baggages



update baggage set last_scan_time = cast(created_on+2 as timestamp) where baggage_id in (11,12,13,14,15,16,17);
select * from baggage where is_claimed = 'N' and reached_destination = 'N' and round(trunc(systimestamp) - trunc(last_scan_time)) > 4; -- lost baggages

--claimed baagges -- last_scan should be created_date plus 2 days and reached_dest - Y and claimed_Y
--Un-Clamied baggage -- last scan should be created date plus 4 days and reached_dest Y and claimed N

--Lost baggage  - last scan terminal should created date plus >4 days and both N
-- lost last week - lost baggaages where created date is in last week.
--weekly unclaimed baggages - unclaimed baggage where created date in last week

update baggage set created_on = (sysdate - 5) where baggage_id in(18,19,20);
update baggage set created_on = (sysdate - 3) where baggage_id in(21,22,23,24);
update baggage set last_scan_time = cast(created_on+2 as timestamp) where baggage_id in (18,19,20);
update baggage set last_scan_time = cast(created_on+2 as timestamp) where baggage_id in (21,22,23,24);
select * from baggage where is_claimed = 'N' and reached_destination = 'N' and round(trunc(systimestamp) - trunc(last_scan_time)) > 1 and created_on between sysdate and sysdate-7;



select sysdate - 4 from dual;