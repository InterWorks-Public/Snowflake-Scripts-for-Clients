---------------------------------- CLIENT SYSTEM SCRIPT ---------------------------------

-----------------------------------------------------------------------------------------
----------------------------------- INTERWORKS ACCESS -----------------------------------
-----------------------------------------------------------------------------------------

-- This automated deployment script is
-- designed to be executed without
-- any modifications.
-- Please execute the script in full
-- and send the final output to your
-- InterWorks contact

---------------------------------------
-- Note on warehouse

-- This script requires an active warehouse
-- so that it can perform certain activities
-- such as generating a random password and
-- retrieving the connection string. 

use role "SYSADMIN";

create warehouse if not exists "WH_ADMIN"
  warehouse_size = 'XSMALL'
  auto_suspend = 120
  initially_suspended = TRUE
  comment = 'Used for generic low-effort processes performed by admin roles'
;
grant usage on warehouse "WH_ADMIN" to role "SECURITYADMIN";

---------------------------------------
-- Automated user creation

use role "SECURITYADMIN";

set username = 'INTERWORKS_ADMIN';

set connection_string = (
  select lower(replace(
      concat(
          current_organization_name()
        , '-'
        , current_account_name()
        , '.snowflakecomputing.com'
      )
    , '_', '-'
  ))
)
;

set first_name = 'InterWorks';
set last_name = 'Admin account';
set comment = 'Admin user for InterWorks - Snowflake services partner';
set password = (select randstr(30, random()));

create user if not exists identifier($username) 
  password = $password
;

alter user identifier($username) set
  first_name = $first_name
  last_name = $last_name
  comment = $comment
  must_change_password = TRUE
  type = 'PERSON'
;

-- Grant SECURITYADMIN access
grant role "SECURITYADMIN" to user identifier($username);

---- View output

describe user identifier($username);

select 
    $username as username
  , $password as password
;

-- Paste-able text to the user in slack
select concat(
    'Here are the details to send to your InterWorks contact:' || '\n'
  , 'Connection string: ' || $connection_string || '\n'
  , 'Username: `' || $username || '`\n'
  , 'Password: `' || $password || '`\n'
  , 'You will need to change your password through the UI before connecting to Snowflake elsewhere.' || '\n'
  ) as details
;
