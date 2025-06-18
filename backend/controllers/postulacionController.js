import { db } from '../database/db.js';
import { enviarNotificacionAUsuario } from '../utils/firebase.js';
import { createNotificacion } from './notificacionController.js';
import { guardarNotificacion } from '../services/notificacionService.js';
import { v4 as uuidv4 } from "uuid";

export const postularse = async (req, res) => {
    console.log("Petición recibida en /postularse. Cuerpo de la petición: ");
    console.log(req.body);
    const { publicacionId, trabajadorId } = req.body;

    try {
        //Se verifica que la publicacion exista en la base de datos.
        const publicacion = await db.query(
            'SELECT * FROM publicacion WHERE id = $1',
            [publicacionId]
        );

        if (publicacion.rows.length === 0) {
            return res.status(404).json({ message: 'Publicación no encontrada' });
        }

        const idCliente = publicacion.rows[0].id_cliente;

        const resultUsuario = await db.query(
            'SELECT * FROM Usuario WHERE id = $1',
            [idCliente]
        );

        if (resultUsuario.rows.length === 0) {
            return res.status(404).json({ message: 'Cliente no encontrado' });
        }

        const cliente = resultUsuario.rows[0];
        const fcmToken = cliente.fcm_token;

        //Se inserta postulacion en la tabla
        const idPostulacion = uuidv4();
        const fechaPostulacion = new Date();

        await db.query(`
            INSERT INTO Postulacion (
                id, id_publicacion, id_trabajador, fecha_postulacion, estado
            ) VALUES ($1, $2, $3, $4, $5)
        `, [
            idPostulacion,
            publicacionId,
            trabajadorId,
            fechaPostulacion,
            'pendiente'
        ]);

        if (!fcmToken) {
            res.status(200).json({ message: 'Postulación creada correctamente pero el usuario no tiene token FCM' });
        }

        //Se verifica que el cliente exista
        await guardarNotificacion(
            idCliente,
            'solicitud',
            'Nueva postulación',
            'Un trabajador se ha postulado a tu publicación',
            {
                publicacionId: publicacionId.toString(),
                trabajadorId: trabajadorId.toString()
            }
        );

        res.status(200).json({ message: 'Postulación creada y notificación enviada correctamente' });
    } catch (error) {
        console.error('Error al postularse:', error);
        res.status(500).json({ message: 'Error interno del servidor' });
    }
};

export const getPostulaciones = async (req, res) => {
    console.log("Petición recibida en /getPostulaciones");
    try {
        const result = await db.query("SELECT * FROM Postulacion");
        res.json(result.rows);
    } catch (error) {
        return res
            .status(500)
            .json({ message: "Error interno del servidor", error: error.message });
    }
};

export const getPostulacion = async (req, res) => {
    console.log("Petición recibida en /getPostulacion");

    try {
        const result = await db.query(
            "SELECT * FROM Postulacion WHERE id = $1",
            [req.params.id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ message: "No existen registros" });
        }

        res.json(result.rows[0]);

    } catch (error) {
        if (!res.headersSent) {
            res.status(500).json({ message: error.message });
        }
    }
};

export const getPostulacionesByUserId = async (req, res) => {
    console.log("Peetición recibida en /getPostulacionesByUserId");

    try {
        console.log(req.params.id);

        const result = await db.query(
            "SELECT * FROM Postulacion WHERE id_trabajador = $1",
            [req.params.id]
        );

        if (result.rows.length === 0) {
            return res.status(204).json({ message: "No existen registros" });
        }

        return res.status(200).json(result.rows);
    } catch (error) {
        if (!res.headersSent) {
            res.status(500).json({ message: error.message });
        }
    }
};

export const getPostulacionesByPostId = async (req, res) => {
    console.log("Petición recibida en /getPostulacionesByPostId");

    try {
        console.log(req.params.id);

        const result = await db.query(
            "SELECT * FROM Postulacion WHERE id_publicacion = $1",
            [req.params.id]
        );

        if (result.rows.length === 0) {
            return res.status(204).json({ message: "No existen registros" });
        }

        return res.status(200).json(result.rows);
    } catch (error) {
        if (!res.headersSent) {
            res.status(500).json({ message: error.message });
        }
    }
};

export const updatePostulacion = async (req, res) => {
    console.log("Petición hecha en /updatePostulacion");

    const postulacionId = req.params.id;
    const { estado } = req.body;

    try {
        // Paso 1: Obtener la postulación actual
        const { rows } = await db.query(
            "SELECT id_publicacion FROM Postulacion WHERE id = $1",
            [postulacionId]
        );

        if (rows.length === 0) {
            return res.status(404).json({ message: "Postulación no encontrada" });
        }

        const idPublicacion = rows[0].id_publicacion;

        // Paso 2: Si el nuevo estado es "aceptado", rechazar las demás
        if (estado === "aceptado") {
            await db.query(
                `UPDATE Postulacion
                 SET estado = 'rechazado'
                 WHERE id_publicacion = $1 AND id != $2`,
                [idPublicacion, postulacionId]
            );
        }

        // Paso 3: Actualizar esta postulación normalmente
        const keys = Object.keys(req.body);
        const values = Object.values(req.body);
        const setClause = keys.map((key, index) => `${key} = $${index + 1}`).join(", ");
        values.push(postulacionId);

        const updateQuery = `UPDATE Postulacion SET ${setClause} WHERE id = $${values.length}`;
        const result = await db.query(updateQuery, values);

        if (result.rowCount === 0) {
            return res.status(404).json({ message: "No se pudo actualizar la postulación" });
        }

        res.json({ message: "Postulación actualizada correctamente" });
    } catch (error) {
        console.error("Error al actualizar postulación:", error);
        res.status(500).json({ message: "Error interno del servidor" });
    }
};

export const deletePostulacion = async (req, res) => {
  try {
    const result = await db.query(
      "DELETE FROM Postulacion WHERE id = $1",
      [req.params.id]
    );
    if (result.rowCount === 0) {
      return res.status(404).json({ message: "No se encuentra registrado" });
    }

    res.json({ message: "Registro eliminado exitosamente" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};

/*No quiero volver a verla más nunca en mi camino
Distancia que nos separa, me hiere su cruel olvido
Es muy cierto que las noches tan largas con mi desvelo
Rayito de la mañana, tú sabes cuanto la quiero

Solitario en el recuerdo, se va alejando mi queja
Amigos que me conocen me dirán
¿Qué es lo que pasa en tu interior?
No eres el mismo que conocimos, lleno de vida y de ilusión
Se nota a leguas de verdad que te lastima el corazón

Se nota a leguas que estás sufriendo por un amor
Se nota a leguas que estás sufriendo por un amor */