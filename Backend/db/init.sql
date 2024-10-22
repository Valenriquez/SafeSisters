-- Create the database if it does not exist
DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_database WHERE datname = 'safesister') THEN
      CREATE DATABASE safesister;
   END IF;
END $$;

-- Create a new user
DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'apiuser') THEN
      CREATE ROLE apiuser WITH LOGIN PASSWORD '12345';
   END IF;
END $$;

-- Grant all privileges to the new user
ALTER ROLE apiuser WITH SUPERUSER CREATEDB CREATEROLE REPLICATION;

-- Allow the user to connect from any host ('%' means any IP address)
ALTER ROLE apiuser SET client_encoding TO 'utf8';
ALTER ROLE apiuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE apiuser SET timezone TO 'UTC';

-- Ensure user can connect from any host
GRANT ALL PRIVILEGES ON DATABASE safesister TO apiuser;
