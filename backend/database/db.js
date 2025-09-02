//import { createPool } from 'mysql2/promise';
import pkg from 'pg';
const { Pool } = pkg;
export const db = new Pool({
    host: "centerbeam.proxy.rlwy.net",
    port: "20704",
    user: "postgres",
    password: "kNFfqByNwUlSjqxIAUiySmCAxnmxYKMU",
    database: "railway",
});

// Para verificar la conexión
async function testConnection() {
    try {
        const res = await db.query('SELECT NOW()');
        //const connection = await db.getConnection();
        console.log("Conexión exitosa a la base de datos.");
        //connection.release(); // Libera la conexión al pool
    } catch (error) {
        console.error("Errorrrr al conectar a la base de datos:", error);
    }
}

testConnection();
