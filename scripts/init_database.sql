/*
=============================
Create database and schemas
=============================

This script creates a new database called SpotifyDataWarehouse after checking if it 
already exists. It also sets up three schemas within the database called 'bronze', 
'silver', and 'gold'.

WARNING: 
This script will drop the entire 'SpotifyDataWarehouse' database if 
it already exists. All data in the database will be permanently deleted. 
Proceed with caution and ensure you have the proper backups before 
running this script.

*/


-- Drop the database 

DROP DATABASE IF EXISTS SpotifyDataWarehouse;

-- Create the database with script (below) or manually in pgAdmin

CREATE DATABASE SpotifyDataWarehouse;

-- Connect to SpotifyDataWarehouse using command line (below) or manually in pgAdmin

\c SpotifyDataWarehouse; 

-- Create schemas

CREATE SCHEMA bronze;

CREATE SCHEMA silver;

CREATE SCHEMA gold;
