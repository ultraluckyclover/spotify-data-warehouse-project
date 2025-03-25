-- ENTITY TABLES
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

-- JUNCTION TABLES

CREATE TEMPORARY TABLE temp_artists AS 
SELECT 
track_name, 
TRIM(UNNEST(STRING_TO_ARRAY(track_artist, ','))) AS raw_artist_name
FROM bronze.unstructured_data;

INSERT INTO silver.track_artist (track_id, artist_id)
SELECT t.track_id, a.artist_id
FROM temp_artists ta
JOIN silver.tracks t ON ta.track_name = t.track_name
JOIN silver.artists a ON ta.raw_artist_name = a.artist_name
ON CONFLICT (track_id, artist_id) DO NOTHING;
