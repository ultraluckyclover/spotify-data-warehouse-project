/*
=============================================
Create table for raw data in bronze layer
=============================================

This script creates a new table called unstructured_data in the bronze
layer after checking if it already exists.

To maintain the full precision of the energy-acousticness columns, 
I defined them as numeric data types. While this increases storage 
requirements and query times, I decided it was an acceptable trade-off 
since the data is only being ingested once from an Excel sheet. This 
approach will allow me to normalize the data in the silver layer without 
sacrificing precision.


WARNING: 
This script will drop the entire 'bronze.unstructured_data' table if 
it already exists. All data in the table will be permanently deleted. 
Proceed with caution and ensure you have the proper backups before 
running this script.

*/

DROP TABLE IF EXISTS bronze.unstructured_data;

CREATE TABLE bronze.unstructured_data(
	id SERIAL PRIMARY KEY,
	track_name TEXT,
	track_album_name TEXT,
	track_artist TEXT,
	track_release_year INT,
	track_popularity INT,
	playlist_genre TEXT,
	playlist_subgenre TEXT,
	energy NUMERIC,
	tempo NUMERIC,
	danceability NUMERIC,
	loudness NUMERIC,
	liveness NUMERIC,	
	valence NUMERIC,
	speechiness NUMERIC,
	instrumentalness NUMERIC,
	acousticness NUMERIC,
	mode INT,
	time_signature INT,
	key INT,
	duration_ms INT
);

