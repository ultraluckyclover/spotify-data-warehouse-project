-- This load procedure works as long as your csv file is accessible to the PostgreSQL server.
-- Otherwise, load from the client side in psql using \copy or using pgAdmin's import tool.

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
BEGIN
	RAISE LOG 'Loading bronze layer...';
	
	BEGIN 
		RAISE LOG 'Truncating table: bronze.unstructured_data';
		TRUNCATE TABLE bronze.unstructured_data;

		RAISE LOG 'Loading table: bronze.unstructured_data';
		COPY bronze.unstructured_data
		FROM '/path/to/your/file.csv'
		DELIMITER ','
		CSV HEADER;
		
		RAISE LOG 'Bronze layer loaded successfully!';

	EXCEPTION
		WHEN OTHERS THEN 
			RAISE EXCEPTION 'Error state: %, Error Msg: %', SQLSTATE, SQLERRM;
	END;
END;
$$;
