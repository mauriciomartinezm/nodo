// config/redisClient.js
import { createClient } from 'redis';
/* la siguieente configuracion es para conectarse en local, despues de haber abierto el servidor con redis-server en la terminal
const redis = createClient();

redis.on('error', (err) => console.error('Redis error:', err));

await redis.connect();

export default redis;

*/

//la siguiente configuracion es para conectarse a la base de datos redis de rediscloud

const redis = createClient({
    username: 'default',
    password: 'x2Z0BYe6iyuJMQgKLWJCplAww2l1jg5X',
    socket: {
        host: 'redis-18985.c44.us-east-1-2.ec2.redns.redis-cloud.com',
        port: 18985
    }
});

redis.on('error', err => console.log('Redis Client Error', err));

await redis.connect();

await redis.set('foo', 'bar');
const result = await redis.get('foo');
console.log(result)  // >>> bar

export default redis;

