alter session set current_schema=application_admin;
set serveroutput on;


select * from baggage_history;

exec get_baggage_history(12);