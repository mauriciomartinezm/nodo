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
            // Reintenta indefinidamente con backoff creciente (tope 5s).
            // Antes se rendía tras 3 intentos y el cliente quedaba "cerrado"
            // para siempre hasta reiniciar el proceso.
            const delay = Math.min(retries * 200, 5000);
            console.log(`Redis: reintentando conexión (intento ${retries}), próximo intento en ${delay}ms`);
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
