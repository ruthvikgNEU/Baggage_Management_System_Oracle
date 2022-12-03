set serveroutput on;

--Drop Tables if exists
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE COMPLAINT_STATUS';
    EXECUTE IMMEDIATE 'DROP TABLE BAGGAGE_DATA';
    EXECUTE IMMEDIATE 'DROP TABLE BAGGAGE_STATUS_TYPE';
    EXECUTE IMMEDIATE 'DROP TABLE COMPLAINT';
    EXECUTE IMMEDIATE 'DROP TABLE BAGGAGE';
    EXECUTE IMMEDIATE 'DROP TABLE TICKET';
    EXECUTE IMMEDIATE 'DROP TABLE PASSENGER';  
    EXECUTE IMMEDIATE 'DROP TABLE ROUTE';
    EXECUTE IMMEDIATE 'DROP TABLE FLIGHT';
    EXECUTE IMMEDIATE 'DROP TABLE TERMINAL';
    EXECUTE IMMEDIATE 'DROP TABLE AIRPORT';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/



--Drop Sequences if exists
BEGIN
        EXECUTE IMMEDIATE 'DROP SEQUENCE baggage_STATUS_id_auto';
        EXECUTE IMMEDIATE 'DROP SEQUENCE baggage_history_id_auto';
        EXECUTE IMMEDIATE 'DROP SEQUENCE  AIRPORT_ID_AUTO' ;
        EXECUTE IMMEDIATE 'DROP SEQUENCE  TERMINAL_ID_AUTO' ;
        EXECUTE IMMEDIATE 'DROP SEQUENCE  booking_code_auto' ;
        EXECUTE IMMEDIATE 'DROP SEQUENCE  PASSENEGER_ID_AUTO' ;
        EXECUTE IMMEDIATE 'DROP SEQUENCE  route_code_auto' ;
        EXECUTE IMMEDIATE 'DROP SEQUENCE  FLIGHT_NUMBER_AUTO' ;
        EXECUTE IMMEDIATE 'DROP SEQUENCE  BAGGAGE_ID_AUTO' ;
        EXECUTE IMMEDIATE 'DROP SEQUENCE COMPLAINT_ID_AUTO';        
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -2289 THEN
      RAISE;
    END IF;
END;
/


--Create Sequences
CREATE SEQUENCE AIRPORT_ID_AUTO START WITH 1;
create sequence booking_code_auto start with 1;
CREATE SEQUENCE TERMINAL_ID_AUTO START WITH 1;
CREATE SEQUENCE PASSENEGER_ID_AUTO START WITH 1;
create sequence route_code_auto start with 1;
CREATE SEQUENCE FLIGHT_NUMBER_AUTO START WITH 1;
CREATE SEQUENCE BAGGAGE_ID_AUTO START WITH 1;
CREATE SEQUENCE COMPLAINT_ID_AUTO START WITH 1;
create sequence baggage_history_id_auto start with 1;
create sequence baggage_STATUS_id_auto start with 1;



--Create Tables
CREATE TABLE AIRPORT(
AIRPORT_ID NUMBER(6) DEFAULT AIRPORT_ID_AUTO.nextval NOT NULL,
NAME VARCHAR2(30) UNIQUE NOT NULL,
LOCATION VARCHAR2(30) UNIQUE NOT NULL,
PRIMARY KEY(AIRPORT_ID)
);



CREATE TABLE TERMINAL(
TERMINAL_ID NUMBER(6) DEFAULT TERMINAL_ID_AUTO.nextval NOT NULL,
AIRPORT_ID NUMBER(6) NOT NULL,
TERMINAl_NAME VARCHAR2(20),
CONSTRAINT AIRPORT_ID_REF FOREIGN KEY (AIRPORT_ID) REFERENCES AIRPORT(AIRPORT_ID) on delete cascade,
primary key(terminal_id)
);



CREATE TABLE PASSENGER(
PASSENGER_ID NUMBER(16) DEFAULT PASSENEGER_ID_AUTO.NEXTVAL NOT NULL,
FIRST_NAME VARCHAR2(15) NOT NULL,
LAST_NAME VARCHAR2(15)NOT NULL,
PASSPORT VARCHAR2(6)NOT NULL,
MOBILE VARCHAR2(10) NOT NULL,
ADDRESS_LINE_1 VARCHAR2(30) NOT NULL,
ADDRESS_LINE_2 VARCHAR(30),
CITY VARCHAR2(20)NOT NULL,
STATE VARCHAR2(15) NOT NULL,
COUNTRY VARCHAR2(20)NOT NULL,
ZIPCODE NUMBER(6) NOT NULL,
PRIMARY KEY(PASSENGER_ID)
);



CREATE TABLE FLIGHT(
FLIGHT_NUMBER NUMBER(6) DEFAULT FLIGHT_NUMBER_AUTO.NEXTVAL NOT NULL,
AIRLINES VARCHAR2(50) NOT NULL,
DATE_OF_DEPARTURE DATE NOT NULL,
SOURCE_TERMINAL_ID NUMBER(8) NOT NULL,
DESTINATION_TERMINAL_ID NUMBER(8) NOT NULL,
PRIMARY KEY(FLIGHT_NUMBER),
CONSTRAINT SOURCE_TERMINAL_FK FOREIGN KEY(SOURCE_TERMINAL_ID) REFERENCES TERMINAL(TERMINAL_ID) on delete cascade,
CONSTRAINT DESTINATION_TERMINAL_FK FOREIGN KEY(DESTINATION_TERMINAL_ID) REFERENCES TERMINAL(TERMINAL_ID) on delete cascade
);



CREATE TABLE ROUTE(
ROUTE_CODE NUMBER(10) DEFAULT ROUTE_CODE_AUTO.NEXTVAL NOT NULL,
FIRST_FLIGHT_NUMBER NUMBER(10) NOT NULL,
SECOND_FLIGHT_NUMBER NUMBER(10) NOT NULL,
THIRD_FLIGHT_NUMBER NUMBER(10) NOT NULL,
PRIMARY KEY(ROUTE_CODE),
CONSTRAINT FIRST_FLIGHT_NUMBER_FK FOREIGN KEY (FIRST_FLIGHT_NUMBER) REFERENCES FLIGHT(FLIGHT_NUMBER) on delete cascade,
CONSTRAINT SECOND_FLIGHT_NUMBER_FK FOREIGN KEY (SECOND_FLIGHT_NUMBER) REFERENCES FLIGHT(FLIGHT_NUMBER) on delete cascade,
CONSTRAINT THIRD_FLIGHT_NUMBER_FK FOREIGN KEY (THIRD_FLIGHT_NUMBER) REFERENCES FLIGHT(FLIGHT_NUMBER) on delete cascade
);



CREATE TABLE TICKET(
BOOKING_CODE NUMBER(10) DEFAULT BOOKING_CODE_AUTO.NEXTVAL NOT NULL,
ROUTE_CODE NUMBER(10) NOT NULL,
PASSENGER_ID NUMBER(16) NOT NULL,
PRICE NUMBER(10) NOT NULL,
NO_BAGS NUMBER(2) NOT NULL,
PRIMARY KEY(BOOKING_CODE),
CONSTRAINT ROUTE_CODE_FK FOREIGN KEY (ROUTE_CODE) REFERENCES ROUTE(ROUTE_CODE) on delete cascade,
CONSTRAINT PASSENGER_ID_FK FOREIGN KEY (PASSENGER_ID) REFERENCES PASSENGER(PASSENGER_ID) on delete cascade
);



CREATE TABLE BAGGAGE(
BAGGAGE_ID NUMBER(10) DEFAULT BAGGAGE_ID_AUTO.NEXTVAL NOT NULL,
LAST_SCAN_TERMINAL_ID NUMBER(6) NOT NULL,
BOOKING_CODE NUMBER(10) NOT NULL,
IS_CLAIMED VARCHAR2(1) DEFAULT 'N' NOT NULL,
LAST_SCAN_TIME TIMESTAMP NOT NULL,
ROUTE_CODE NUMBER(10) NOT NULL,
REACHED_DESTINATION VARCHAR2(1) DEFAULT 'N' NOT NULL,
created_on date default current_date,
PRIMARY KEY(BAGGAGE_ID),
CONSTRAINT LAST_SCAN_TERMINAL_ID_FK FOREIGN KEY (LAST_SCAN_TERMINAL_ID) REFERENCES TERMINAL(TERMINAL_ID) on delete cascade,
CONSTRAINT BAGGAGE_BOOKING_CODE_FK FOREIGN KEY (BOOKING_CODE) REFERENCES TICKET(BOOKING_CODE) on delete cascade,
CONSTRAINT BAGGAGE_ROUTE_CODE_FK FOREIGN KEY (ROUTE_CODE) REFERENCES ROUTE(ROUTE_CODE) on delete cascade
);



CREATE TABLE COMPLAINT(
COMPLAINT_ID NUMBER(10) DEFAULT COMPLAINT_ID_AUTO.NEXTVAL NOT NULL,
BAGGAGE_ID NUMBER(10) NOT NULL,
STATUS VARCHAR2(6) DEFAULT 'ACTIVE' NOT NULL,
PRIMARY KEY(COMPLAINT_ID),
CONSTRAINT COMP_BAGGAGE_ID_FK FOREIGN KEY (BAGGAGE_ID) REFERENCES BAGGAGE(BAGGAGE_ID) on delete cascade
);



CREATE TABLE BAGGAGE_STATUS_TYPE(
STATUS_ID NUMBER(10) DEFAULT baggage_STATUS_id_auto.NEXTVAL NOT NULL,
STATUS VARCHAR2(20) NOT NULL,
PRIMARY KEY(STATUS_ID)
);



create table BAGGAGE_DATA(
baggage_history_id number(20) default baggage_history_id_auto.nextval not null,
baggage_id number(10) not null,
current_status NUMBER(10) not null,
last_scan_terminal number(6) not null,
at_time timestamp not null,
primary key(baggage_history_id),
constraint baggage_id_fk foreign key (baggage_id) references baggage(baggage_id) on delete cascade,
constraint BAGGAGE_DATA_last_scan_terminal_fk foreign key (last_scan_terminal) references terminal(terminal_id) on delete cascade,
CONSTRAINT BAGGAGE_STATUS_FK FOREIGN KEY (current_status) references BAGGAGE_STATUS_TYPE(STATUS_ID) on delete cascade
);

create table complaint_status(
complaint_status_id number(20) not null,
status varchar2(10) not null,
primary key(complaint_status_id)
);



--Procedure for adding Airport
create or replace procedure add_airport (
in_name varchar,
in_location varchar) AS
v_count number;
e_unique_name exception;
BEGIN
select count(*) into v_count from airport where name=in_name;
if(v_count=0) then
insert into airport values(airport_id_auto.nextval,in_name,in_location);
DBMS_OUTPUT.PUT_LINE('Airport Added');
else
raise e_unique_name;
end if;
commit;
exception
when e_unique_name then DBMS_OUTPUT.PUT_LINE('The airport already exists');
when others then raise;
commit;
END add_airport;
/


--Trigger to automatically generate terminal for each Airport
CREATE OR REPLACE TRIGGER INSERT_TERMINALS
AFTER INSERT ON AIRPORT
DECLARE
i NUMBER;
BEGIN
SELECT MAX(AIRPORT_ID) INTO i FROM AIRPORT;
INSERT INTO TERMINAL VALUES(TERMINAL_ID_AUTO.nextval,i,'Terminal-A in ');
INSERT INTO TERMINAL VALUES(TERMINAL_ID_AUTO.nextval,i,'Terminal-B in ');
INSERT INTO TERMINAL VALUES(TERMINAL_ID_AUTO.nextval,i,'Terminal-C in ');
INSERT INTO TERMINAL VALUES(TERMINAL_ID_AUTO.nextval,i,'Terminal-D in ');
INSERT INTO TERMINAL VALUES(TERMINAL_ID_AUTO.nextval,i,'Terminal-E in ');
INSERT INTO TERMINAL VALUES(TERMINAL_ID_AUTO.nextval,i,'Terminal-F in ');
    DBMS_OUTPUT.PUT_LINE('Terminals created for Airport '|| i);
END;
/



--Procedure for adding Flights
create or replace procedure add_flight(airlines varchar,
source_terminal number,
dest_terminal number)
as
begin
insert into flight values(flight_number_auto.nextval,airlines,sysdate,source_terminal,dest_terminal);
    DBMS_OUTPUT.PUT_LINE('Flight Added');
commit;
end add_flight;
/




--Procedure for adding new Ticket
create or replace procedure add_ticket(route_code number,
passenger_id number,
price number,
no_of_bags number)
as
begin
INSERT INTO TICKET VALUES(booking_code_auto.NEXTVAL,route_code,passenger_id,price,no_of_bags);
    DBMS_OUTPUT.PUT_LINE('Ticket Added');
commit;
end add_ticket;
/


--Trigger to create baggages data automatically when ticket is created.
CREATE OR REPLACE TRIGGER INSERT_BAGGAGES
AFTER INSERT ON TICKET
DECLARE
i NUMBER;
j NUMBER;
k NUMBER;
a NUMBER;
x NUMBER;
b number;
rand number;
BEGIN
SELECT MAX(BOOKING_CODE) into b FROM TICKET;
SELECT NO_BAGS INTO k FROM TICKET WHERE BOOKING_CODE = b;
SELECT ROUTE_CODE INTO i  FROM  TICKET WHERE BOOKING_CODE = (SELECT MAX(BOOKING_CODE) FROM TICKET);
SELECT FIRST_FLIGHT_NUMBER INTO j FROM ROUTE WHERE ROUTE_CODE = i;
SELECT SOURCE_TERMINAL_ID INTO x FROM FLIGHT WHERE FLIGHT_NUMBER = j;
SELECT DBMS_RANDOM.value(2,13) INTO rand from dual;
FOR a IN 1..K LOOP
INSERT INTO BAGGAGE VALUES(BAGGAGE_ID_AUTO.NEXTVAL,X,b,'N',systimestamp,i,'N',sysdate-rand);
END LOOP;
    DBMS_OUTPUT.PUT_LINE('Baggages created for Passenger '|| b);
END;
/



--Trigger to update price in ticket based on number of baggages.
CREATE OR REPLACE TRIGGER UPDATE_TICKET_PRICE
AFTER INSERT ON TICKET
DECLARE
i NUMBER;
j NUMBER;
BEGIN
SELECT NO_BAGS INTO i FROM TICKET WHERE BOOKING_CODE = (SELECT MAX(BOOKING_CODE) FROM TICKET);
SELECT MAX(BOOKING_CODE) INTO j FROM TICKET;
UPDATE TICKET SET PRICE = PRICE  + (100*i) WHERE BOOKING_CODE = j AND i >=3;
DBMS_OUTPUT.PUT_LINE(i || ' bags created for Ticket ' || j);
END;
/




--Procedure for adding new Route
create or replace procedure add_route(first number,
second number,
third number)
as
begin
INSERT INTO ROUTE VALUES (ROUTE_CODE_AUTO.NEXTVAL,first,second,third);
    DBMS_OUTPUT.PUT_LINE('Route Added');
commit;
end add_route;
/

--Procedure for adding new Complaint
create or replace procedure add_complaint(bag_id number,
status number)
as
begin
INSERT INTO complaint VALUES (complaint_id_auto.NEXTVAL,bag_id,status);
    DBMS_OUTPUT.PUT_LINE('Complaint Added');
commit;
end add_complaint;
/



--Procedure for adding Baggage_data.
create or replace procedure add_baggage_data(baggageid number,currentstatus number, lastscan number)
as
v_cdate date;
begin
select created_on into v_cdate from baggage where baggage_id = baggageid;
insert into baggage_data values(baggage_history_id_auto.nextval,baggageid,currentstatus,lastscan,cast(v_cdate+2 as timestamp));
commit;
end add_baggage_data;
/




--Trigger to update last_scan_terminal_id in Baggage.
CREATE OR REPLACE TRIGGER UPDATE_LAST_SCAN_TERMINAL_IN_BAGGAGE
AFTER INSERT ON BAGGAGE_DATA
DECLARE
i NUMBER;
j NUMBER;
k NUMBER;
BEGIN
SELECT MAX(BAGGAGE_HISTORY_ID) INTO k FROM BAGGAGE_DATA;
SELECT BAGGAGE_ID INTO i FROM BAGGAGE_DATA WHERE BAGGAGE_HISTORY_ID = k;
SELECT LAST_SCAN_TERMINAL INTO j FROM BAGGAGE_DATA WHERE BAGGAGE_HISTORY_ID  = k;
UPDATE BAGGAGE SET LAST_SCAN_TERMINAL_ID = j WHERE BAGGAGE_ID = i;
END;
/


--Trigger to update last_scan_time in Baggage
create or replace trigger update_last_scan_time_in_baggage
after insert on baggage_data
declare
i NUMBER;
j timestamp;
k NUMBER;
begin
SELECT MAX(BAGGAGE_HISTORY_ID) INTO k FROM BAGGAGE_DATA;
SELECT BAGGAGE_ID INTO i FROM BAGGAGE_DATA WHERE BAGGAGE_HISTORY_ID = k;
SELECT at_time INTO j FROM BAGGAGE_DATA WHERE BAGGAGE_HISTORY_ID  = k;
UPDATE BAGGAGE SET LAST_SCAN_time = j WHERE BAGGAGE_ID = i;
end;
/



--Trigger to update reached_destination flag upon reaching the final destination.
CREATE OR REPLACE TRIGGER UPDATE_BAGGAGE_STATUS_UPON_DESTINATION
AFTER INSERT ON BAGGAGE_DATA
DECLARE
i NUMBER;
j NUMBER;
k NUMBER;
x NUMBER;
BEGIN
SELECT MAX(BAGGAGE_HISTORY_ID) INTO k FROM BAGGAGE_DATA;
SELECT BAGGAGE_ID INTO j FROM BAGGAGE_DATA WHERE BAGGAGE_HISTORY_ID = k;
SELECT DESTINATION_TERMINAL_ID INTO i FROM FLIGHT  WHERE FLIGHT_NUMBER = (SELECT THIRD_FLIGHT_NUMBER FROM ROUTE WHERE ROUTE_CODE = (SELECT ROUTE_CODE FROM BAGGAGE WHERE BAGGAGE_ID = j));
SELECT LAST_SCAN_TERMINAL INTO x FROM BAGGAGE_DATA WHERE BAGGAGE_HISTORY_ID = k;
IF x = i THEN
UPDATE BAGGAGE SET REACHED_DESTINATION = 'Y' WHERE BAGGAGE_ID = j;
DBMS_OUTPUT.put_line('For Baggage-> '|| j || ' '|| x || ' ' || i);
END IF;
END;
/



--Procedure for collecting a Bag
create or replace procedure collect_bag(baggageid number)
as
v_isreached varchar(1);
v_collected varchar(1);
e_notreached exception;
e_collected exception;
begin
select reached_destination into v_isreached from baggage where baggage_id=baggageid;
select is_claimed into v_collected from baggage where baggage_id=baggageid;
if(v_collected='Y') then raise e_collected;
elsif(v_isreached='Y') then
update baggage set is_claimed = 'Y' where baggage_id = baggageid;
commit;
dbms_output.put_line('Baggage '||baggageid||' collected');
else raise e_notreached;
end if;
exception
when e_collected then dbms_output.put_line('Baggage collected already');
when e_notreached then dbms_output.put_line('Cannot collect a bag which has not reached destination');
when others then raise;
commit;
end collect_bag;
/

select * from baggage;

--Procedure for adding a new Passenger
create or replace procedure add_passenger(firstname varchar,lastname varchar, passport varchar,
mobile varchar,
address1 varchar,
address2 varchar,
city varchar,
state varchar,
country varchar,
zipcode number
)
as
begin
INSERT INTO PASSENGER VALUES(PASSENEGER_ID_AUTO.NEXTVAL,firstname,lastname,passport,mobile,address1,address2,city,state,country,zipcode);
    DBMS_OUTPUT.PUT_LINE('Passenger Added');
commit;
end add_passenger;
/


--Procedure for getting the baggage_history for a particular bag based on baggage_id.
create or replace procedure get_baggage_history(in_id number)
is
v_count number;
e_notexist exception;
begin
select count(*) into v_count from baggage where baggage_id=in_id;
if(v_count>0) then
for bag in (select baggage_id as baggage,concat(concat(bt.status,terminal_name),location) as HISTORY, at_time as in_time from baggage_data bd,terminal t,airport a,baggage_status_type bt where
t.terminal_id = bd.last_scan_terminal and t.airport_id = a.airport_id and bd.current_status = bt.status_id and baggage_id = in_id order by bd.baggage_history_id)
loop
dbms_output.put_line(bag.baggage || ' '||bag.history||' at '||bag.in_time);
end loop;
else raise e_notexist;
end if;
exception
when e_notexist then dbms_output.put_line('The provided baggage_id does not exist');
when others then raise;
commit;
end get_baggage_history;
/

create or replace procedure update_route (route_id number,first number, second number, third number)
as begin
update route set first_flight_number = first, second_flight_number = second, third_flight_number = third where route_code = route_id;
DBMS_OUTPUT.PUT_LINE('Route Updated');
commit;
end update_route;
/

--View for baggages lost last week
create or replace view baggages_lost_last_week as
select baggage_id,terminal_name,airport.name as airport_name from baggage 
join terminal on baggage.last_scan_terminal_id=terminal.terminal_id
join airport on terminal.airport_id = airport.airport_id
where REACHED_DESTINATION='N' and round(trunc(systimestamp)-trunc(created_on)) between 7 and 14 and round(trunc(last_scan_time)-trunc(created_on))>=2;

select * from baggages_lost_last_week;

--View for baggages lost this week
create or replace view baggages_lost_this_week as
select baggage_id,terminal_name,airport.name from baggage 
join terminal on baggage.last_scan_terminal_id=terminal.terminal_id
join airport on terminal.airport_id = airport.airport_id
where REACHED_DESTINATION='N' and round(trunc(systimestamp)-trunc(created_on))<7 and round(trunc(last_scan_time)-trunc(created_on))>=2;

select * from baggages_lost_this_week;

--View for airport with most baggages lost
create or replace view airport_with_most_baggages_lost as
select airport.name,count(*) no_of_bags_lost from baggage 
join terminal on baggage.last_scan_terminal_id=terminal.terminal_id
join airport on terminal.airport_id = airport.airport_id
where REACHED_DESTINATION='N' and round(trunc(last_scan_time)-trunc(created_on))>=2
group by airport.name
order by no_of_bags_lost desc;

--select * from airport_with_most_baggages_lost;

--View for Baggage History
create or replace view Baggage_History as
select baggage_id,concat(concat(bt.status,terminal_name),location) as HISTORY, at_time from baggage_data bd,terminal t,airport a,baggage_status_type bt where
t.terminal_id = bd.last_scan_terminal and t.airport_id = a.airport_id and bd.current_status = bt.status_id order by bd.baggage_history_id;

select * from Baggage_History;

--View for baggages unclaimed last week
create or replace view baggages_unclaimed_in_last_week as
select * from baggage where reached_destination='Y' and is_claimed='N' and round(trunc(systimestamp)-trunc(last_scan_time)) between 7 and 14 and round(trunc(last_scan_time)-trunc(created_on))>=2;

select * from baggages_unclaimed_in_last_week;

--View for baggages unclaimed this week
create or replace view baggages_unclaimed_in_this_week as
select * from baggage where reached_destination='Y' and is_claimed='N' and round(trunc(systimestamp)-trunc(last_scan_time))<7 and round(trunc(last_scan_time)-trunc(created_on))>=2;

select * from baggages_unclaimed_in_this_week;

--View for Unclaimed Baggages
create or replace view un_claimed_bags as
select * from baggage where is_claimed = 'N' and reached_destination = 'Y' and round(trunc(systimestamp) - trunc(last_scan_time)) > =2;
--select * from un_claimed_bags;

--View for Claimed Baggages
create or replace view claimed_bags as
SELECT * FROM BAGGAGE where is_claimed = 'Y';
select * from claimed_bags;
--View for Complaints
create or replace view View_Complaints as
select c.complaint_id,c.baggage_id,cs.status from complaint c,complaint_status cs where c.status = cs.complaint_status_id;

--View for Lost Baggages
create or replace view Lost_baggages as
select * from baggage where is_claimed = 'N' and reached_destination = 'N' and round(trunc(systimestamp) - trunc(last_scan_time)) > 4;


INSERT INTO BAGGAGE_STATUS_TYPE VALUES(BAGGAGE_STATUS_ID_AUTO.NEXTVAL,'Scanned at ');
INSERT INTO BAGGAGE_STATUS_TYPE VALUES(BAGGAGE_STATUS_ID_AUTO.NEXTVAL,'Dispatched from ');
INSERT INTO BAGGAGE_STATUS_TYPE VALUES(BAGGAGE_STATUS_ID_AUTO.NEXTVAL,'Received at ');
INSERT INTO BAGGAGE_STATUS_TYPE VALUES(BAGGAGE_STATUS_ID_AUTO.NEXTVAL,'Out for Delivery at ');
insert into complaint_status values(1,'Active');
insert into complaint_status values(2,'Processing');
insert into complaint_status values(3,'Closed');


exec add_airport('John F Kennedy','New York');
exec add_airport('Dallas Fort/Worth','Dallas');
exec add_airport('Logan INTL','Boston');
exec add_airport('Dubai INTL','Dubai');
exec add_airport('Abu Dhabi INTL','Abu Dhabi');
exec add_airport('Tacoma INTL','Seattle');
exec add_airport('Indira Gandhi INTL','New Delhi');
exec add_airport('Shivaji INTL','Mumbai');
exec add_airport('Heathrow INTL','London');
exec add_airport('OHare International Airport','Chicago');
exec add_airport('Dulles INTL','Washington D.C.');
exec add_airport('Hartsfield?Jackson','Atlanta');
exec add_airport('Schipol INTL','Amsterdam');
exec add_airport('Hamad INTL','Doha');
--unique for passport


--Views for all tables
create or replace view view_airports
as
select * from airport;



create or replace view view_terminals
as select * from terminal;




create or replace view view_flights
as select * from flight;




create or replace view view_routes
as select * from route;




create or replace view view_passengers
as select * from passenger;



create or replace view  view_baggage_data
as select * from baggage_data;

create or replace view view_complaint as
select * from complaint;


create or replace view view_ticket as
select * from ticket;

--EXEC get_baggage_history(1);

/*SELECT * FROM AIRPORT;
SELECT * FROM TERMINAL;
SELECT * FROM ROUTE;
SELECT * FROM FLIGHT;
SELECT * FROM PASSENGER;
SELECT * FROM TICKET;
SELECT * FROM BAGGAGE;
SELECT * FROM BAGGAGE_STATUS_TYPE;
SELECT * FROM BAGGAGE_DATA;
EXEC get_baggage_history(1);
EXEC get_baggage_history(2);
*/