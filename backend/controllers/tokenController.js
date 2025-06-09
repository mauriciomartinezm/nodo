import { db } from '../database/db.js';
import { enviarNotificacionAUsuario } from '../utils/firebase.js';

export const saveToken = async (req, res) => {
    const { id_usuario, token } = req.body;

    if (!id_usuario || !token) {
        return res.status(400).json({ message: 'Faltan datos requeridos (id_usuario o token).' });
    }

    try {
        const result = await db.query(
            'UPDATE Usuario SET fcm_token = $1 WHERE id = $2 AND fcm_token IS DISTINCT FROM $1',
            [token, id_usuario]
        );

        await enviarNotificacionAUsuario(token, "Token registrado", "El token FCM fue guardado correctamente", { tipo: "sistema" });

        if (result.rowCount === 0) {
            return res.status(200).json({ message: 'El token ya estaba actualizado. No se realizaron cambios.' });
        }
        return res.status(200).json({ message: 'Token actualizado correctamente.' });

    } catch (error) {
        console.error('Error al guardar el token:', error);
        return res.status(500).json({ message: 'Error interno del servidor.' });
    }
};

export const deleteToken = async (req, res) => {
    const { id_usuario } = req.body;

    if (!id_usuario) {
        return res.status(400).json({ message: 'Se requiere el id_usuario.' });
    }

    try {
        const result = await db.query(
            'UPDATE Usuario SET fcm_token = NULL WHERE id = $1 AND fcm_token IS NOT NULL',
            [id_usuario]
        );

        if (result.rowCount === 0) {
            return res.status(200).json({ message: 'El usuario no tenía token registrado.' });
        }

        return res.status(200).json({
            message: 'Token eliminado correctamente.'
        });

    } catch (error) {
        console.error('Error al eliminar el token:', error);
        return res.status(500).json({ message: 'Error interno del servidor.' });
    }
};
