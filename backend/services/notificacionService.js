// notificacionService.js
import { v4 as uuidv4 } from 'uuid';
import redis from '../database/redisClient.js';
import { db } from '../database/db.js';
import { enviarNotificacionAUsuario } from '../utils/firebase.js';

export async function guardarNotificacion(
  usuarioId,
  tipo,
  titulo,
  mensaje,
  data,
) {
  if (!usuarioId || !titulo || !mensaje || !tipo) {
    throw new Error('Faltan campos obligatorios');
  }
  const notificacion = {
    id: uuidv4(),
    tipo,
    titulo,
    mensaje,
    data,
    fecha: new Date().toISOString()
  };

  await redis.lPush(`notificaciones:${usuarioId}`, JSON.stringify(notificacion));

  const result = await db.query(
    'SELECT fcm_token FROM Usuario WHERE id = $1',
    [usuarioId]
  );
  const fcmToken = result.rows[0]?.fcm_token;
  console.log("Token del usuario a enviar notificación: ");
  console.log(fcmToken);

  if (fcmToken) {
    await enviarNotificacionAUsuario(
      fcmToken,
      titulo,
      mensaje,
      data,
      usuarioId
    );
  }

  return notificacion;
}

