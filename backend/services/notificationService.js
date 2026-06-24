// notificationService.js
import { v4 as uuidv4 } from 'uuid';
import redis from '../database/redisClient.js';
import { db } from '../database/db.js';
import { sendNotificationToUser } from '../utils/firebase.js';

export async function saveNotification(
  userId,
  tipo,
  titulo,
  mensaje,
  data,
) {
  if (!userId || !titulo || !mensaje || !tipo) {
    throw new Error('Faltan campos obligatorios');
  }
  const notification = {
    id: uuidv4(),
    tipo,
    titulo,
    mensaje,
    data,
    fecha: new Date().toISOString()
  };

  try {
    await redis.lPush(`notificaciones:${userId}`, JSON.stringify(notification));
  } catch (err) {
    console.log('No se pudo guardar notificación en Redis, continuando sin ella:', err.message);
  }

  const result = await db.query(
    'SELECT fcm_token FROM Usuario WHERE id = $1',
    [userId]
  );
  const fcmToken = result.rows[0]?.fcm_token;
  console.log("Token del usuario a enviar notificación: ");
  console.log(fcmToken);

  if (fcmToken) {
    await sendNotificationToUser(
      fcmToken,
      titulo,
      mensaje,
      data,
      userId
    );
  }

  return notification;
}

export const notifyWorkersByCategories = async (postId, clientId, categoryIds, categoriesResult) => {
  try {
    // 🔹 Buscar trabajadores que pertenezcan a las categorías
    const workersQuery = `
      SELECT u.id, uc.id_categoria
      FROM usuario u
      JOIN usuario_categoria uc ON u.id = uc.id_usuario
      WHERE uc.id_categoria = ANY($1)
    `;
    const workersResult = await db.query(workersQuery, [categoryIds]);

    // 🔹 Obtener IDs únicos y excluir al cliente
    let workerIds = [...new Set(workersResult.rows.map(row => row.id))];
    workerIds = workerIds.filter(workerId => workerId !== clientId);

    console.log("Trabajadores a notificar:", workerIds);

    // 🔹 Enviar notificaciones
    for (const worker of workersResult.rows) {
      if (worker.id === clientId) continue;

      const categoryName = categoriesResult.rows.find(
        cat => cat.id === worker.id_categoria
      )?.nombre_categoria;

      await saveNotification(
        worker.id,
        'oferta',
        'Nueva oportunidad laboral',
        `¡Se encuentra disponible una nueva oportunidad laboral en la categoría ${categoryName}!`,
        {
          publicacionId: postId.toString(),
          trabajadorId: worker.id.toString()
        }
      );

      console.log(`Notificación enviada al trabajador ${worker.id}`);
    }

  } catch (notificationError) {
    console.error("Error al enviar notificaciones:", notificationError);
  }
};
