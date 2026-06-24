import { db } from "../database/db.js";
import jwt from "jsonwebtoken";
import { v4 as uuidv4 } from "uuid";
import { saveNotification } from '../services/notificacionService.js';


export const finishJob = async (req, res) => {
  console.log("Peticion recibida en /finishJob Cuerpo de la petición: ");
  console.log(req.body);

  var { id_publicacion, id_postulacion } = req.body;

  // Verifica que al menos uno esté presente
  if (!id_publicacion && !id_postulacion) {
    return res.status(400).json({ message: "Se requiere al menos un ID para finalizar." });
  }

  try {
    let messages = [];

    // Actualizar publicación si se recibe id_publicacion
    if (id_publicacion) {
      const worker = await db.query('SELECT id_trabajador FROM postulacion WHERE id_publicacion = $1 AND estado = $2', [id_publicacion, 'aceptado']);
      var id_trabajador = worker.rows[0]['id_trabajador'];
      console.log("Id del trabajador: ");
      console.log(id_trabajador);

      await db.query(
        'UPDATE publicacion SET estado = $1 WHERE id = $2',
        ['finalizada', id_publicacion]
      );
      const application = await db.query(

        'SELECT id from postulacion WHERE id_publicacion = $1 AND id_trabajador = $2',
        [id_publicacion, id_trabajador]
      );
      id_postulacion = application.rows[0]['id']
      console.log("id postulacion: ");
      console.log(id_postulacion);
      messages.push("Publicación finalizada");
      await db.query(
        'UPDATE postulacion SET estado = $1 WHERE id = $2',
        ['finalizada', id_postulacion]
      );
      await saveNotification(
                id_trabajador,
                'trabajo completado',
                'Trabajo finalizado',
                'Tu trabajo ha sido finalizada con éxito. ¡No olvides dejar tu reseña!',
                { //publicacionId: req.params.id
                }
            );
      messages.push("Postulación finalizada");
      return res.status(200).json({ message: messages.join(" y ") + "." });
    }

    // Actualizar postulación si se recibe id_postulacion
    if (id_postulacion) {
      console.log("Enviando notificacion de parte de trabajador a cliente");
      //si es el trabajador quien la da a "trabajo terminado", se le envía notificacion al cliente para que
      //sea él quien termine el trabajo
      const application = await db.query(

        'SELECT * from postulacion WHERE id = $1',
        [id_postulacion]
      );
      //console.log("Publicacion: ");
      //console.log(publicacion);
      const postId = application.rows[0]['id_publicacion'];
      const post = await db.query(

        'SELECT * from publicacion WHERE id = $1',
        [postId]
      );
      const clientId = post.rows[0]['id_cliente'];
      const title = post.rows[0]['titulo'];

      console.log("Id del cliente a enviar notificacion: ");
      console.log(clientId);
      await saveNotification(
        clientId,
        'confirmacion trabajo',
        'Confirmación de finalización requerida',
        `El trabajador ha marcado como terminado el trabajo "${title}". Por favor, revisa los resultados, entra a la publicación y confirma si estás de acuerdo para finalizar el proceso.`,
        {
        }
      );
    }

    return res.status(200).json({ message: messages.join(" y ") + "." });

  } catch (e) {
    console.error("Error en finishJob:", e);
    return res.status(500).json({ message: "Error al finalizar el trabajo." });
  }
};
