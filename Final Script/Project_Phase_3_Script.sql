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
 BEGIN
    insert into airport values(airport_id_auto.nextval,in_name,in_location);
    DBMS_OUTPUT.PUT_LINE('Airport Added');
    commit;
  END add_airport;
/
commit;






--Procedure for Adding Flights
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



--Procedure for getting the baggage_history for a particular bag based on baggage_id.
create or replace procedure get_baggage_history(in_id number)
is
begin
for bag in (select baggage_id as baggage,concat(concat(bt.status,terminal_name),location) as HISTORY, at_time as in_time from baggage_data bd,terminal t,airport a,baggage_status_type bt where
t.terminal_id = bd.last_scan_terminal and t.airport_id = a.airport_id and bd.current_status = bt.status_id and baggage_id = in_id order by bd.baggage_history_id)
loop
dbms_output.put_line(bag.baggage || ' '||bag.history||' at '||bag.in_time);
end loop;
commit;
end get_baggage_history;
/
--Procedure for adding new ticket
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

--Procedure for adding new route
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

--Procedure for adding new complaint
create or replace procedure add_complaint(bag_id number,
status number)
as
begin
INSERT INTO complaint VALUES (complaint_id_auto.NEXTVAL,bag_id,status);
    DBMS_OUTPUT.PUT_LINE('Complaint Added');
commit;
end add_complaint;
/



--Procedure for adding bagagge_data.
create or replace procedure add_baggage_data(baggageid number,currentstatus number, lastscan number)
as
v_cdate date;
begin
select created_on into v_cdate from baggage where baggage_id = baggageid;
insert into baggage_data values(baggage_history_id_auto.nextval,baggageid,currentstatus,lastscan,cast(v_cdate+2 as timestamp));
commit;
end add_baggage_data;
/

create or replace procedure collect_bag(baggageid number)
as
begin
update baggage set is_claimed = 'Y' where baggage_id = baggageid;
commit;
end collect_bag;
/
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



--Trigger to automatically generate terminal for each airport
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
SELECT DBMS_RANDOM.value(6,7) INTO rand from dual;
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




--trigger to update last_scan_terminal_id for each  baggage.
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



--View for Baggage History Based on Baggage_id
create or replace view Baggage_History as
select baggage_id,concat(concat(bt.status,terminal_name),location) as HISTORY, at_time from baggage_data bd,terminal t,airport a,baggage_status_type bt where
t.terminal_id = bd.last_scan_terminal and t.airport_id = a.airport_id and bd.current_status = bt.status_id order by bd.baggage_history_id;



--View for Unclaimed Baggages
create or replace view un_claimed_bags as
select * from baggage where is_claimed = 'N' and reached_destination = 'Y' and round(trunc(systimestamp) - trunc(last_scan_time)) > 4;


--View for Claimed Baggages
create or replace view claimed_bags as
SELECT * FROM BAGGAGE where is_claimed = 'Y';

--View for Complaints
create or replace view View_Complaints as
select c.complaint_id,c.baggage_id,cs.status from complaint c,complaint_status cs where c.status = cs.complaint_status_id;

--View for Lost Baggages
create or replace view Lost_baggages as
select * from baggage where is_claimed = 'N' and reached_destination = 'N' and round(trunc(systimestamp) - trunc(last_scan_time)) > 4;

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
exec add_airport('Hartsfield–Jackson','Atlanta');
exec add_airport('Schipol INTL','Amsterdam');
exec add_airport('Hamad INTL','Doha');
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
exec add_passenger('TOM','CRUISE','A12345','1234567891','HUNTINGTON AVE','ROXBURY','BOSTON','MA','UNITED STATES','02120');
exec add_passenger('JACK','WILLS','A67891','1011121345','DUDLY STREET','DORCHESTOR','BOSTON','MA','UNITED STATES','02121');
exec add_passenger('DREDD','FISHER','A78910','1415161718','WASHINGTON STREET','BROOKLINE','NEW YORK','NEW YORK','UNITED STATES','01969');
exec add_passenger('MANNY','KOSHBIN','A56790','2084228584','MALIBU AVENUE','DUBLIN HOUSE','MIAMI','FLORIDA','UNITED STATES','06321');
exec add_passenger('DOUG','DEUMORU','A91988','9460089979','CAL TECH STREET','REDWOODS','SAN FRANSISCO','CALIFORNIA','UNITED STATES','45633');
exec add_passenger('EDWIN','VAN','A78102','8890322311','BRIGHAM STREET','COLOUMBUS AVENUE','NEW HAMPSHIRE','MA','UNITED STATES','36544');


exec add_ticket(1,1,5579,3);
exec add_ticket(1,3,1211,2);
exec add_ticket(1,2,1322,5);
exec add_ticket(1,2,3211,4);
exec add_ticket(1,1,1210,3);
exec add_ticket(2,4,1500,4);
exec add_ticket(2,5,1234,3);
exec add_ticket(3,1,5678,5);
exec add_ticket(3,6,5612,4);

INSERT INTO BAGGAGE_STATUS_TYPE VALUES(BAGGAGE_STATUS_ID_AUTO.NEXTVAL,'Scanned at ');
INSERT INTO BAGGAGE_STATUS_TYPE VALUES(BAGGAGE_STATUS_ID_AUTO.NEXTVAL,'Dispatched from ');
INSERT INTO BAGGAGE_STATUS_TYPE VALUES(BAGGAGE_STATUS_ID_AUTO.NEXTVAL,'Received at ');
INSERT INTO BAGGAGE_STATUS_TYPE VALUES(BAGGAGE_STATUS_ID_AUTO.NEXTVAL,'Out for Delivery at ');
insert into complaint_status values(1,'Active');
insert into complaint_status values(2,'Processing');
insert into complaint_status values(3,'Closed');
exec add_baggage_data(1,1,78);
exec add_baggage_data(1,2,78);
exec add_baggage_data(1,3,70);
exec add_baggage_data(1,1,71);
exec add_baggage_data(1,2,71);
exec add_baggage_data(1,3,57);
exec add_baggage_data(1,1,57);
exec add_baggage_data(1,2,57);
exec add_baggage_data(1,3,51);
exec add_baggage_data(1,4,51);
exec add_baggage_data(2,1,78);
exec add_baggage_data(2,2,78);
exec add_baggage_data(2,3,70);
exec add_baggage_data(2,1,71);
exec add_baggage_data(2,2,71);
exec add_baggage_data(2,3,57);
exec add_baggage_data(2,1,57);
exec add_baggage_data(2,2,57);
exec add_baggage_data(2,3,51);
exec add_baggage_data(2,4,51);
exec add_baggage_data(3,1,78);
exec add_baggage_data(3,2,78);
exec add_baggage_data(3,3,70);
exec add_baggage_data(3,1,71);
exec add_baggage_data(3,2,71);
exec add_baggage_data(3,3,57);
exec add_baggage_data(3,1,57);
exec add_baggage_data(3,2,57);
exec add_baggage_data(3,3,51);
exec add_baggage_data(3,4,51);
exec add_baggage_data(4,1,78);
exec add_baggage_data(4,2,78);
exec add_baggage_data(4,3,70);
exec add_baggage_data(4,1,71);
exec add_baggage_data(4,2,71);
exec add_baggage_data(4,3,57);
exec add_baggage_data(4,1,57);
exec add_baggage_data(4,2,57);
exec add_baggage_data(4,3,51);
exec add_baggage_data(4,4,51);
exec add_baggage_data(5,1,78);
exec add_baggage_data(5,2,78);
exec add_baggage_data(5,3,70);
exec add_baggage_data(5,1,71);
exec add_baggage_data(5,2,71);
exec add_baggage_data(5,3,57);
exec add_baggage_data(5,1,57);
exec add_baggage_data(5,2,57);
exec add_baggage_data(5,3,51);
exec add_baggage_data(5,4,51);
exec add_baggage_data(6,1,78);
exec add_baggage_data(6,2,78);
exec add_baggage_data(6,3,70);
exec add_baggage_data(6,1,71);
exec add_baggage_data(6,2,71);
exec add_baggage_data(6,3,57);
exec add_baggage_data(6,1,57);
exec add_baggage_data(6,2,57);
exec add_baggage_data(6,3,51);
exec add_baggage_data(6,4,51);
exec add_baggage_data(7,1,78);
exec add_baggage_data(7,2,78);
exec add_baggage_data(7,3,70);
exec add_baggage_data(7,1,71);
exec add_baggage_data(7,2,71);
exec add_baggage_data(7,3,57);
exec add_baggage_data(7,1,57);
exec add_baggage_data(7,2,57);
exec add_baggage_data(7,3,51);
exec add_baggage_data(7,4,51);
exec add_baggage_data(8,1,78);
exec add_baggage_data(8,2,78);
exec add_baggage_data(8,3,70);
exec add_baggage_data(8,1,71);
exec add_baggage_data(8,2,71);
exec add_baggage_data(8,3,57);
exec add_baggage_data(8,1,57);
exec add_baggage_data(8,2,57);
exec add_baggage_data(8,3,51);
exec add_baggage_data(8,4,51);
exec add_baggage_data(9,1,78);
exec add_baggage_data(9,2,78);
exec add_baggage_data(9,3,70);
exec add_baggage_data(9,1,71);
exec add_baggage_data(9,2,71);
exec add_baggage_data(9,3,57);
exec add_baggage_data(9,1,57);
exec add_baggage_data(9,2,57);
exec add_baggage_data(9,3,51);
exec add_baggage_data(9,4,51);
exec add_baggage_data(10,1,78);
exec add_baggage_data(10,2,78);
exec add_baggage_data(10,3,70);
exec add_baggage_data(10,1,71);
exec add_baggage_data(10,2,71);
exec add_baggage_data(10,3,57);
exec add_baggage_data(10,1,57);
exec add_baggage_data(10,2,57);
exec add_baggage_data(10,3,51);
exec add_baggage_data(10,4,51);
exec add_baggage_data(11,1,78);
exec add_baggage_data(11,2,78);
exec add_baggage_data(11,3,70);
exec add_baggage_data(11,1,71);
exec add_baggage_data(11,2,71);
exec add_baggage_data(11,3,71);
--exec add_baggage_data(11,1,57);
--exec add_baggage_data(11,2,57);
--exec add_baggage_data(11,3,51);
--exec add_baggage_data(11,4,51);
exec add_baggage_data(12,1,78);
exec add_baggage_data(12,2,78);
exec add_baggage_data(12,3,70);
exec add_baggage_data(12,1,71);
exec add_baggage_data(12,2,71);
exec add_baggage_data(12,3,71);
--exec add_baggage_data(12,1,57);
--exec add_baggage_data(12,2,57);
--exec add_baggage_data(12,3,51);
--exec add_baggage_data(12,4,51);
exec add_baggage_data(13,1,78);
exec add_baggage_data(13,2,78);
exec add_baggage_data(13,3,70);
exec add_baggage_data(13,1,71);
exec add_baggage_data(13,2,71);
exec add_baggage_data(13,3,71);
--exec add_baggage_data(13,1,57);
--exec add_baggage_data(13,2,57);
--exec add_baggage_data(13,3,51);
--exec add_baggage_data(13,4,51);
exec add_baggage_data(14,1,78);
exec add_baggage_data(14,2,78);
exec add_baggage_data(14,3,70);
--exec add_baggage_data(14,1,71);
--exec add_baggage_data(14,2,71);
--exec add_baggage_data(14,3,71);
--exec add_baggage_data(14,1,57);
--exec add_baggage_data(14,2,57);
--exec add_baggage_data(14,3,51);
--exec add_baggage_data(14,4,51);
exec add_baggage_data(15,1,78);
exec add_baggage_data(15,2,78);
exec add_baggage_data(15,3,70);
--exec add_baggage_data(15,1,71);
--exec add_baggage_data(15,2,71);
--exec add_baggage_data(15,3,71);
--exec add_baggage_data(15,1,57);
--exec add_baggage_data(15,2,57);
--exec add_baggage_data(15,3,51);
--exec add_baggage_data(15,4,51);
exec add_baggage_data(16,1,78);
exec add_baggage_data(16,2,78);
exec add_baggage_data(16,3,70);
--exec add_baggage_data(16,1,71);
--exec add_baggage_data(16,2,71);
--exec add_baggage_data(16,3,71);
--exec add_baggage_data(16,1,57);
--exec add_baggage_data(16,2,57);
--exec add_baggage_data(16,3,51);
--exec add_baggage_data(16,4,51);
exec add_baggage_data(17,1,78);
exec add_baggage_data(17,2,78);
exec add_baggage_data(17,3,70);
exec add_baggage_data(17,1,71);
exec add_baggage_data(17,2,71);
exec add_baggage_data(17,3,71);
exec add_baggage_data(17,1,57);
exec add_baggage_data(17,2,57);
--exec add_baggage_data(17,3,51);
--exec add_baggage_data(17,4,51);
exec add_baggage_data(18,1,43);
exec add_baggage_data(18,2,43);
exec add_baggage_data(18,3,43);
exec add_baggage_data(18,1,81);
exec add_baggage_data(18,2,81);
exec add_baggage_data(18,3,81);
exec add_baggage_data(18,1,51);
exec add_baggage_data(18,2,51);
exec add_baggage_data(18,3,51);
exec add_baggage_data(18,1,18);
exec add_baggage_data(18,2,18);
exec add_baggage_data(18,3,18);
exec add_baggage_data(18,4,18);
exec add_baggage_data(19,1,43);
exec add_baggage_data(19,2,43);
exec add_baggage_data(19,3,43);
exec add_baggage_data(19,1,81);
exec add_baggage_data(19,2,81);
exec add_baggage_data(19,3,81);
exec add_baggage_data(19,1,51);
exec add_baggage_data(19,2,51);
exec add_baggage_data(19,3,51);
exec add_baggage_data(19,1,18);
exec add_baggage_data(19,2,18);
exec add_baggage_data(19,3,18);
exec add_baggage_data(19,4,18);
exec add_baggage_data(20,1,43);
exec add_baggage_data(20,2,43);
exec add_baggage_data(20,3,43);
exec add_baggage_data(20,1,81);
exec add_baggage_data(20,2,81);
exec add_baggage_data(20,3,81);
exec add_baggage_data(20,1,51);
exec add_baggage_data(20,2,51);
exec add_baggage_data(20,3,51);
exec add_baggage_data(20,1,18);
exec add_baggage_data(20,2,18);
exec add_baggage_data(20,3,18);
exec add_baggage_data(20,4,18);
exec add_baggage_data(21,1,43);
exec add_baggage_data(21,2,43);
exec add_baggage_data(21,3,43);
exec add_baggage_data(21,1,81);
exec add_baggage_data(21,2,81);
exec add_baggage_data(21,3,81);
exec add_baggage_data(21,1,51);
exec add_baggage_data(21,2,51);
exec add_baggage_data(21,3,51);
exec add_baggage_data(21,1,18);
exec add_baggage_data(21,2,18);
exec add_baggage_data(21,3,18);
exec add_baggage_data(21,4,18);
exec add_baggage_data(22,1,43);
exec add_baggage_data(22,2,43);
exec add_baggage_data(22,3,43);
exec add_baggage_data(22,1,81);
exec add_baggage_data(22,2,81);
exec add_baggage_data(22,3,81);
exec add_baggage_data(22,1,51);
exec add_baggage_data(22,2,51);
exec add_baggage_data(22,3,51);
exec add_baggage_data(22,1,18);
exec add_baggage_data(22,2,18);
exec add_baggage_data(22,3,18);
exec add_baggage_data(22,4,18);
exec add_baggage_data(23,1,43);
exec add_baggage_data(23,2,43);
exec add_baggage_data(23,3,43);
exec add_baggage_data(23,1,81);
exec add_baggage_data(23,2,81);
exec add_baggage_data(23,3,81);
exec add_baggage_data(23,1,51);
exec add_baggage_data(23,2,51);
exec add_baggage_data(23,3,51);
exec add_baggage_data(23,1,18);
exec add_baggage_data(23,2,18);
exec add_baggage_data(23,3,18);
exec add_baggage_data(23,4,18);
exec add_baggage_data(24,1,43);
exec add_baggage_data(24,2,43);
exec add_baggage_data(24,3,43);
exec add_baggage_data(24,1,81);
exec add_baggage_data(24,2,81);
exec add_baggage_data(24,3,81);
exec add_baggage_data(24,1,51);
exec add_baggage_data(24,2,51);
exec add_baggage_data(24,3,51);
exec add_baggage_data(24,1,18);
exec add_baggage_data(24,2,18);
exec add_baggage_data(24,3,18);
exec add_baggage_data(24,4,18);
exec add_baggage_data(25,1,35);
exec add_baggage_data(25,2,35);
exec add_baggage_data(25,3,35);
exec add_baggage_data(25,1,9);
exec add_baggage_data(25,2,9);
exec add_baggage_data(25,3,9);
--exec add_baggage_data(25,1,5);
--exec add_baggage_data(25,2,5);
--exec add_baggage_data(25,3,5);
--exec add_baggage_data(25,1,20);
--exec add_baggage_data(25,2,20);
--exec add_baggage_data(25,3,20);
--exec add_baggage_data(25,4,20);
exec add_baggage_data(26,1,35);
exec add_baggage_data(26,2,35);
exec add_baggage_data(26,3,35);
exec add_baggage_data(26,1,9);
--exec add_baggage_data(26,2,9);
--exec add_baggage_data(26,3,9);
--exec add_baggage_data(26,1,5);
--exec add_baggage_data(26,2,5);
--exec add_baggage_data(26,3,5);
--exec add_baggage_data(26,1,20);
--exec add_baggage_data(26,2,20);
--exec add_baggage_data(26,3,20);
--exec add_baggage_data(26,4,20);
exec add_baggage_data(27,1,35);
exec add_baggage_data(27,2,35);
exec add_baggage_data(27,3,35);
exec add_baggage_data(27,1,9);
exec add_baggage_data(27,2,9);
exec add_baggage_data(27,3,9);
exec add_baggage_data(27,1,5);
--exec add_baggage_data(27,2,5);
--exec add_baggage_data(27,3,5);
--exec add_baggage_data(27,1,20);
--exec add_baggage_data(27,2,20);
--exec add_baggage_data(27,3,20);
--exec add_baggage_data(27,4,20);
exec add_baggage_data(28,1,35);
exec add_baggage_data(28,2,35);
exec add_baggage_data(28,3,35);
exec add_baggage_data(28,1,9);
exec add_baggage_data(28,2,9);
exec add_baggage_data(28,3,9);
exec add_baggage_data(28,1,5);
exec add_baggage_data(28,2,5);
--exec add_baggage_data(28,3,5);
--exec add_baggage_data(28,1,20);
--exec add_baggage_data(28,2,20);
--exec add_baggage_data(28,3,20);
--exec add_baggage_data(28,4,20);
exec add_baggage_data(29,1,35);
exec add_baggage_data(29,2,35);
exec add_baggage_data(29,3,35);
exec add_baggage_data(29,1,9);
exec add_baggage_data(29,2,9);
exec add_baggage_data(29,3,9);
exec add_baggage_data(29,1,5);
--exec add_baggage_data(29,2,5);
--exec add_baggage_data(29,3,5);
--exec add_baggage_data(29,1,20);
--exec add_baggage_data(29,2,20);
--exec add_baggage_data(29,3,20);
--exec add_baggage_data(29,4,20);
exec add_baggage_data(30,1,35);
exec add_baggage_data(30,2,35);
exec add_baggage_data(30,3,35);
exec add_baggage_data(30,1,9);
exec add_baggage_data(30,2,9);
exec add_baggage_data(30,3,9);
exec add_baggage_data(30,1,5);
--exec add_baggage_data(30,2,5);
--exec add_baggage_data(30,3,5);
--exec add_baggage_data(30,1,20);
--exec add_baggage_data(30,2,20);
--exec add_baggage_data(30,3,20);
--exec add_baggage_data(30,4,20);
exec add_baggage_data(31,1,35);
exec add_baggage_data(31,2,35);
exec add_baggage_data(31,3,35);
exec add_baggage_data(31,1,9);
exec add_baggage_data(31,2,9);
exec add_baggage_data(31,3,9);
exec add_baggage_data(31,1,5);
exec add_baggage_data(31,2,5);
--exec add_baggage_data(31,3,5);
--exec add_baggage_data(31,1,20);
--exec add_baggage_data(31,2,20);
--exec add_baggage_data(31,3,20);
--exec add_baggage_data(31,4,20);
exec add_baggage_data(32,1,35);
exec add_baggage_data(32,2,35);
exec add_baggage_data(32,3,35);
exec add_baggage_data(32,1,9);
exec add_baggage_data(32,2,9);
exec add_baggage_data(32,3,9);
exec add_baggage_data(32,1,5);
exec add_baggage_data(32,2,5);
--exec add_baggage_data(32,3,5);
--exec add_baggage_data(32,1,20);
--exec add_baggage_data(32,2,20);
--exec add_baggage_data(32,3,20);
--exec add_baggage_data(32,4,20);
exec add_baggage_data(33,1,35);
exec add_baggage_data(33,2,35);
exec add_baggage_data(33,3,35);
exec add_baggage_data(33,1,9);
exec add_baggage_data(33,2,9);
exec add_baggage_data(33,3,9);
exec add_baggage_data(33,1,5);
--exec add_baggage_data(33,2,5);
--exec add_baggage_data(33,3,5);
--exec add_baggage_data(33,1,20);
--exec add_baggage_data(33,2,20);
--exec add_baggage_data(33,3,20);
--exec add_baggage_data(33,4,20);



exec collect_bag(6);
exec collect_bag(7);
exec collect_bag(8);
exec collect_bag(9);
exec collect_bag(10);
exec add_complaint(1,1);
exec add_complaint(2,1);
exec add_complaint(3,2);

SELECT * FROM AIRPORT;
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

select * from claimed_bags;
select * from view_complaints;
update baggage set last_scan_time = cast(created_on+2 as timestamp) where baggage_id in (1,2,3,4,5);
update baggage set last_scan_time = cast(created_on+5 as timestamp) where baggage_id in (11,12,13,14,15,16,17);
SELECT * FROM UN_CLAIMED_BAGS;
select* from lost_baggages;
--lost baggages in the last week
--airport with high lost baggages
--last_week report of unclaimed baggages.








