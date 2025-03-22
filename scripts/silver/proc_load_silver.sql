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
