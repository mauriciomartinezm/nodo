// controllers/notificacionesController.js
import redis from '../database/redisClient.js'; // tu cliente de Redis
import { v4 as uuidv4 } from 'uuid';

export async function createNotificacion(req, res) {
  const { usuarioId, tipo, titulo, mensaje, data } = req.body;

  if (!usuarioId || !titulo || !mensaje || !tipo) {
    return res.status(400).json({ error: 'Faltan campos obligatorios.' });
  }

  const notificacion = {
    id: uuidv4(),
    tipo,
    titulo,
    mensaje,
    data: data || {},
    fecha: new Date().toISOString()
  };

  try {
    await redis.lPush(`notificaciones:${usuarioId}`, JSON.stringify(notificacion));
    res.json({ mensaje: 'Notificación agregada correctamente' });
  } catch (error) {
    console.error('Error al agregar notificación a Redis:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}


export async function getNotificacionesByUserId(req, res) {
  const { usuarioId } = req.params;

  if (!usuarioId) {
    return res.status(400).json({ error: 'usuarioId es requerido' });
  }

  const redisKey = `notificaciones:${usuarioId}`;

  try {
    const notificaciones = await redis.lRange(redisKey, 0, -1);
    const resultado = notificaciones.map(n => JSON.parse(n));
    console.log("notificaciones");
    console.log(notificaciones);
    return res.status(200).json(resultado);
  } catch (error) {
    console.error('Error obteniendo notificaciones:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
}

export async function getNotificaciones(req, res) {
  try {
    const keys = await redis.keys('notificaciones:*');

    const resultado = [];

    for (const key of keys) {
      const usuarioId = key.split(':')[1]; // Extraemos el ID del usuario
      const notificaciones = await redis.lRange(key, 0, -1);
      const parsed = notificaciones.map(n => JSON.parse(n));
      resultado.push({ usuarioId, notificaciones: parsed });
    }

    return res.status(200).json(resultado);
  } catch (error) {
    console.error('Error obteniendo todas las notificaciones:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
}
