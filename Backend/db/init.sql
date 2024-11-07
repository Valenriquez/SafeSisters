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
ALTER ROLE apiuser SET client_encoding TO 'utf8';
ALTER ROLE apiuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE apiuser SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE safesister TO apiuser;

-- Connect to the database
\c safesister;

-- Create enum types for status and severity
CREATE TYPE user_status AS ENUM ('active', 'inactive', 'blocked');
CREATE TYPE severity_level AS ENUM ('bajo', 'medio', 'alto');
CREATE TYPE notification_type AS ENUM ('DANGER_ZONE_ALERT', 'CIRCLE_INVITE', 'CIRCLE_JOIN', 'EMERGENCY_ALERT');
CREATE TYPE report_status AS ENUM ('pending', 'resolved', 'in_progress');

-- Create the tables
-- Users table with additional fields
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    status user_status DEFAULT 'active',
    profile_picture_url TEXT,
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- User locations table with indexes
CREATE TABLE userLocation (
    location_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    latitude DECIMAL(9, 6) NOT NULL,
    longitude DECIMAL(9, 6) NOT NULL,
    accuracy DECIMAL(10, 2),
    battery_level INT,
    is_charging BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE userLocation ADD CONSTRAINT unique_user_id UNIQUE (user_id);

-- Create index for faster location queries
CREATE INDEX idx_user_location ON userLocation (user_id, latitude, longitude);

-- Circles table with additional metadata
CREATE TABLE circles (
    circle_id SERIAL PRIMARY KEY,
    owner_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    circle_name VARCHAR(100) NOT NULL,
    description TEXT,
    max_members INT DEFAULT 10,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User circles with role management
CREATE TABLE userCircles (
    user_circle_id SERIAL PRIMARY KEY,
    circle_id INT NOT NULL REFERENCES circles(circle_id) ON DELETE CASCADE,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    role VARCHAR(20) DEFAULT 'member',
    invitation_status VARCHAR(20) DEFAULT 'pending',
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(circle_id, user_id)
);

-- Notifications table with additional fields
CREATE TABLE notifications (
    notification_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    notification_type notification_type NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    location_id INT REFERENCES userLocation(location_id) ON DELETE SET NULL,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP
);

-- Danger zones table with default radius and location_id column
CREATE TABLE dangerZones (
    zone_id SERIAL PRIMARY KEY,
    latitude DECIMAL(9, 6) NOT NULL,
    longitude DECIMAL(9, 6) NOT NULL,
    radius DECIMAL(10, 2) DEFAULT 100.00, -- Default radio de 100 metros
    report_count INT DEFAULT 0,
    severity severity_level DEFAULT 'medio',
    description TEXT NOT NULL,
    reported_by INT REFERENCES users(user_id),
    is_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP -- Para zonas temporales
);

-- Crear un índice espacial para las zonas de peligro basado en latitud y longitud
CREATE INDEX idx_dangerzones_location ON dangerZones USING gist (point(latitude, longitude));

-- Create table for danger zone reports
CREATE TABLE dangerZoneReports (
    report_id SERIAL PRIMARY KEY,
    zone_id INT REFERENCES dangerZones(zone_id) ON DELETE CASCADE,
    reporter_id INT REFERENCES users(user_id) ON DELETE SET NULL,
    description TEXT,
    evidence_url TEXT,
    status report_status DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Function to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updating timestamps
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_userlocation_updated_at
    BEFORE UPDATE ON userLocation
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_circles_updated_at
    BEFORE UPDATE ON circles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_usercircles_updated_at
    BEFORE UPDATE ON userCircles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_dangerzones_updated_at
    BEFORE UPDATE ON dangerZones
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Function to find nearby danger zones (updated version)
CREATE OR REPLACE FUNCTION find_nearby_danger_zones(
    user_lat DECIMAL,
    user_lon DECIMAL
) RETURNS TABLE (
    zone_id INTEGER,
    distance DECIMAL,
    description TEXT,
    severity severity_level,
    radius DECIMAL,
    report_count INTEGER,
    is_verified BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        dz.zone_id,
        (6371000 * acos(cos(radians(user_lat)) * cos(radians(dz.latitude)) * 
        cos(radians(dz.longitude) - radians(user_lon)) + 
        sin(radians(user_lat)) * sin(radians(dz.latitude))))::DECIMAL AS distance,
        dz.description,
        dz.severity,
        dz.radius,
        dz.report_count,
        dz.is_verified
    FROM dangerZones dz
    WHERE (6371000 * acos(cos(radians(user_lat)) * cos(radians(dz.latitude)) * 
           cos(radians(dz.longitude) - radians(user_lon)) + 
           sin(radians(user_lat)) * sin(radians(dz.latitude)))) <= dz.radius
    AND (dz.expires_at IS NULL OR dz.expires_at > CURRENT_TIMESTAMP)
    ORDER BY distance;
END;
$$ LANGUAGE plpgsql;

-- Grant necessary permissions to apiuser
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO apiuser;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO apiuser;

-- Example inserts for testing
INSERT INTO users (username, email, phone) 
VALUES ('test_user', 'test@example.com', '+1234567890');

INSERT INTO dangerZones (latitude, longitude, description, severity) 
VALUES 
    (19.4326, -99.1332, 'Zona de alto riesgo', 'alto'),
    (19.4320, -99.1338, 'Zona de riesgo medio', 'medio');
