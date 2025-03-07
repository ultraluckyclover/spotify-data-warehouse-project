-- This load procedure works as long as your csv file is accessible to the PostgreSQL server
-- Otherwise, load from the client side in psql using \copy or using pgAdmin's import tool

CREATE OR REPLACE PROCEDURE bronze.load_bronze
LANGUAGE plpgsql
AS $$
BEGIN
	-- Clear data from table
	TRUNCATE TABLE bronze.unstructured_data;
	
	-- Load data to table
	COPY bronze.unstructured_data
	FROM '/path/to/your/file.csv'
	DELIMITER ','
	CSV HEADER;
END;
$$;
