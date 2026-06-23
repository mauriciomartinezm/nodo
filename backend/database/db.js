import pkg from 'pg';
const { Pool } = pkg;

const isLocal = /localhost|127\.0\.0\.1/.test(process.env.DATABASE_URL ?? '');

export const db = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: isLocal ? false : { rejectUnauthorized: false } // SSL solo contra la BD remota (AWS RDS)
})
// Para verificar la conexión
async function testConnection() {
    try {
        const res = await db.query('SELECT NOW()');
        console.log("Conexión exitosa a la base de datos.");
    } catch (error) {
        console.error("Error al conectar a la base de datos:", error);
    }
}

testConnection();
