begin
    execute immediate 'drop user terminal_admin cascade';--view/update baggage,baggage_data
    execute immediate 'drop user resolution_manager cascade';--view and update complaints, view baggage
    execute immediate 'drop user passenger cascade';--adds himself,books tickets and creates/views complaints
    execute immediate 'drop user airlines_admin cascade';--adds/updates flight,route
    execute immediate 'drop user analyst cascade';
    --analyst reports

exception
    when others then
        if sqlcode!=-1918 then
            raise;
        end if;    
end;
/

create user airlines_admin identified by PasswordForDmdd5;
grant create session to airlines_admin;
grant execute on add_flight to airlines_admin;
grant execute on add_route to airlines_admin;

create user terminal_admin identified by PasswordForDmdd2;
grant create session to terminal_admin;
grant execute on get_baggage_history to terminal_admin;


create user resolution_manager identified by PasswordForDmdd3;
grant create session to resolution_manager;

create user passenger identified by PasswordForDmdd4;
grant create session to passenger;


create user analyst identified by PasswordForDmdd6;
grant create session to analyst;

