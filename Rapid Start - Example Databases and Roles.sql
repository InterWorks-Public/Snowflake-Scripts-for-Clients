
-----------------------------------------------------------------------------------------
----------------------- Rapid Start - Example Databases and Roles -----------------------
-----------------------------------------------------------------------------------------

-- This script produces an example set of roles, databases and schemas that enable users
-- from two separate domains; Domain A and Domain B

--------------------------------------------------
-- Account Roles
--------------------------------------------------

-------------------------
-- Environment

use role "SECURITYADMIN";

-------------------------
-- Creating account roles

create role if not exists "DATA_PLATFORM_MANAGER"
  comment = 'Main role for owning all main databases in the account. Does not manage some admin-level databases'
;

-- Domain A
create role if not exists "ENGINEER_DOMAIN_A"
  comment = 'Role for the data engineers that belong to domain A'
;

create role if not exists "ANALYST_DOMAIN_A"
  comment = 'Role for the data analysts that belong to domain A'
;

create role if not exists "READER_DOMAIN_A"
  comment = 'Read-only role for general users that belong to domain A'
;

create role if not exists "METADATA_DOMAIN_A"
  comment = 'Metadata-only role for metadata-driven functionality that aligns with domain A'
;

-- Domain B
create role if not exists "ENGINEER_DOMAIN_B"
  comment = 'Role for the data engineers that belong to domain B'
;

create role if not exists "ANALYST_DOMAIN_B"
  comment = 'Role for the data analysts that belong to domain B'
;

create role if not exists "READER_DOMAIN_B"
  comment = 'Read-only role for general users that belong to domain B'
;

create role if not exists "METADATA_DOMAIN_B"
  comment = 'Metadata-only role for metadata-driven functionality that aligns with domain B'
;

-------------------------
-- Account role hierarchy

grant role "DATA_PLATFORM_MANAGER" to role "SYSADMIN";

-- Domain A
grant role "METADATA_DOMAIN_A" to role "READER_DOMAIN_A";
grant role "READER_DOMAIN_A" to role "ANALYST_DOMAIN_A";
grant role "ANALYST_DOMAIN_A" to role "ENGINEER_DOMAIN_A";
grant role "ENGINEER_DOMAIN_A" to role "DATA_PLATFORM_MANAGER";

-- Domain B
grant role "METADATA_DOMAIN_B" to role "READER_DOMAIN_B";
grant role "READER_DOMAIN_B" to role "ANALYST_DOMAIN_B";
grant role "ANALYST_DOMAIN_B" to role "ENGINEER_DOMAIN_B";
grant role "ENGINEER_DOMAIN_B" to role "DATA_PLATFORM_MANAGER";

-- Account role hierarchy representation:

-- - DATA_PLATFORM_MANAGER
--   - ENGINEER_DOMAIN_A
--     - ANALYST_DOMAIN_A
--       - READER_DOMAIN_A
--         - METADATA_DOMAIN_A
--   - ENGINEER_DOMAIN_B
--     - ANALYST_DOMAIN_B
--       - READER_DOMAIN_B
--         - METADATA_DOMAIN_B


--------------------------------------------------
-- Data Platform Manager can create databases
--------------------------------------------------

-- Must use ACCOUNTADMIN for this specific grant
use role "ACCOUNTADMIN";
grant create database on account to role "DATA_PLATFORM_MANAGER";

--------------------------------------------------
-- Databases and schemas
--------------------------------------------------

-------------------------
-- Environment

-- All of these objects will be owned
-- by the data platform manager to start
use role "DATA_PLATFORM_MANAGER";

-------------------------
-- Creating databases

create database if not exists "BRONZE"
  comment = 'Bronze tier database for raw and unmanaged data'
;

create database if not exists "SILVER"
  comment = 'Silver tier database for cleaned data'
;

create database if not exists "GOLD"
  comment = 'Gold tier database for data that is ready for analytics and other downstream purposes'
;

-------------------------
-- Schemas

-- Domain A
create schema if not exists "BRONZE"."DOMAIN_A"
  comment = 'Bronze tier schema for raw and unmanaged data related to domain A'
;

create schema if not exists "SILVER"."DOMAIN_A"
  comment = 'Silver tier schema for cleaned data related to domain A'
;

create schema if not exists "GOLD"."DOMAIN_A"
  comment = 'Gold tier schema for data that is ready for analytics and other downstream purposes related to domain A'
;

-- Domain B
create schema if not exists "BRONZE"."DOMAIN_B"
  comment = 'Bronze tier schema for raw and unmanaged data related to domain B'
;

create schema if not exists "SILVER"."DOMAIN_B"
  comment = 'Silver tier schema for cleaned data related to domain B'
;

create schema if not exists "GOLD"."DOMAIN_B"
  comment = 'Gold tier schema for data that is ready for analytics and other downstream purposes related to domain B'
;

-------------------------
-- Databases roles - Database-level parents

-- Bronze - Database
create database role if not exists "BRONZE"."DB__OWNER"
  comment = 'Full access to all schemas in the database'
;
create database role if not exists "BRONZE"."DB__WRITER"
  comment = 'Write access to all schemas in the database'
;
create database role if not exists "BRONZE"."DB__READER"
  comment = 'Read-only access to all schemas in the database'
;
create database role if not exists "BRONZE"."DB__METADATA"
  comment = 'Metadata-only access to all schemas in the database'
;

-- Silver - Database
create database role if not exists "SILVER"."DB__OWNER"
  comment = 'Full access to all schemas in the database'
;
create database role if not exists "SILVER"."DB__WRITER"
  comment = 'Write access to all schemas in the database'
;
create database role if not exists "SILVER"."DB__READER"
  comment = 'Read-only access to all schemas in the database'
;
create database role if not exists "SILVER"."DB__METADATA"
  comment = 'Metadata-only access to all schemas in the database'
;

-- Gold - Database
create database role if not exists "GOLD"."DB__OWNER"
  comment = 'Full access to all schemas in the database'
;
create database role if not exists "GOLD"."DB__WRITER"
  comment = 'Write access to all schemas in the database'
;
create database role if not exists "GOLD"."DB__READER"
  comment = 'Read-only access to all schemas in the database'
;
create database role if not exists "GOLD"."DB__METADATA"
  comment = 'Metadata-only access to all schemas in the database'
;

-------------------------
-- Databases roles - Schema-level - Domain A

-- Bronze - Schema - Domain A
create database role if not exists "BRONZE"."SC__DOMAIN_A__OWNER"
  comment = 'Full access to the schema'
;
grant database role "BRONZE"."SC__DOMAIN_A__OWNER" to database role "BRONZE"."DB__OWNER";

create database role if not exists "BRONZE"."SC__DOMAIN_A__WRITER"
  comment = 'Write access to the schema'
;
grant database role "BRONZE"."SC__DOMAIN_A__WRITER" to database role "BRONZE"."DB__WRITER";
grant database role "BRONZE"."SC__DOMAIN_A__WRITER" to database role "BRONZE"."SC__DOMAIN_A__OWNER";

create database role if not exists "BRONZE"."SC__DOMAIN_A__READER"
  comment = 'Read-only access to the schema'
;
grant database role "BRONZE"."SC__DOMAIN_A__READER" to database role "BRONZE"."DB__READER";
grant database role "BRONZE"."SC__DOMAIN_A__READER" to database role "BRONZE"."SC__DOMAIN_A__WRITER";

create database role if not exists "BRONZE"."SC__DOMAIN_A__METADATA"
  comment = 'Metadata-only access to the schema'
;
grant database role "BRONZE"."SC__DOMAIN_A__METADATA" to database role "BRONZE"."DB__METADATA";
grant database role "BRONZE"."SC__DOMAIN_A__METADATA" to database role "BRONZE"."SC__DOMAIN_A__READER";

-- Silver - Schema - Domain A
create database role if not exists "SILVER"."SC__DOMAIN_A__OWNER"
  comment = 'Full access to the schema'
;
grant database role "SILVER"."SC__DOMAIN_A__OWNER" to database role "SILVER"."DB__OWNER";

create database role if not exists "SILVER"."SC__DOMAIN_A__WRITER"
  comment = 'Write access to the schema'
;
grant database role "SILVER"."SC__DOMAIN_A__WRITER" to database role "SILVER"."DB__WRITER";
grant database role "SILVER"."SC__DOMAIN_A__WRITER" to database role "SILVER"."SC__DOMAIN_A__OWNER";

create database role if not exists "SILVER"."SC__DOMAIN_A__READER"
  comment = 'Read-only access to the schema'
;
grant database role "SILVER"."SC__DOMAIN_A__READER" to database role "SILVER"."DB__READER";
grant database role "SILVER"."SC__DOMAIN_A__READER" to database role "SILVER"."SC__DOMAIN_A__WRITER";

create database role if not exists "SILVER"."SC__DOMAIN_A__METADATA"
  comment = 'Metadata-only access to the schema'
;
grant database role "SILVER"."SC__DOMAIN_A__METADATA" to database role "SILVER"."DB__METADATA";
grant database role "SILVER"."SC__DOMAIN_A__METADATA" to database role "SILVER"."SC__DOMAIN_A__READER";

-- Gold - Schema - Domain A
create database role if not exists "GOLD"."SC__DOMAIN_A__OWNER"
  comment = 'Full access to the schema'
;
grant database role "GOLD"."SC__DOMAIN_A__OWNER" to database role "GOLD"."DB__OWNER";

create database role if not exists "GOLD"."SC__DOMAIN_A__WRITER"
  comment = 'Write access to the schema'
;
grant database role "GOLD"."SC__DOMAIN_A__WRITER" to database role "GOLD"."DB__WRITER";
grant database role "GOLD"."SC__DOMAIN_A__WRITER" to database role "GOLD"."SC__DOMAIN_A__OWNER";

create database role if not exists "GOLD"."SC__DOMAIN_A__READER"
  comment = 'Read-only access to the schema'
;
grant database role "GOLD"."SC__DOMAIN_A__READER" to database role "GOLD"."DB__READER";
grant database role "GOLD"."SC__DOMAIN_A__READER" to database role "GOLD"."SC__DOMAIN_A__WRITER";

create database role if not exists "GOLD"."SC__DOMAIN_A__METADATA"
  comment = 'Metadata-only access to the schema'
;
grant database role "GOLD"."SC__DOMAIN_A__METADATA" to database role "GOLD"."DB__METADATA";
grant database role "GOLD"."SC__DOMAIN_A__METADATA" to database role "GOLD"."SC__DOMAIN_A__READER";

-------------------------
-- Databases roles - Schema-level - Domain B

-- Bronze - Schema - Domain B
create database role if not exists "BRONZE"."SC__DOMAIN_B__OWNER"
  comment = 'Full access to the schema'
;
grant database role "BRONZE"."SC__DOMAIN_B__OWNER" to database role "BRONZE"."DB__OWNER";

create database role if not exists "BRONZE"."SC__DOMAIN_B__WRITER"
  comment = 'Write access to the schema'
;
grant database role "BRONZE"."SC__DOMAIN_B__WRITER" to database role "BRONZE"."DB__WRITER";
grant database role "BRONZE"."SC__DOMAIN_B__WRITER" to database role "BRONZE"."SC__DOMAIN_B__OWNER";

create database role if not exists "BRONZE"."SC__DOMAIN_B__READER"
  comment = 'Read-only access to the schema'
;
grant database role "BRONZE"."SC__DOMAIN_B__READER" to database role "BRONZE"."DB__READER";
grant database role "BRONZE"."SC__DOMAIN_B__READER" to database role "BRONZE"."SC__DOMAIN_B__WRITER";

create database role if not exists "BRONZE"."SC__DOMAIN_B__METADATA"
  comment = 'Metadata-only access to the schema'
;
grant database role "BRONZE"."SC__DOMAIN_B__METADATA" to database role "BRONZE"."DB__METADATA";
grant database role "BRONZE"."SC__DOMAIN_B__METADATA" to database role "BRONZE"."SC__DOMAIN_B__READER";

-- Silver - Schema - Domain B
create database role if not exists "SILVER"."SC__DOMAIN_B__OWNER"
  comment = 'Full access to the schema'
;
grant database role "SILVER"."SC__DOMAIN_B__OWNER" to database role "SILVER"."DB__OWNER";

create database role if not exists "SILVER"."SC__DOMAIN_B__WRITER"
  comment = 'Write access to the schema'
;
grant database role "SILVER"."SC__DOMAIN_B__WRITER" to database role "SILVER"."DB__WRITER";
grant database role "SILVER"."SC__DOMAIN_B__WRITER" to database role "SILVER"."SC__DOMAIN_B__OWNER";

create database role if not exists "SILVER"."SC__DOMAIN_B__READER"
  comment = 'Read-only access to the schema'
;
grant database role "SILVER"."SC__DOMAIN_B__READER" to database role "SILVER"."DB__READER";
grant database role "SILVER"."SC__DOMAIN_B__READER" to database role "SILVER"."SC__DOMAIN_B__WRITER";

create database role if not exists "SILVER"."SC__DOMAIN_B__METADATA"
  comment = 'Metadata-only access to the schema'
;
grant database role "SILVER"."SC__DOMAIN_B__METADATA" to database role "SILVER"."DB__METADATA";
grant database role "SILVER"."SC__DOMAIN_B__METADATA" to database role "SILVER"."SC__DOMAIN_B__READER";

-- Gold - Schema - Domain B
create database role if not exists "GOLD"."SC__DOMAIN_B__OWNER"
  comment = 'Full access to the schema'
;
grant database role "GOLD"."SC__DOMAIN_B__OWNER" to database role "GOLD"."DB__OWNER";

create database role if not exists "GOLD"."SC__DOMAIN_B__WRITER"
  comment = 'Write access to the schema'
;
grant database role "GOLD"."SC__DOMAIN_B__WRITER" to database role "GOLD"."DB__WRITER";
grant database role "GOLD"."SC__DOMAIN_B__WRITER" to database role "GOLD"."SC__DOMAIN_B__OWNER";

create database role if not exists "GOLD"."SC__DOMAIN_B__READER"
  comment = 'Read-only access to the schema'
;
grant database role "GOLD"."SC__DOMAIN_B__READER" to database role "GOLD"."DB__READER";
grant database role "GOLD"."SC__DOMAIN_B__READER" to database role "GOLD"."SC__DOMAIN_B__WRITER";

create database role if not exists "GOLD"."SC__DOMAIN_B__METADATA"
  comment = 'Metadata-only access to the schema'
;
grant database role "GOLD"."SC__DOMAIN_B__METADATA" to database role "GOLD"."DB__METADATA";
grant database role "GOLD"."SC__DOMAIN_B__METADATA" to database role "GOLD"."SC__DOMAIN_B__READER";

--------------------------------------------------
-- Databases Role Grants to Account Roles
--------------------------------------------------

-- Database ownership
grant database role "BRONZE"."DB__OWNER" to role "DATA_PLATFORM_MANAGER";
grant database role "SILVER"."DB__OWNER" to role "DATA_PLATFORM_MANAGER";
grant database role "GOLD"."DB__OWNER" to role "DATA_PLATFORM_MANAGER";

-- Bronze - Domain A
grant database role "BRONZE"."SC__DOMAIN_A__OWNER" to role "ENGINEER_DOMAIN_A";
grant database role "BRONZE"."SC__DOMAIN_A__METADATA" to role "METADATA_DOMAIN_A";

-- Bronze - Domain B
grant database role "BRONZE"."SC__DOMAIN_B__OWNER" to role "ENGINEER_DOMAIN_B";
grant database role "BRONZE"."SC__DOMAIN_B__METADATA" to role "METADATA_DOMAIN_B";

-- Silver - Domain A
grant database role "SILVER"."SC__DOMAIN_A__OWNER" to role "ENGINEER_DOMAIN_A";
grant database role "SILVER"."SC__DOMAIN_A__WRITER" to role "ANALYST_DOMAIN_A";
grant database role "SILVER"."SC__DOMAIN_A__METADATA" to role "METADATA_DOMAIN_A";

-- Silver - Domain B
grant database role "SILVER"."SC__DOMAIN_B__OWNER" to role "ENGINEER_DOMAIN_B";
grant database role "SILVER"."SC__DOMAIN_B__WRITER" to role "ANALYST_DOMAIN_B";
grant database role "SILVER"."SC__DOMAIN_B__METADATA" to role "METADATA_DOMAIN_B";

-- Gold - Domain A
grant database role "GOLD"."SC__DOMAIN_A__OWNER" to role "ENGINEER_DOMAIN_A";
grant database role "GOLD"."SC__DOMAIN_A__OWNER" to role "ANALYST_DOMAIN_A";
grant database role "GOLD"."SC__DOMAIN_A__WRITER" to role "ANALYST_DOMAIN_A";
grant database role "GOLD"."SC__DOMAIN_A__READER" to role "READER_DOMAIN_A";
grant database role "GOLD"."SC__DOMAIN_A__METADATA" to role "METADATA_DOMAIN_A";

-- Gold - Domain B
grant database role "GOLD"."SC__DOMAIN_B__OWNER" to role "ENGINEER_DOMAIN_B";
grant database role "GOLD"."SC__DOMAIN_B__OWNER" to role "ANALYST_DOMAIN_B";
grant database role "GOLD"."SC__DOMAIN_B__WRITER" to role "ANALYST_DOMAIN_B";
grant database role "GOLD"."SC__DOMAIN_B__READER" to role "READER_DOMAIN_B";
grant database role "GOLD"."SC__DOMAIN_B__METADATA" to role "METADATA_DOMAIN_B";

--------------------------------------------------
-- Databases Role Privilege Grants
--------------------------------------------------

-------------------------
-- Environment

-- Requires SECURITYADMIN for future-type grants
use role "SECURITYADMIN";

-------------------------
-- Databases roles - Schema-level Grants - Bronze - Domain A

-- Bronze - Grants - Domain A - Metadata
grant USAGE, MONITOR, create notebook on schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__METADATA";

grant REFERENCES on all tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__METADATA";
grant REFERENCES on all views in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__METADATA";
grant MONITOR on all dynamic tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__METADATA";
grant REFERENCES on all materialized views in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__METADATA";
grant REFERENCES on all iceberg tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__METADATA";
grant REFERENCES on all external tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__METADATA";
-- grant REFERENCES on all hybrid tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__METADATA"; -- Not supported at time of writing

grant REFERENCES on future tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__METADATA";
grant REFERENCES on future views in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__METADATA";
grant MONITOR on future dynamic tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__METADATA";
grant REFERENCES on future materialized views in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__METADATA";
grant REFERENCES on future iceberg tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__METADATA";
grant REFERENCES on future external tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__METADATA";
-- grant REFERENCES on future hybrid tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__METADATA"; -- Not supported at time of writing

-- Bronze - Grants - Domain A - Reader
grant SELECT on all tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";
grant SELECT on all views in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";
grant SELECT on all dynamic tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";
grant SELECT on all materialized views in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";
grant SELECT on all iceberg tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";
grant SELECT on all external tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";
-- grant SELECT on all hybrid tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER"; -- Not supported at time of writing
grant USAGE on all functions in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";
grant USAGE on all sequences in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";

grant SELECT on future tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";
grant SELECT on future views in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";
grant SELECT on future dynamic tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";
grant SELECT on future materialized views in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";
grant SELECT on future iceberg tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";
grant SELECT on future external tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";
-- grant SELECT on future hybrid tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER"; -- Not supported at time of writing
grant USAGE on future functions in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";
grant USAGE on future sequences in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__READER";

-- Bronze - Grants - Domain A - Writer
grant INSERT, UPDATE, TRUNCATE, DELETE on all tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__WRITER";
grant OPERATE on all dynamic tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__WRITER";
grant INSERT, UPDATE, TRUNCATE, DELETE on all iceberg tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__WRITER";
-- grant INSERT, UPDATE, TRUNCATE, DELETE on all hybrid tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__WRITER"; -- Not supported at time of writing
grant USAGE on all procedures in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__WRITER";
grant USAGE on all stages in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__WRITER";
grant USAGE on all file formats in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__WRITER";

grant INSERT, UPDATE, TRUNCATE, DELETE on future tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__WRITER";
grant OPERATE on future dynamic tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__WRITER";
grant INSERT, UPDATE, TRUNCATE, DELETE on future iceberg tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__WRITER";
-- grant INSERT, UPDATE, TRUNCATE, DELETE on future hybrid tables in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__WRITER"; -- Not supported at time of writing
grant USAGE on future procedures in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__WRITER";
grant USAGE on future stages in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__WRITER";
grant USAGE on future file formats in schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__WRITER";

-- Bronze - Grants - Domain A - Owner
grant ownership on schema "BRONZE"."DOMAIN_A" to database role "BRONZE"."SC__DOMAIN_A__OWNER" copy current grants;

-------------------------
-- Databases roles - Schema-level Grants - Silver - Domain A

-- Silver - Grants - Domain A - Metadata
grant USAGE, MONITOR, create notebook on schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__METADATA";

grant REFERENCES on all tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__METADATA";
grant REFERENCES on all views in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__METADATA";
grant MONITOR on all dynamic tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__METADATA";
grant REFERENCES on all materialized views in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__METADATA";
grant REFERENCES on all iceberg tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__METADATA";
grant REFERENCES on all external tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__METADATA";
-- grant REFERENCES on all hybrid tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__METADATA"; -- Not supported at time of writing

grant REFERENCES on future tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__METADATA";
grant REFERENCES on future views in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__METADATA";
grant MONITOR on future dynamic tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__METADATA";
grant REFERENCES on future materialized views in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__METADATA";
grant REFERENCES on future iceberg tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__METADATA";
grant REFERENCES on future external tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__METADATA";
-- grant REFERENCES on future hybrid tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__METADATA"; -- Not supported at time of writing

-- Silver - Grants - Domain A - Reader
grant SELECT on all tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";
grant SELECT on all views in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";
grant SELECT on all dynamic tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";
grant SELECT on all materialized views in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";
grant SELECT on all iceberg tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";
grant SELECT on all external tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";
-- grant SELECT on all hybrid tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER"; -- Not supported at time of writing
grant USAGE on all functions in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";
grant USAGE on all sequences in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";

grant SELECT on future tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";
grant SELECT on future views in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";
grant SELECT on future dynamic tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";
grant SELECT on future materialized views in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";
grant SELECT on future iceberg tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";
grant SELECT on future external tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";
-- grant SELECT on future hybrid tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER"; -- Not supported at time of writing
grant USAGE on future functions in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";
grant USAGE on future sequences in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__READER";

-- Silver - Grants - Domain A - Writer
grant INSERT, UPDATE, TRUNCATE, DELETE on all tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__WRITER";
grant OPERATE on all dynamic tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__WRITER";
grant INSERT, UPDATE, TRUNCATE, DELETE on all iceberg tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__WRITER";
-- grant INSERT, UPDATE, TRUNCATE, DELETE on all hybrid tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__WRITER"; -- Not supported at time of writing
grant USAGE on all procedures in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__WRITER";
grant USAGE on all stages in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__WRITER";
grant USAGE on all file formats in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__WRITER";

grant INSERT, UPDATE, TRUNCATE, DELETE on future tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__WRITER";
grant OPERATE on future dynamic tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__WRITER";
grant INSERT, UPDATE, TRUNCATE, DELETE on future iceberg tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__WRITER";
-- grant INSERT, UPDATE, TRUNCATE, DELETE on future hybrid tables in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__WRITER"; -- Not supported at time of writing
grant USAGE on future procedures in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__WRITER";
grant USAGE on future stages in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__WRITER";
grant USAGE on future file formats in schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__WRITER";

-- Silver - Grants - Domain A - Owner
grant ownership on schema "SILVER"."DOMAIN_A" to database role "SILVER"."SC__DOMAIN_A__OWNER" copy current grants;

-------------------------
-- Databases roles - Schema-level Grants - Gold - Domain A

-- Gold - Grants - Domain A - Metadata
grant USAGE, MONITOR, create notebook on schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__METADATA";

grant REFERENCES on all tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__METADATA";
grant REFERENCES on all views in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__METADATA";
grant MONITOR on all dynamic tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__METADATA";
grant REFERENCES on all materialized views in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__METADATA";
grant REFERENCES on all iceberg tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__METADATA";
grant REFERENCES on all external tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__METADATA";
-- grant REFERENCES on all hybrid tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__METADATA"; -- Not supported at time of writing

grant REFERENCES on future tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__METADATA";
grant REFERENCES on future views in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__METADATA";
grant MONITOR on future dynamic tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__METADATA";
grant REFERENCES on future materialized views in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__METADATA";
grant REFERENCES on future iceberg tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__METADATA";
grant REFERENCES on future external tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__METADATA";
-- grant REFERENCES on future hybrid tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__METADATA"; -- Not supported at time of writing

-- Gold - Grants - Domain A - Reader
grant SELECT on all tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";
grant SELECT on all views in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";
grant SELECT on all dynamic tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";
grant SELECT on all materialized views in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";
grant SELECT on all iceberg tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";
grant SELECT on all external tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";
-- grant SELECT on all hybrid tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER"; -- Not supported at time of writing
grant USAGE on all functions in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";
grant USAGE on all sequences in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";

grant SELECT on future tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";
grant SELECT on future views in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";
grant SELECT on future dynamic tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";
grant SELECT on future materialized views in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";
grant SELECT on future iceberg tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";
grant SELECT on future external tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";
-- grant SELECT on future hybrid tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER"; -- Not supported at time of writing
grant USAGE on future functions in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";
grant USAGE on future sequences in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__READER";

-- Gold - Grants - Domain A - Writer
grant INSERT, UPDATE, TRUNCATE, DELETE on all tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__WRITER";
grant OPERATE on all dynamic tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__WRITER";
grant INSERT, UPDATE, TRUNCATE, DELETE on all iceberg tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__WRITER";
-- grant INSERT, UPDATE, TRUNCATE, DELETE on all hybrid tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__WRITER"; -- Not supported at time of writing
grant USAGE on all procedures in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__WRITER";
grant USAGE on all stages in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__WRITER";
grant USAGE on all file formats in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__WRITER";

grant INSERT, UPDATE, TRUNCATE, DELETE on future tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__WRITER";
grant OPERATE on future dynamic tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__WRITER";
grant INSERT, UPDATE, TRUNCATE, DELETE on future iceberg tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__WRITER";
-- grant INSERT, UPDATE, TRUNCATE, DELETE on future hybrid tables in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__WRITER"; -- Not supported at time of writing
grant USAGE on future procedures in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__WRITER";
grant USAGE on future stages in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__WRITER";
grant USAGE on future file formats in schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__WRITER";

-- Gold - Grants - Domain A - Owner
grant ownership on schema "GOLD"."DOMAIN_A" to database role "GOLD"."SC__DOMAIN_A__OWNER" copy current grants;

-------------------------
-- Databases roles - Schema-level Grants - Bronze - Domain B

-- Bronze - Grants - Domain B - Metadata
grant USAGE, MONITOR, create notebook on schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__METADATA";

grant REFERENCES on all tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__METADATA";
grant REFERENCES on all views in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__METADATA";
grant MONITOR on all dynamic tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__METADATA";
grant REFERENCES on all materialized views in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__METADATA";
grant REFERENCES on all iceberg tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__METADATA";
grant REFERENCES on all external tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__METADATA";
-- grant REFERENCES on all hybrid tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__METADATA"; -- Not supported at time of writing

grant REFERENCES on future tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__METADATA";
grant REFERENCES on future views in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__METADATA";
grant MONITOR on future dynamic tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__METADATA";
grant REFERENCES on future materialized views in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__METADATA";
grant REFERENCES on future iceberg tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__METADATA";
grant REFERENCES on future external tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__METADATA";
-- grant REFERENCES on future hybrid tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__METADATA"; -- Not supported at time of writing

-- Bronze - Grants - Domain B - Reader
grant SELECT on all tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";
grant SELECT on all views in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";
grant SELECT on all dynamic tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";
grant SELECT on all materialized views in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";
grant SELECT on all iceberg tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";
grant SELECT on all external tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";
-- grant SELECT on all hybrid tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER"; -- Not supported at time of writing
grant USAGE on all functions in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";
grant USAGE on all sequences in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";

grant SELECT on future tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";
grant SELECT on future views in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";
grant SELECT on future dynamic tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";
grant SELECT on future materialized views in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";
grant SELECT on future iceberg tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";
grant SELECT on future external tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";
-- grant SELECT on future hybrid tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER"; -- Not supported at time of writing
grant USAGE on future functions in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";
grant USAGE on future sequences in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__READER";

-- Bronze - Grants - Domain B - Writer
grant INSERT, UPDATE, TRUNCATE, DELETE on all tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__WRITER";
grant OPERATE on all dynamic tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__WRITER";
grant INSERT, UPDATE, TRUNCATE, DELETE on all iceberg tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__WRITER";
-- grant INSERT, UPDATE, TRUNCATE, DELETE on all hybrid tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__WRITER"; -- Not supported at time of writing
grant USAGE on all procedures in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__WRITER";
grant USAGE on all stages in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__WRITER";
grant USAGE on all file formats in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__WRITER";

grant INSERT, UPDATE, TRUNCATE, DELETE on future tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__WRITER";
grant OPERATE on future dynamic tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__WRITER";
grant INSERT, UPDATE, TRUNCATE, DELETE on future iceberg tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__WRITER";
-- grant INSERT, UPDATE, TRUNCATE, DELETE on future hybrid tables in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__WRITER"; -- Not supported at time of writing
grant USAGE on future procedures in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__WRITER";
grant USAGE on future stages in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__WRITER";
grant USAGE on future file formats in schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__WRITER";

-- Bronze - Grants - Domain B - Owner
grant ownership on schema "BRONZE"."DOMAIN_B" to database role "BRONZE"."SC__DOMAIN_B__OWNER" copy current grants;

-------------------------
-- Databases roles - Schema-level Grants - Silver - Domain B

-- Silver - Grants - Domain B - Metadata
grant USAGE, MONITOR, create notebook on schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__METADATA";

grant REFERENCES on all tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__METADATA";
grant REFERENCES on all views in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__METADATA";
grant MONITOR on all dynamic tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__METADATA";
grant REFERENCES on all materialized views in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__METADATA";
grant REFERENCES on all iceberg tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__METADATA";
grant REFERENCES on all external tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__METADATA";
-- grant REFERENCES on all hybrid tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__METADATA"; -- Not supported at time of writing

grant REFERENCES on future tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__METADATA";
grant REFERENCES on future views in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__METADATA";
grant MONITOR on future dynamic tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__METADATA";
grant REFERENCES on future materialized views in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__METADATA";
grant REFERENCES on future iceberg tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__METADATA";
grant REFERENCES on future external tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__METADATA";
-- grant REFERENCES on future hybrid tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__METADATA"; -- Not supported at time of writing

-- Silver - Grants - Domain B - Reader
grant SELECT on all tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";
grant SELECT on all views in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";
grant SELECT on all dynamic tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";
grant SELECT on all materialized views in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";
grant SELECT on all iceberg tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";
grant SELECT on all external tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";
-- grant SELECT on all hybrid tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER"; -- Not supported at time of writing
grant USAGE on all functions in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";
grant USAGE on all sequences in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";

grant SELECT on future tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";
grant SELECT on future views in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";
grant SELECT on future dynamic tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";
grant SELECT on future materialized views in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";
grant SELECT on future iceberg tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";
grant SELECT on future external tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";
-- grant SELECT on future hybrid tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER"; -- Not supported at time of writing
grant USAGE on future functions in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";
grant USAGE on future sequences in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__READER";

-- Silver - Grants - Domain B - Writer
grant INSERT, UPDATE, TRUNCATE, DELETE on all tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__WRITER";
grant OPERATE on all dynamic tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__WRITER";
grant INSERT, UPDATE, TRUNCATE, DELETE on all iceberg tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__WRITER";
-- grant INSERT, UPDATE, TRUNCATE, DELETE on all hybrid tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__WRITER"; -- Not supported at time of writing
grant USAGE on all procedures in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__WRITER";
grant USAGE on all stages in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__WRITER";
grant USAGE on all file formats in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__WRITER";

grant INSERT, UPDATE, TRUNCATE, DELETE on future tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__WRITER";
grant OPERATE on future dynamic tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__WRITER";
grant INSERT, UPDATE, TRUNCATE, DELETE on future iceberg tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__WRITER";
-- grant INSERT, UPDATE, TRUNCATE, DELETE on future hybrid tables in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__WRITER"; -- Not supported at time of writing
grant USAGE on future procedures in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__WRITER";
grant USAGE on future stages in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__WRITER";
grant USAGE on future file formats in schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__WRITER";

-- Silver - Grants - Domain B - Owner
grant ownership on schema "SILVER"."DOMAIN_B" to database role "SILVER"."SC__DOMAIN_B__OWNER" copy current grants;

-------------------------
-- Databases roles - Schema-level Grants - Gold - Domain B

-- Gold - Grants - Domain B - Metadata
grant USAGE, MONITOR, create notebook on schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__METADATA";

grant REFERENCES on all tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__METADATA";
grant REFERENCES on all views in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__METADATA";
grant MONITOR on all dynamic tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__METADATA";
grant REFERENCES on all materialized views in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__METADATA";
grant REFERENCES on all iceberg tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__METADATA";
grant REFERENCES on all external tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__METADATA";
-- grant REFERENCES on all hybrid tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__METADATA"; -- Not supported at time of writing

grant REFERENCES on future tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__METADATA";
grant REFERENCES on future views in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__METADATA";
grant MONITOR on future dynamic tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__METADATA";
grant REFERENCES on future materialized views in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__METADATA";
grant REFERENCES on future iceberg tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__METADATA";
grant REFERENCES on future external tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__METADATA";
-- grant REFERENCES on future hybrid tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__METADATA"; -- Not supported at time of writing

-- Gold - Grants - Domain B - Reader
grant SELECT on all tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";
grant SELECT on all views in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";
grant SELECT on all dynamic tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";
grant SELECT on all materialized views in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";
grant SELECT on all iceberg tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";
grant SELECT on all external tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";
-- grant SELECT on all hybrid tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER"; -- Not supported at time of writing
grant USAGE on all functions in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";
grant USAGE on all sequences in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";

grant SELECT on future tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";
grant SELECT on future views in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";
grant SELECT on future dynamic tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";
grant SELECT on future materialized views in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";
grant SELECT on future iceberg tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";
grant SELECT on future external tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";
-- grant SELECT on future hybrid tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER"; -- Not supported at time of writing
grant USAGE on future functions in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";
grant USAGE on future sequences in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__READER";

-- Gold - Grants - Domain B - Writer
grant INSERT, UPDATE, TRUNCATE, DELETE on all tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__WRITER";
grant OPERATE on all dynamic tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__WRITER";
grant INSERT, UPDATE, TRUNCATE, DELETE on all iceberg tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__WRITER";
-- grant INSERT, UPDATE, TRUNCATE, DELETE on all hybrid tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__WRITER"; -- Not supported at time of writing
grant USAGE on all procedures in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__WRITER";
grant USAGE on all stages in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__WRITER";
grant USAGE on all file formats in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__WRITER";

grant INSERT, UPDATE, TRUNCATE, DELETE on future tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__WRITER";
grant OPERATE on future dynamic tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__WRITER";
grant INSERT, UPDATE, TRUNCATE, DELETE on future iceberg tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__WRITER";
-- grant INSERT, UPDATE, TRUNCATE, DELETE on future hybrid tables in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__WRITER"; -- Not supported at time of writing
grant USAGE on future procedures in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__WRITER";
grant USAGE on future stages in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__WRITER";
grant USAGE on future file formats in schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__WRITER";

-- Gold - Grants - Domain B - Owner
grant ownership on schema "GOLD"."DOMAIN_B" to database role "GOLD"."SC__DOMAIN_B__OWNER" copy current grants;
