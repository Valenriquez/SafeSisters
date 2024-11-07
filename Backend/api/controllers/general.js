// controllers/general.js
const client = require('../db/pg');

class General {
    // Función para generar una ubicación aleatoria en Monterrey
    async generateRandomLocation(req, res) {
        try {
            const { user_id } = req.body;

            if (!user_id) {
                return res.status(400).json({ error: "User ID is required" });
            }

            // Verificar si el usuario existe
            const userCheck = await client.query('SELECT user_id FROM users WHERE user_id = $1', [user_id]);
            if (userCheck.rows.length === 0) {
                return res.status(404).json({ error: "User not found" });
            }

            const minLat = 25.3384; // Latitud mínima aproximada de Monterrey
            const maxLat = 25.5384; // Latitud máxima aproximada de Monterrey
            const minLong = -100.9922; // Longitud mínima aproximada de Monterrey
            const maxLong = -100.8322; // Longitud máxima aproximada de Monterrey

            // Generar valores aleatorios de latitud y longitud dentro del rango
            const latitude = Number((Math.random() * (maxLat - minLat) + minLat).toFixed(6));
            const longitude = Number((Math.random() * (maxLong - minLong) + minLong).toFixed(6));

            // Generar valores aleatorios para los nuevos campos
            const accuracy = Number((Math.random() * 20 + 5).toFixed(2)); // Precisión entre 5 y 25 metros
            const battery_level = Math.floor(Math.random() * 100); // Nivel de batería entre 0 y 100
            const is_charging = Math.random() > 0.7; // 30% de probabilidad de estar cargando

            // Insertar la ubicación aleatoria con los nuevos campos
            const locationQuery = `
                INSERT INTO userLocation (
                    user_id, 
                    latitude, 
                    longitude, 
                    accuracy, 
                    battery_level, 
                    is_charging
                )
                VALUES ($1, $2, $3, $4, $5, $6)
                RETURNING 
                    location_id, 
                    latitude, 
                    longitude, 
                    accuracy, 
                    battery_level, 
                    is_charging,
                    created_at;
            `;

            const result = await client.query(locationQuery, [
                user_id, 
                latitude, 
                longitude, 
                accuracy, 
                battery_level, 
                is_charging
            ]);

            res.status(201).json({
                message: "Location added successfully",
                location: result.rows[0],
            });
        } catch (error) {
            console.error("Error generating random location:", error);
            res.status(500).json({ 
                error: "An error occurred while generating and saving the location",
                details: process.env.NODE_ENV === 'development' ? error.message : undefined
            });
        }
    }

    async addDangerZone(req, res) {
        try {
            // Generar latitud aleatoria dentro del rango de Monterrey
            const minLat = 25.3384; // Latitud mínima aproximada de Monterrey
            const maxLat = 25.5384; // Latitud máxima aproximada de Monterrey
            const latitude = Number((Math.random() * (maxLat - minLat) + minLat).toFixed(6));

            // Generar longitud aleatoria dentro del rango de Monterrey
            const minLong = -100.9922; // Longitud mínima aproximada de Monterrey
            const maxLong = -100.8322; // Longitud máxima aproximada de Monterrey
            const longitude = Number((Math.random() * (maxLong - minLong) + minLong).toFixed(6));

            // Radio aleatorio entre 0 y 100 metros
            const radius = Number((Math.random() * 100).toFixed(2));

            // Número aleatorio de reportes entre 0 y 10
            const report_count = Math.floor(Math.random() * 11);

            // Severidad aleatoria
            const severities = ['bajo', 'medio', 'alto'];
            const severity = severities[Math.floor(Math.random() * severities.length)];

            // Descripción aleatoria
            const descriptions = [
                "Zona con reportes frecuentes de acoso callejero",
                "Área con múltiples incidentes de violencia de género",
                "Sector con antecedentes de asaltos a mujeres",
                "Zona reportada por intentos de secuestro",
                "Área con poca iluminación y reportes de acoso"
            ];
            const description = descriptions[Math.floor(Math.random() * descriptions.length)];

            // Fecha de expiración en 1 año
            const expires_at = new Date();
            expires_at.setFullYear(expires_at.getFullYear() + 1);

            // Insertar la zona de peligro con la nueva estructura
            const query = `
                INSERT INTO dangerZones (
                    latitude,
                    longitude,
                    radius,
                    report_count,
                    severity,
                    description,
                    is_verified,
                    expires_at
                )
                VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
                RETURNING 
                    zone_id,
                    latitude,
                    longitude,
                    radius,
                    report_count,
                    severity,
                    description,
                    is_verified,
                    expires_at,
                    created_at;
            `;

            const result = await client.query(query, [
                latitude,
                longitude,
                radius,
                report_count,
                severity,
                description,
                false, // is_verified default to false
                expires_at
            ]);

            // Crear un reporte asociado
            const reportQuery = `
                INSERT INTO dangerZoneReports (
                    zone_id,
                    description,
                    status
                )
                VALUES ($1, $2, $3)
                RETURNING report_id;
            `;

            await client.query(reportQuery, [
                result.rows[0].zone_id,
                `Reporte inicial de zona de peligro: ${description}`,
                'pending'
            ]);

            res.status(201).json({
                message: "Danger Zone added successfully",
                dangerZone: result.rows[0]
            });
        } catch (error) {
            console.error("Error adding danger zone:", error);
            res.status(500).json({ 
                error: "An error occurred while adding the danger zone " + error,
                // details: process.env.NODE_ENV === 'development' ? error.message : undefined
            });
        }
    }

    // Función para obtener zonas de peligro cercanas
    async getNearbyDangerZones(req, res) {
        try {
            const { latitude, longitude } = req.query;

            if (!latitude || !longitude) {
                return res.status(400).json({ error: "Latitude and longitude are required" });
            }

            const query = `
                SELECT 
                    dz.*,
                    ul.user_id,
                    COALESCE(COUNT(dzr.report_id), 0) as total_reports
                FROM dangerZones dz
                JOIN userLocation ul ON dz.location_id = ul.location_id
                LEFT JOIN dangerZoneReports dzr ON dz.zone_id = dzr.zone_id
                WHERE dz.expires_at > CURRENT_TIMESTAMP
                GROUP BY dz.zone_id, ul.location_id, ul.user_id
                ORDER BY 
                    point($1, $2) <@> point(dz.latitude, dz.longitude)
            `;

            const result = await client.query(query, [latitude, longitude]);

            res.json({
                message: "Nearby danger zones retrieved successfully",
                zones: result.rows
            });
        } catch (error) {
            console.error("Error getting nearby danger zones:", error);
            res.status(500).json({ 
                error: "An error occurred while fetching nearby danger zones",
                details: process.env.NODE_ENV === 'development' ? error.message : undefined
            });
        }
    }
}

module.exports = new General();
