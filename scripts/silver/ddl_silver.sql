DROP TABLE IF EXISTS silver.artists;
CREATE TABLE silver.artists (
	artist_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	artist_name TEXT NOT NULL UNIQUE
);

DROP TABLE IF EXISTS silver.albums CASCADE;
CREATE TABLE silver.albums (
	album_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	album_name TEXT NOT NULL UNIQUE,
	album_release_year INT NOT NULL
);

DROP TABLE IF EXISTS silver.genres CASCADE;
CREATE TABLE silver.genres (
	genre_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	genre_name TEXT
);

DROP TABLE IF EXISTS silver.subgenres CASCADE;
CREATE TABLE silver.subgenres (
	subgenre_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	subgenre_name TEXT,
	genre_id INT REFERENCES silver.genres(genre_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS silver.tracks CASCADE;
CREARE TABLE silver.tracks (
	track_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	track_name TEXT NOT NULL,
	album_id INT REFERENCES silver.albums(album_id) ON DELETE CASCADE,
	energy REAL,
	tempo SMALLINT,
	danceability NUMERIC(4,3),
	loudness NUMERIC(5,3),
	liveness NUMERIC(4,3),
	valence NUMERIC(4,3),
	speechiness REAL,
	instrumentalness REAL,
	acousticness NUMERIC(6,5),
	mode INT,
	time_signature INT,
	key INT,
	duration_ms INT
);

