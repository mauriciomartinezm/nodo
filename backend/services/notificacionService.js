// notificacionService.js
import { v4 as uuidv4 } from 'uuid';
import redis from '../database/redisClient.js';

export async function guardarNotificacion(usuarioId, tipo, titulo, mensaje, data = {}) {
  console.log("Subprograma guardarNotificacion");

  const notificacion = {
    id: uuidv4(),
    tipo,
    titulo,
    mensaje,
    data,
    fecha: new Date().toISOString()
  };

  try {
    await redis.lPush(`notificaciones:${usuarioId}`, JSON.stringify(notificacion));
    console.log('Notificación guardada en Redis');
  } catch (error) {
    console.error('Error al guardar notificación en Redis:', error);
  }
}
