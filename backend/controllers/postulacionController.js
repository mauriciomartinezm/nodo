import { db } from '../database/db.js';
import { enviarNotificacionAUsuario } from '../utils/firebase.js';
import { createNotificacion } from './notificacionController.js';
import { guardarNotificacion } from '../services/notificacionService.js';

export const postularse = async (req, res) => {
    console.log("Petición recibida en /postularse. Cuerpo de la petición: ");
    console.log(req.body);
    const { publicacionId, trabajadorId } = req.body;

    try {
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

        if (!fcmToken) {
            return res.status(400).json({ message: 'El usuario no tiene token FCM' });
        }
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

        /*
        await enviarNotificacionAUsuario(
            fcmToken,
            'Nueva postulación',
            'Un trabajador se ha postulado a tu publicación',
            {
                tipo: 'solicitud',
                publicacionId: publicacionId.toString(),
                trabajadorId: trabajadorId.toString()
            },
            idCliente
        );
        */

        res.status(200).json({ message: 'Notificación enviada correctamente' });
    } catch (error) {
        console.error('Error al postularse:', error);
        res.status(500).json({ message: 'Error interno del servidor' });
    }
};
