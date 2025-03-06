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

