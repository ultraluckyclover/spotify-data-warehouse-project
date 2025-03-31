-- +++++++++++++++++++++++++++++++++
-- 			ENTITY TABLES
-- +++++++++++++++++++++++++++++++++

--==================================
--			silver.tracks
--==================================

-- Checks for duplicates or NULLs for tracks/artist
SELECT track_name, album_id, COUNT(*) FROM silver.tracks
GROUP BY track_name, album_id
HAVING COUNT(*) > 1 OR track_name IS NULL OR album_id IS NULL;

-- Check NULLs for track metrics
SELECT * FROM silver.tracks WHERE
track_id IS NULL
OR energy IS NULL 
OR tempo IS NULL 
OR danceability IS NULL 
OR loudness IS NULL 
OR liveness IS NULL 
OR valence IS NULL
OR speechiness IS NULL 
OR instrumentalness IS NULL 
OR acousticness IS NULL 
OR mode IS NULL 
OR time_signature IS NULL 
OR key IS NULL 
OR duration_ms IS NULL;

-- Checking for unwanted spaces
SELECT track_name FROM silver.tracks
WHERE track_name != TRIM(track_name);

SELECT key FROM silver.tracks
WHERE key != TRIM(key);

SELECT mode FROM silver.tracks
WHERE mode != TRIM(mode);


--===================================
--			silver.albums
--===================================

-- Checking for duplicates or NULLs
SELECT album_name, album_release_year, COUNT(*) FROM silver.albums
GROUP BY album_name, album_release_year
HAVING COUNT(*) > 1 OR album_name IS NULL OR album_release_year IS NULL;

-- Checking for unwanted spaces
SELECT album_name FROM silver.albums
WHERE album_name != TRIM(album_name);

-- Checking for valid year
SELECT * FROM silver.albums
WHERE CAST(album_release_year AS TEXT) !~ '^[0-9]{4}$'
OR album_release_year NOT BETWEEN 1900 AND EXTRACT(YEAR FROM CURRENT_DATE);


--===================================
--			silver.artists
--===================================

-- Checking for duplicates or NULLs
SELECT artist_name, COUNT(*) FROM silver.artists
GROUP BY artist_name
HAVING COUNT(*) > 1 OR artist_name IS NULL;

-- Checking for unwanted spaces
SELECT artist_name FROM silver.artists
WHERE artist_name != TRIM(artist_name);

--===================================
--			silver.genres
--===================================

-- Checking for duplicates or NULLs
SELECT genre_name, COUNT(*) FROM silver.genres
GROUP BY genre_name
HAVING COUNT(*) > 1 OR 	genre_name IS NULL;

-- Checking for unwanted spaces
SELECT genre_name FROM silver.genres
WHERE genre_name != TRIM(genre_name);

--=====================================
--			silver.subgenres
--=====================================

-- Checking for duplicates or NULLs
SELECT subgenre_name, genre_id, COUNT(*) FROM silver.subgenres
GROUP BY subgenre_name, genre_id
HAVING COUNT(*) > 1 OR 	subgenre_name IS NULL OR genre_id IS NULL;

-- Checking for unwanted spaces
SELECT subgenre_name FROM silver.subgenres
WHERE subgenre_name != TRIM(subgenre_name);



-- +++++++++++++++++++++++++++++++++
-- 			JUNCTION TABLES
-- +++++++++++++++++++++++++++++++++

--=====================================
--			silver.album_artist
--=====================================

-- Checking for duplicates or NULLs
SELECT album_id, artist_id, COUNT(*) FROM silver.album_artist
GROUP BY album_id, artist_id
HAVING COUNT(*) > 1 OR album_id IS NULL OR artist_id IS NULL;

--=====================================
--			silver.track_artist
--=====================================

-- Checking for duplicates or NULLs
SELECT track_id, artist_id, COUNT(*) FROM silver.track_artist
GROUP BY track_id, artist_id
HAVING COUNT(*) > 1 OR track_id IS NULL OR artist_id IS NULL;

--=====================================
--			silver.track_genre
--=====================================

-- Checking for duplicates or NULLs
SELECT track_id, genre_id, COUNT(*) FROM silver.track_genre
GROUP BY track_id, genre_id
HAVING COUNT(*) > 1 OR track_id IS NULL OR genre_id IS NULL;
