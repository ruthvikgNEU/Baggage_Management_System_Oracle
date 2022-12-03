begin
    execute immediate 'drop user application_admin cascade';
    execute immediate 'drop user terminal_admin cascade';
    execute immediate 'drop user resolution_manager cascade';
    execute immediate 'drop user passenger cascade';
    execute immediate 'drop user airlines_admin cascade';
exception
    when others then
        if sqlcode!=-1918 then
            raise;
        end if;    
end;
/

create user application_admin identified by PasswordForDmdd1;
grant create session to application_admin;
grant create table to application_admin;
alter user application_admin quota unlimited on data;
grant create view, create procedure, create sequence,create trigger to application_admin;

create user terminal_admin identified by PasswordForDmdd2;
grant create session to terminal_admin;

create user resolution_manager identified by PasswordForDmdd3;
grant create session to resolution_manager;

create user passenger identified by PasswordForDmdd4;
grant create session to passenger;

create user airlines_admin identified by PasswordForDmdd5;
grant create session to airlines_admin;



