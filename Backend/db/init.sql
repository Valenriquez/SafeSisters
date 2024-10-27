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

-- Connect to the newly created database
\c safesister;

-- Create the tables

-- Table of users
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table of user locations
CREATE TABLE userLocation (
    location_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    latitude DECIMAL(9, 6) NOT NULL,
    longitude DECIMAL(9, 6) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Table of circles
CREATE TABLE circles (
    circle_id SERIAL PRIMARY KEY,
    owner_id INT NOT NULL,
    circle_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Table of user circles
CREATE TABLE userCircles (
    user_circle_id SERIAL PRIMARY KEY,
    circle_id INT NOT NULL,
    user_id INT NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (circle_id) REFERENCES circles(circle_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Table of notifications
CREATE TABLE notifications (
    notification_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    notification_type VARCHAR(50) NOT NULL,
    location_id INT,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES userLocation(location_id) ON DELETE SET NULL
);

-- Table of danger zones
CREATE TABLE dangerZones (
    zone_id SERIAL PRIMARY KEY,
    location_id INT NOT NULL,
    report_count INT DEFAULT 0,
    severity VARCHAR(50),  -- Puede ser bajo, medio, alto
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES userLocation(location_id) ON DELETE CASCADE
);
