// config/redisClient.js
import { createClient } from 'redis';

const MAX_RETRIES = 5;

console.log("Conectando a Redis Cloud");
const redis = createClient({
    username: process.env.REDIS_USERNAME,
    password: process.env.REDIS_PASSWORD,
    disableOfflineQueue: true,
    socket: {
        host: process.env.REDIS_HOST,
        port: process.env.REDIS_PORT,
        reconnectStrategy: (retries) => {
            if (retries >= MAX_RETRIES) {
                console.log('Redis: no disponible tras varios intentos. El servidor continúa sin caché.');
                return false; // detiene los reintentos
            }
            const delay = Math.min(retries * 200, 5000);
            console.log(`Redis: reintentando conexión (intento ${retries + 1}/${MAX_RETRIES})...`);
            return delay;
        }
    }
});
redis.on('error', err => console.log('Redis Client Error:', err.message));

// No se bloquea el arranque del servidor esperando esta conexión.
redis.connect().catch(err => {
    console.log('No se pudo conectar a Redis al iniciar:', err.message);
});

export default redis;
