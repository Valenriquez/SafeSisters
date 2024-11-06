const { Client } = require('pg');
require('dotenv').config();

// Crear una conexión a la base de datos PostgreSQL
const client = new Client({
    host: process.env.host,
    user: process.env.user,
    password: process.env.password,
    database: process.env.database,
    port: 5432, // Añadir el puerto por si no está definido
});

// Abrir la conexión a PostgreSQL
client.connect((error) => {
    if (error) {
        console.log(process.env.host);
        console.error('Error connecting to the database:');
        throw error;
    } else {
        console.log("Successfully connected to the PostgreSQL database.");
    }
});

module.exports = client;
