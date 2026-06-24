// controllers/notificacionesController.js
import redis from '../database/redisClient.js'; // tu cliente de Redis
import { v4 as uuidv4 } from 'uuid';
import { db } from '../database/db.js';
import { sendNotificationToUser } from '../utils/firebase.js';
import { saveNotification } from '../services/notificationService.js';

export async function createNotification(req, res) {
  const { usuarioId, tipo, titulo, mensaje, data } = req.body;

  try {
    await saveNotification(usuarioId, tipo, titulo, mensaje, data);
    res.json({ mensaje: 'Notificación agregada correctamente' });
  } catch (error) {
    console.error('Error al crear notificación:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
}



export async function getNotificationsByUserId(req, res) {
  const { usuarioId } = req.params;

  if (!usuarioId) {
    return res.status(400).json({ error: 'usuarioId es requerido' });
  }

  const redisKey = `notificaciones:${usuarioId}`;

  try {
    const notifications = await redis.lRange(redisKey, 0, -1);
    const result = notifications.map(n => JSON.parse(n));
    console.log("notificaciones");
    console.log(notifications);
    return res.status(200).json(result);
  } catch (error) {
    console.error('Error obteniendo notificaciones:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
}

export async function getNotifications(req, res) {
  try {
    const keys = await redis.keys('notificaciones:*');

    const result = [];

    for (const key of keys) {
      const usuarioId = key.split(':')[1]; // Extraemos el ID del usuario
      const notifications = await redis.lRange(key, 0, -1);
      const parsed = notifications.map(n => JSON.parse(n));
      result.push({ usuarioId, notificaciones: parsed });
    }

    return res.status(200).json(result);
  } catch (error) {
    console.error('Error obteniendo todas las notificaciones:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
}
