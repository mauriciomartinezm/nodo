import { db } from '../database/db.js';
import { sendNotificationToUser } from '../utils/firebase.js';
import { createNotification } from './notificationController.js';
import { saveNotification } from '../services/notificationService.js';
import { v4 as uuidv4 } from "uuid";

export const apply = async (req, res) => {
    console.log("Petición recibida en /apply. Cuerpo de la petición: ");
    console.log(req.body);
    const { publicacionId, trabajadorId } = req.body;

    try {
        //Se verifica que la publicacion exista en la base de datos.
        const post = await db.query(
            'SELECT * FROM publicacion WHERE id = $1',
            [publicacionId]
        );

        if (post.rows.length === 0) {
            return res.status(404).json({ message: 'Publicación no encontrada' });
        }

        const clientId = post.rows[0].id_cliente;

        const userResult = await db.query(
            'SELECT * FROM Usuario WHERE id = $1',
            [clientId]
        );

        if (userResult.rows.length === 0) {
            return res.status(404).json({ message: 'Cliente no encontrado' });
        }

        const client = userResult.rows[0];
        const fcmToken = client.fcm_token;

        //Se inserta postulacion en la tabla
        const applicationId = uuidv4();
        const applicationDate = new Date();

        await db.query(`
            INSERT INTO Postulacion (
                id, id_publicacion, id_trabajador, fecha_postulacion, estado
            ) VALUES ($1, $2, $3, $4, $5)
        `, [
            applicationId,
            publicacionId,
            trabajadorId,
            applicationDate,
            'pendiente'
        ]);

        if (!fcmToken) {
            return res.status(200).json({ message: 'Postulacion creada correctamente pero el usuario no tiene token FCM' });
        }

        //Se verifica que el cliente exista
        await saveNotification(
            clientId,
            'solicitud',
            'Nueva postulación',
            'Un trabajador se ha postulado a tu publicación',
            {
                publicacionId: publicacionId.toString(),
                trabajadorId: trabajadorId.toString()
            }
        );

        res.status(200).json({ message: 'Postulacion creada y notificación enviada correctamente' });
    } catch (error) {
        console.error('Error al postularse:', error);
        res.status(500).json({ message: 'Error interno del servidor' });
    }
};

export const getApplications = async (req, res) => {
    console.log("Petición recibida en /getApplications");
    try {
        const result = await db.query("SELECT * FROM Postulacion");
        res.json(result.rows);
    } catch (error) {
        return res
            .status(500)
            .json({ message: "Error interno del servidor", error: error.message });
    }
};

export const getApplication = async (req, res) => {
    console.log("Petición recibida en /getApplication");

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

export const getApplicationsByUserId = async (req, res) => {
    console.log("Petición recibida en /getApplicationsByUserId");

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

export const getApplicationsByPostId = async (req, res) => {
    console.log("Petición recibida en /getApplicationsByPostId");

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

export const updateApplication = async (req, res) => {
    console.log("Petición hecha en /updateApplication");

    const applicationId = req.params.id;
    const { estado } = req.body;

    try {
        // Paso 1: Obtener la postulación actual
        const { rows } = await db.query(
            "SELECT * FROM Postulacion WHERE id = $1",
            [applicationId]
        );

        if (rows.length === 0) {
            return res.status(404).json({ message: "Postulación no encontrada" });
        }

        const postId = rows[0].id_publicacion;
        const workerId = rows[0].id_trabajador;

        console.log("Id del trabajador: ");
        console.log(workerId);
        // Paso 2: Si el nuevo estado es "aceptado", rechazar las demás
        if (estado === "aceptado") {
            await db.query(
                `UPDATE Postulacion
                 SET estado = 'rechazado'
                 WHERE id_publicacion = $1 AND id != $2`,
                [postId, applicationId]
            );
            const { rows } = await db.query(
                "SELECT * FROM Publicacion WHERE id = $1",
                [postId]
            );
            await db.query(
                `UPDATE Publicacion
                 SET estado = 'en proceso'
                 WHERE id = $1`,
                [postId]
            );
            if (rows.length === 0) {
                return res.status(404).json({ message: "Publicacion no encontrada" });
            }
            const clientId = rows[0].id_cliente;
            console.log("Id del cliente a enviar notificación: ");
            console.log(clientId);
            await saveNotification(
                clientId,
                'postulacion_aceptada',
                'Un trabajador ha aceptado tu oferta',
                'El trabajador ha aceptado el trabajo. Puedes iniciar la conversación para coordinar detalles',
                {
                    //publicacionId: publicacionId.toString(),
                    //trabajadorId: trabajadorId.toString()
                }
            );
            console.log("Notificacion enviada");
        }

        // Paso 3: Actualizar esta postulación normalmente
        const keys = Object.keys(req.body);
        const values = Object.values(req.body);
        const setClause = keys.map((key, index) => `${key} = $${index + 1}`).join(", ");
        values.push(applicationId);

        const updateQuery = `UPDATE Postulacion SET ${setClause} WHERE id = $${values.length}`;
        const result = await db.query(updateQuery, values);

        if (result.rowCount === 0) {
            return res.status(404).json({ message: "No se pudo actualizar la postulación" });
        }
        //Enviar notificacion al trabajador
        if (estado == 'considerado') {
            await saveNotification(
                workerId,
                'consideracion',
                'Un cliente está interesado en ti',
                'El empleador te ha considerado para una oferta. ¿Quieres aceptar?',
                {
                    //publicacionId: publicacionId.toString(),
                    //trabajadorId: trabajadorId.toString()
                }
            );
            console.log("Notificacion enviada");

        }
        /*if (estado == 'finalizada') {
            await saveNotification(
                workerId,
                'trabajo completado',
                'Trabajo finalizado',
                'Tu trabajo ha sido finalizada con éxito. ¡No olvides dejar tu reseña!',
                { //publicacionId: req.params.id
                }
            );
            console.log("Notificacion enviada");

        }*/
        res.json({ message: "Postulación actualizada correctamente" });
    } catch (error) {
        console.error("Error al actualizar postulación:", error);
        res.status(500).json({ message: "Error interno del servidor" });
    }
};

export const deleteApplication = async (req, res) => {
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
