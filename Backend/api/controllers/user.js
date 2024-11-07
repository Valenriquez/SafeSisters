const pg = require("../db/pg");

// Función para verificar si un usuario está dentro de una geocerca de peligro
async function dangerousGeofence(location) {
    const dangerZones = await pg.query('SELECT * FROM dangerZones');
    console.log("dangerousGeofence")
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

 // Función para actualizar la ubicación del usuario
async function updateUserLocation(userId, location) {
    const dangerZone = await dangerousGeofence(location);
    let msg = '';
    if (dangerZone) {
        await notifyCircle(userId, dangerZone);
        msg = 'El usuario está en una zona peligrosa.';
    } else {
        msg = 'El usuario no está en ninguna zona peligrosa.';
    }

    // Guardamos la ubicación del usuario en la base de datos
    await pg.query(`
        INSERT INTO userLocation (user_id, latitude, longitude)
        VALUES ($1, $2, $3)
        ON CONFLICT (user_id) 
        DO UPDATE SET latitude = $2, longitude = $3, updated_at = CURRENT_TIMESTAMP
    `, [userId, location.latitude, location.longitude]);

    return msg;  // Regresamos el mensaje de la zona peligrosa
}


class User {
    // Función para obtener datos (puedes personalizarla según sea necesario)
    async getData(req, res) {
        res.send('Hello World');
    }

    // Función para almacenar la ubicación del usuario
    async storeUserLocation(req, res) {
        const { user_id, latitude, longitude } = req.body;
        const location = { latitude, longitude };
        try {
            // Llamamos a la función de actualización y obtenemos el mensaje de la zona peligrosa
            const message = await updateUserLocation(user_id, location);
            res.send({ message: message });  // Regresamos el mensaje como respuesta al usuario
        } catch (error) {
            console.error('Error al almacenar la ubicación:', error);
            res.status(500).send('Error interno del servidor.');
        }
    }


    // Función para crear un usuario
    async createUser(req, res) {
        const { username, email } = req.body;

        // Validación simple
        if (!username || !email) {
            return res.status(400).json({ error: 'Username y email son requeridos' });
        }

        try {
            // Realizar la inserción del usuario en la base de datos
            const result = await pg.query(
                `INSERT INTO users (username, email)
                VALUES ($1, $2)
                RETURNING user_id, username, email, created_at`,
                [username, email]
            );

            // Retornar la respuesta con los datos del usuario insertado
            res.status(201).json({
                message: 'User created successfully',
                user: result.rows[0], // Obtener el primer (y único) resultado de la inserción
            });
        } catch (error) {
            console.error('Error creating user:', error);
            res.status(500).json({ error: 'Error interno del servidor' });
        }
    }
}

module.exports = User;

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
