begin
    execute immediate 'drop user application_admin cascade';
exception
    when others then
        if sqlcode!=-1918 then
            raise;
        end if;    
end;
/



create user application_admin identified by "PasswordForDmdd1";
grant connect, resource to application_admin;
grant create session to application_admin with admin option;
grant create table to application_admin;
alter user application_admin quota unlimited on data;
grant create view, create procedure, create sequence,create trigger to application_admin;
grant create user to application_admin;
grant drop user to application_admin;