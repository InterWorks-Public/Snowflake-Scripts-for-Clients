# InterWorks Snowflake Rapid Start - Example Databases and Roles

This folder contains a script to deploy a template set of example databases and roles into your Snowflake environment. You can of course modify this however you wish.

## Deployment Script

The example databases and roles were deployed using this script:

[Example Databases and Roles](<Example Databases and Roles.sql>)

## Deployed Databases

The databases that have been deployed are represented here:

![Example Databases and Schemas](<images/Example Databases and Schemas.png>)

In short, we have three tiers of database (bronze, silver and gold) which each contain dedicated schemas for three domains: A, B and C.

## Deployed Database Roles

Within each of the above databases, a database role structure has been deployed to simply access control. Admittedly, I use the word "simplify" here since it is simpler once you are used to it, but it can be confusing to wrap your head around at first.

![Example Database-Role Hierarchy](<images/Example Database-Role Hierarchy.png>)

The key features here are:

- Specific, dedicated roles to facilitate centralised access control for all objects in each schema:
  - Owner
    - Ownership, and thus full access, on the schema
    - Inherits all Writer privileges, too
  - Writer:
    - Insert/update/truncate/delete data in all tables in the schema
    - Access all data stages in the schema
    - Execute all procedures in the schema
    - Effectively, this role is intended to let somebody facilitate data processes without allowing them to create any new objects
    - Inherits all Reader privileges, too
  - Reader:
    - Read-only access on all tables and views in the schema
    - Execute all functions in the schema
    - Inherits all Metadata privileges, too
  - Metadata:
    - Metadata-only access on all tables and views in the schema
- Specific, dedicated roles to facilitate centralised access control at the database level, by inheriting all schema-level roles of the same type:
  - `DB__OWNER`
    - `SC__DOMAIN_A__OWNER`
    - `SC__DOMAIN_B__OWNER`
    - `SC__DOMAIN_C__OWNER`
  - `DB__WRITER`
    - `SC__DOMAIN_A__WRITER`
    - `SC__DOMAIN_B__WRITER`
    - `SC__DOMAIN_C__WRITER`
  - `DB__READER`
    - `SC__DOMAIN_A__READER`
    - `SC__DOMAIN_B__READER`
    - `SC__DOMAIN_C__READER`
  - `DB__METADATA`
    - `SC__DOMAIN_A__METADATA`
    - `SC__DOMAIN_B__METADATA`
    - `SC__DOMAIN_C__METADATA`

## Deployed Roles

The role hierarchy that has been deployed is represented here:

![Example Role Hierarchy](<images/Example Role Hierarchy.png>)

In short, we have platform-wide engineers, analysts, readers and metadata-only roles that span all domains, then a separate tree for any domain-specific restrictions.

The roles themselves map to the database roles in the following ways.

|   Role   |  BRONZE  |  SILVER  |   GOLD   |
| :------: | :------: | :------: | :------: |
| Engineer |  Owner   |  Owner   |  Owner   |
| Analyst  |          |  Writer  |  Owner   |
|  Reader  |          |          |  Reader  |
| Metadata | Metadata | Metadata | Metadata |
