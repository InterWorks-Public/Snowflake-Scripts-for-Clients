---------------------------------- CLIENT SYSTEM SCRIPT ---------------------------------

-----------------------------------------------------------------------------------------
----------------------------------- INTERWORKS ACCESS -----------------------------------
-----------------------------------------------------------------------------------------

---------------------------------------
-- Required variables

-- Please populate the following variables
-- as best you can.

---- Account Identifier

-- Account identifier for your Snowflake account,
-- which should be visible within the URL of your
-- current browser page when interacting with
-- Snowflake. More information can be found here:
-- https://docs.snowflake.com/en/user-guide/admin-account-identifier

-- If you are unsure, any of the following examples
-- provide InterWorks with the information needed:
-- - client-account
-- - https://client-account.snowflakecomputing.com
-- - account.region
-- - https://account.region.snowflakecomputing.com
-- - https://app.snowflake.com/region/account

set account_identifier = '';

---- Password

-- To ensure security, we request that clients
-- set the original password for the InterWorks
-- service account themselves. Once InterWorks
-- have accessed the account, the password
-- will then be changed and multi-factor
-- authentication will be added

set password = '';

---------------------------------------
-- Automated script begins here

-- From this point, this script is
-- designed to be executed without
-- any further modifications.
-- Please execute the script in full
-- and send the final output to your
-- InterWorks contact

use role SECURITYADMIN;

---------------------------------------
-- Automated user creation

set username = 'INTERWORKS_ADMIN';

set snowflake_account = (select current_account());
set snowflake_region = (select current_region());

set first_name = 'InterWorks';
set last_name = 'Admin account';
set comment = 'Admin user for InterWorks - Snowflake services partner';

create user if not exists identifier($username) 
  password = $password
;

alter user identifier($username) set
  first_name = $first_name
  last_name = $last_name
  comment = $comment
  must_change_password = TRUE
;

-- Grant securityadmin access
grant role securityadmin to user identifier($username);

---- View output

DESCRIBE USER identifier($username);

SELECT 
    $username as username
  , $password as password
;

-- Paste-able text to the user in slack
select concat(
    'Here are the details to send to your InterWorks contact:' || '\n'
  , 'Account idenfifier: ' || $account_identifier || '\n'
  , 'Username: `' || $username || '`\n'
  , 'Password: `' || $password || '`\n'
  , 'Snowflake account: `' || $snowflake_account || '`\n'
  , 'Snowflake region: `' || $snowflake_region || '`\n'
  ) as details
;