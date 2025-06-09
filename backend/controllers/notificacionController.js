// controllers/notificacionesController.js
import redis from '../database/redisClient.js'; // tu cliente de Redis
import { v4 as uuidv4 } from 'uuid';
import { db } from '../database/db.js';
import { enviarNotificacionAUsuario } from '../utils/firebase.js';
import { guardarNotificacion } from '../services/notificacionService.js';

export async function createNotificacion(req, res) {
  const { usuarioId, tipo, titulo, mensaje, data } = req.body;

  try {
    await guardarNotificacion(usuarioId, tipo, titulo, mensaje, data);
    res.json({ mensaje: 'Notificación agregada correctamente' });
  } catch (error) {
    console.error('Error al crear notificación:', error);
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
