CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
BEGIN

	RAISE LOG 'Loading silver layer...';

	BEGIN

		RAISE LOG 'Loading entity tables...';
		
		RAISE LOG 'Truncating table: silver.artists';
		TRUNCATE TABLE silver.artists RESTART IDENTITY CASCADE;
	
		RAISE LOG 'Loading table: silver.artists';
		INSERT INTO silver.artists (artist_name)
		SELECT DISTINCT TRIM(UNNEST(STRING_TO_ARRAY(track_artist, ','))) AS artist_name
		FROM bronze.unstructured_data;
		RAISE LOG 'silver.artists loaded successfully!';
	
		RAISE LOG 'Truncating table: silver.albums';	
		TRUNCATE TABLE silver.albums RESTART IDENTITY CASCADE;
	
		RAISE LOG 'Loading table: silver.albums';
		INSERT INTO silver.albums (album_name, album_release_year)
		SELECT DISTINCT track_album_name, track_release_year
		FROM bronze.unstructured_data
		ON CONFLICT (album_name, album_release_year) DO NOTHING;
	
		RAISE LOG 'silver.albums loaded successfully!';
	
		RAISE LOG 'Truncating table: silver.genres';
		TRUNCATE TABLE silver.genres RESTART IDENTITY CASCADE;
	
		RAISE LOG 'Loading table: silver.genres';
		INSERT INTO silver.genres (genre_name)
		SELECT DISTINCT playlist_genre
		FROM bronze.unstructured_data;
		RAISE LOG 'silver.genres loaded successfully!';
	
		RAISE LOG 'Truncating table: silver.subgenres';
		TRUNCATE TABLE silver.subgenres RESTART IDENTITY CASCADE;
	
		RAISE LOG 'Loading table: silver.subgenres';
		INSERT INTO silver.subgenres (subgenre_name, genre_id)
		SELECT DISTINCT 
		b.playlist_subgenre,
		g.genre_id
		FROM bronze.unstructured_data b
		JOIN silver.genres g ON b.playlist_genre = g.genre_name;
		RAISE LOG 'silver.subgenres loaded successfully!';
	
		RAISE LOG 'Truncating table: silver.tracks';
		TRUNCATE TABLE silver.tracks RESTART IDENTITY CASCADE;
	
		RAISE LOG 'Loading table: silver.tracks';
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
		RAISE LOG 'silver.tracks loaded successfully!';
	
		RAISE LOG 'Loading junction tables...';
	
		RAISE LOG 'Creating temporary table...';
		DROP TABLE IF EXISTS temp_artists;
		CREATE TEMPORARY TABLE temp_artists AS 
		SELECT 
		track_name,
		track_album_name,
		TRIM(UNNEST(STRING_TO_ARRAY(track_artist, ','))) AS raw_artist_name
		FROM bronze.unstructured_data;
		RAISE LOG 'Temporary table created and loaded successfully!';
	
		RAISE LOG 'Truncating table: silver.track_artist';
		TRUNCATE TABLE silver.track_artist;
		
		RAISE LOG 'Loading table: silver.track_artist';
		INSERT INTO silver.track_artist (track_id, artist_id)
		SELECT t.track_id, a.artist_id
		FROM temp_artists ta
		JOIN silver.tracks t ON ta.track_name = t.track_name
		JOIN silver.artists a ON ta.raw_artist_name = a.artist_name
		ON CONFLICT (track_id, artist_id) DO NOTHING;
		RAISE LOG 'silver.track_artist loaded successfully!';
	
	
		RAISE LOG 'Truncating table: silver.track_genre';
		TRUNCATE TABLE silver.track_genre;
		
		RAISE LOG 'Loading table: silver.track_genre';
		INSERT INTO silver.track_genre (track_id, genre_id)
		SELECT t.track_id, g.genre_id
		FROM bronze.unstructured_data b
		JOIN silver.tracks t ON b.track_name = t.track_name
		JOIN silver.genres g ON b.playlist_genre = g.genre_name
		ON CONFLICT (track_id, genre_id) DO NOTHING;
		RAISE LOG 'silver.track_genre loaded successfully!';
	
	
		RAISE LOG 'Truncating table: silver.album_artist';
		TRUNCATE TABLE silver.album_artist;
		
		RAISE LOG 'Loading table: silver.album_artist';
		INSERT INTO silver.album_artist (album_id, artist_id)
		SELECT alb.album_id, art.artist_id
		FROM temp_artists ta
		JOIN silver.albums alb ON ta.track_album_name = alb.album_name
		JOIN silver.artists art ON ta.raw_artist_name = art.artist_name
		ON CONFLICT (album_id, artist_id) DO NOTHING;
		RAISE LOG 'silver.album_artist loaded successfully!';
	EXCEPTION
		WHEN OTHERS THEN
			RAISE EXCEPTION 'Error state: %, Error msg: %', SQLSTATE, SQLERRM;
	END;
END;
$$;

