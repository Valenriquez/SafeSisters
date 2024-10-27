const pg = require("../db/pg");

// Función para verificar si un usuario está dentro de una geocerca de peligro
async function dangerousGeofence(location) {
    const dangerZones = await pg.query('SELECT * FROM dangerZones');

    for (const zone of dangerZones.rows) {
        const distance = calculateDistance(location, {
            latitude: zone.latitude,
            longitude: zone.longitude
        });

        if (distance <= zone.radius) {
            return zone; // Retorna la zona peligrosa
        }
    }

    return null; // No está en ninguna zona peligrosa
}

// Función para notificar al círculo de un usuario
async function notifyCircle(userId, dangerZone) {
    try {
        const circleMembers = await pg.query(`
            SELECT u.email 
            FROM userCircles uc
            JOIN users u ON uc.user_id = u.user_id
            WHERE uc.circle_id = (
                SELECT circle_id 
                FROM circles 
                WHERE owner_id = $1
            )
        `, [userId]);

        for (const member of circleMembers.rows) {
            console.log(`Notificación enviada a ${member.email}: Estás en una zona de peligro: ${dangerZone.description}`);
        }
    } catch (error) {
        console.error('Error al notificar al círculo:', error);
    }
}

class User {
    async getData(req, res) {
        res.send('Hello World');
    }

    async storeUserLocation(req, res) {
        const { userId, latitude, longitude } = req.body;
        const location = { latitude, longitude };

        try {
            await this.updateUserLocation(userId, location);
            res.send('Ubicación guardada correctamente.');
        } catch (error) {
            console.error('Error al almacenar la ubicación:', error);
            res.status(500).send('Error interno del servidor.');
        }
    }

    async updateUserLocation(userId, location) {
        const dangerZone = await dangerousGeofence(location);

        if (dangerZone) {
            await notifyCircle(userId, dangerZone);
            console.log('El usuario está en una zona peligrosa.');
        } else {
            console.log('El usuario no está en ninguna zona peligrosa.');
        }

        await pg.query(`
            INSERT INTO userLocation (user_id, latitude, longitude)
            VALUES ($1, $2, $3)
            ON CONFLICT (user_id) 
            DO UPDATE SET latitude = $2, longitude = $3, updated_at = CURRENT_TIMESTAMP
        `, [userId, location.latitude, location.longitude]);
    }
}

const userController = new User();
module.exports = userController;

// Función para calcular la distancia entre dos puntos geográficos
function calculateDistance(location1, location2) {
    const toRadians = (degrees) => degrees * (Math.PI / 180);
    const earthRadiusKm = 6371; // Radio de la Tierra en kilómetros

    const dLat = toRadians(location2.latitude - location1.latitude);
    const dLon = toRadians(location2.longitude - location1.longitude);

    const lat1 = toRadians(location1.latitude);
    const lat2 = toRadians(location2.latitude);

    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
              Math.cos(lat1) * Math.cos(lat2) *
              Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return earthRadiusKm * c * 1000; // Devuelve la distancia en metros
}
