//import { createPool } from 'mysql2/promise';
import pkg from 'pg';
const { Pool } = pkg;
/*
export const db = new Pool({
    host: "c34u0gd6rbe7bo.cluster-czrs8kj4isg7.us-east-1.rds.amazonaws.com",
    port: "5432",
    user: "u2u52cckkh43vi",
    password: "pb54d8a712f041794f46fa5a1df550b22b631e0d052548bd5c7fb30ed6d5f249c",
    database: "d7sqbh3p9jca7c",
});
*/
export const db = new Pool({
    connectionString: "postgres://u2u52cckkh43vi:pb54d8a712f041794f46fa5a1df550b22b631e0d052548bd5c7fb30ed6d5f249c@c34u0gd6rbe7bo.cluster-czrs8kj4isg7.us-east-1.rds.amazonaws.com:5432/d7sqbh3p9jca7c",
    ssl: { rejectUnauthorized: false } // Esto es importante para conexiones seguras, solo en producción
})
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
