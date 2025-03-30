-- ENTITY TABLES

DROP TABLE IF EXISTS silver.artists;
CREATE TABLE silver.artists (
	artist_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	artist_name TEXT NOT NULL UNIQUE
);

DROP TABLE IF EXISTS silver.albums CASCADE;
CREATE TABLE silver.albums (
	album_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	album_name TEXT NOT NULL,
	album_release_year INT NOT NULL,
	CONSTRAINT albums_name_and_release_year UNIQUE (album_name, album_release_year)
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
CREATE TABLE silver.tracks (
	track_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	track_name TEXT NOT NULL UNIQUE,
	album_id INT REFERENCES silver.albums(album_id) ON DELETE CASCADE,
	energy REAL,
	tempo SMALLINT,
	danceability REAL,
	loudness REAL,
	liveness REAL,
	valence REAL,
	speechiness REAL,
	instrumentalness REAL,
	acousticness REAL,
	mode TEXT,
	time_signature SMALLINT,
	key TEXT,
	duration_ms INT
);

-- JOIN TABLES

DROP TABLE IF EXISTS silver.track_artist;
CREATE TABLE silver.track_artist (
track_id INT REFERENCES silver.tracks(track_id) ON DELETE CASCADE,
artist_id INT REFERENCES silver.artists(artist_id) ON DELETE CASCADE,
PRIMARY KEY (track_id, artist_id)
);

DROP TABLE IF EXISTS silver.track_genre;
CREATE TABLE silver.track_genre (
track_id INT REFERENCES silver.tracks(track_id) ON DELETE CASCADE,
genre_id INT REFERENCES silver.genres(genre_id) ON DELETE CASCADE,
PRIMARY KEY (track_id, genre_id)
);

DROP TABLE IF EXISTS silver.album_artist;
CREATE TABLE silver.album_artist (
album_id INT REFERENCES silver.albums(album_id) ON DELETE CASCADE,
artist_id INT REFERENCES silver.artists(artist_id) ON DELETE CASCADE,
PRIMARY KEY (album_id, artist_id)
);
