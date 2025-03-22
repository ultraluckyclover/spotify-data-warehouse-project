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
	mode BOOLEAN,
	time_signature SMALLINT,
	key SMALLINT,
	duration_ms INT
);

INSERT INTO silver.artists (artist_name)
SELECT DISTINCT TRIM(UNNEST(STRING_TO_ARRAY(track_artist, ','))) AS artist_name
FROM bronze.unstructured_data;

INSERT INTO silver.albums (album_name, album_release_year)
SELECT DISTINCT track_album_name, track_release_year
FROM bronze.unstructured_data
ON CONFLICT (album_name, album_release_year) DO NOTHING;

INSERT INTO silver.genres (genre_name)
SELECT DISTINCT playlist_genre
FROM bronze.unstructured_data;

INSERT INTO silver.subgenres (subgenre_name, genre_id)
SELECT DISTINCT 
b.playlist_subgenre,
g.genre_id
FROM bronze.unstructured_data b
JOIN silver.genres g ON b.playlist_genre = g.genre_name;

INSERT INTO silver.tracks (
track_name,
album_id,
energy,
tempo,
danceability,
loudness,
liveness,
valence,
speechiness,
instrumentalness,
acousticness,
mode,
time_signature,
key,
duration_ms
)
SELECT 
b.track_name,
a.album_id,
b.energy,
b.tempo,
b.danceability,
b.loudness,
b.liveness,
b.valence,
b.speechiness,
b.instrumentalness,
b.acousticness,
b.mode::BOOLEAN,
b.time_signature,
b.key,
b.duration_ms
FROM bronze.unstructured_data b
JOIN silver.albums a ON b.track_album_name = a.album_name
ON CONFLICT DO NOTHING;
