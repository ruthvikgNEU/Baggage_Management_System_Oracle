alter session set current_schema=application_admin;
set serveroutput on;

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

--exec add_complaint(1,1);
--exec add_complaint(2,1);
--exec add_complaint(3,2);
