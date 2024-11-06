// controllers/general.js
const client = require('../db/pg'); // Asegúrate de importar correctamente el cliente

class General {
    // Función para generar una ubicación aleatoria en Monterrey y guardarla en la base de datos
    async generateRandomLocation(req, res) {
        try {
            const { user_id } = req.body;

            if (!user_id) {
                return res.status(400).send("User ID is required");
            }

            const minLat = 25.3384; // Latitud mínima aproximada de Monterrey
            const maxLat = 25.5384; // Latitud máxima aproximada de Monterrey
            const minLong = -100.9922; // Longitud mínima aproximada de Monterrey
            const maxLong = -100.8322; // Longitud máxima aproximada de Monterrey

            // Generar valores aleatorios de latitud y longitud dentro del rango
            const latitude = (Math.random() * (maxLat - minLat) + minLat).toFixed(6);
            const longitude = (Math.random() * (maxLong - minLong) + minLong).toFixed(6);

            // Insertar la ubicación aleatoria en la tabla userLocation
            const locationQuery = `
                INSERT INTO userLocation (user_id, latitude, longitude)
                VALUES ($1, $2, $3)
                RETURNING location_id, latitude, longitude;
            `;

            const result = await client.query(locationQuery, [user_id, latitude, longitude]);

            res.status(201).json({
                message: "Location added successfully",
                location: result.rows[0],
            });
        } catch (error) {
            console.error("Error generating random location:", error);
            res.status(500).send("An error occurred while generating and saving the location");
        }
    }

    // Función para agregar una zona de peligro aleatoria
    async addDangerZone(req, res) {
        try {
            const { location_id } = req.body;
    
            if (!location_id) {
                return res.status(400).send("Location ID is required");
            }
    
            // Verificar si el location_id existe en la tabla userLocation
            const locationCheckQuery = 'SELECT * FROM userLocation WHERE location_id = $1';
            const locationCheckResult = await client.query(locationCheckQuery, [location_id]);
    
            if (locationCheckResult.rows.length === 0) {
                return res.status(400).send("Location ID does not exist in userLocation");
            }
    
            // Generar valores aleatorios para la zona de peligro
            const report_count = Math.floor(Math.random() * 100); // Número aleatorio entre 0 y 99
            const severities = ["low", "medium", "high"];
            const severity = severities[Math.floor(Math.random() * severities.length)]; // Elegir aleatoriamente entre low, medium, high
    
            // Generar una descripción aleatoria
            const descriptions = [
                "High risk of flooding due to rain.",
                "Area known for frequent traffic accidents.",
                "Potential zone for earthquakes.",
                "Dangerous location due to high crime rates.",
                "Reported fire hazard in the area."
            ];
            const description = descriptions[Math.floor(Math.random() * descriptions.length)];
    
            // Insertar la zona de peligro con datos aleatorios
            const query = `
                INSERT INTO dangerZones (location_id, report_count, severity, description)
                VALUES ($1, $2, $3, $4)
                RETURNING zone_id, location_id, report_count, severity, description;
            `;
            const result = await client.query(query, [location_id, report_count, severity, description]);
    
            // Responder con los datos de la zona de peligro
            res.status(201).json({
                message: "Danger Zone added successfully",
                dangerZone: result.rows[0],
            });
        } catch (error) {
            console.error("Error adding danger zone:", error);
            res.status(500).send("An error occurred while adding the danger zone");
        }
    }    
}

module.exports = new General();
