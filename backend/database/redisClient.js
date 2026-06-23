// config/redisClient.js
import { createClient } from 'redis';

console.log("Conectando a Redis Cloud");
const redis = createClient({
    username: process.env.REDIS_USERNAME,
    password: process.env.REDIS_PASSWORD,
    disableOfflineQueue: true, // si no hay conexión, los comandos fallan al instante en vez de quedar colgados
    socket: {
        host: process.env.REDIS_HOST,
        port: process.env.REDIS_PORT,
        reconnectStrategy: (retries) => {
            if (retries > 3) {
                console.log('Redis: no se pudo conectar tras varios intentos, se deja de reintentar. La app sigue sin notificaciones.');
                return false; // deja de reintentar, no tumba el proceso
            }
            return Math.min(retries * 200, 2000);
        }
    }
});
redis.on('error', err => console.log('Redis Client Error:', err.message));

// No se bloquea el arranque del servidor esperando esta conexión.
redis.connect().catch(err => {
    console.log('No se pudo conectar a Redis al iniciar:', err.message);
});

export default redis;
