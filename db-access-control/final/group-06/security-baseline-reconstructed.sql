-- Reconstructed verified PUBLIC restrictions; not an execution transcript.
-- Fresh dedicated test database only; apply alongside approved role grants,
-- ownership setup and the matching connection-policy snippet.
-- Review before use. Existing project grants must not be blindly changed.
REVOKE ALL ON DATABASE "car_rental_db" FROM PUBLIC;
REVOKE CREATE ON SCHEMA "public" FROM PUBLIC;
