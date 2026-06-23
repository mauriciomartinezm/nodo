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

  try {
    await redis.lPush(`notificaciones:${usuarioId}`, JSON.stringify(notificacion));
  } catch (err) {
    console.log('No se pudo guardar notificación en Redis, continuando sin ella:', err.message);
  }

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

export const notificarTrabajadoresPorCategorias = async (idPublicacion, idCliente, idCategorias, categoriasResult) => {
  try {
    // 🔹 Buscar trabajadores que pertenezcan a las categorías
    const trabajadoresQuery = `
      SELECT u.id, uc.id_categoria
      FROM usuario u
      JOIN usuario_categoria uc ON u.id = uc.id_usuario
      WHERE uc.id_categoria = ANY($1)
    `;
    const trabajadoresResult = await db.query(trabajadoresQuery, [idCategorias]);

    // 🔹 Obtener IDs únicos y excluir al cliente
    let trabajadoresIds = [...new Set(trabajadoresResult.rows.map(row => row.id))];
    trabajadoresIds = trabajadoresIds.filter(trabajadorId => trabajadorId !== idCliente);

    console.log("Trabajadores a notificar:", trabajadoresIds);

    // 🔹 Enviar notificaciones
    for (const trabajador of trabajadoresResult.rows) {
      if (trabajador.id === idCliente) continue;

      const categoriaNombre = categoriasResult.rows.find(
        cat => cat.id === trabajador.id_categoria
      )?.nombre; // <-- asegúrate del nombre correcto

      await guardarNotificacion(
        trabajador.id,
        'oferta',
        'Nueva oportunidad laboral',
        `¡Se encuentra disponible una nueva oportunidad laboral en la categoría ${categoriaNombre}!`,
        {
          publicacionId: idPublicacion.toString(),
          trabajadorId: trabajador.id.toString()
        }
      );

      console.log(`Notificación enviada al trabajador ${trabajador.id}`);
    }

  } catch (notificationError) {
    console.error("Error al enviar notificaciones:", notificationError);
  }
};


