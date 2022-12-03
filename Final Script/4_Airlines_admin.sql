alter session set current_schema=application_admin;
set serveroutput on;

exec add_flight('QATAR AIRWAYS',80,78);
exec add_flight('KLM ROYAL DUTCH AIRLINES',78,70);
exec add_flight('AMERICAN AIRLINES',70,57);
exec add_flight('BRITISH AIRWAYS',57,51);
exec add_flight('UNITED AIRLINES',57,46);
exec add_flight('Qatar Airways',43,81);
exec add_flight('Qatar airways',81,51);
exec add_flight('British Airways',51,18);
exec add_flight('American Airlines',35,9);
exec add_flight('Southwest Airlines',9,5);
exec add_flight('Emirates',5,20);
exec add_route(2,3,4);
exec add_route(6,7,8);
exec add_route(9,10,11);