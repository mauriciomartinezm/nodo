import { db } from "../database/db.js";
import jwt from "jsonwebtoken";
import { v4 as uuidv4 } from "uuid";

import admin from 'firebase-admin';
import { initializeApp, applicationDefault } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';
import serviceAccount from '../serviceAccount.js';

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

//module.exports = admin;


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

        enviarNotificacionAUsuario(token, "prueba1", "prueba");

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
    console.log("Peticion recibida en /deleteToken")
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
            message: 'Token eliminado correctamente.',
            details: `Se eliminó el token para el usuario ${id_usuario}`
        });

    } catch (error) {
        console.error('Error al eliminar el token:', error);
        return res.status(500).json({ 
            message: 'Error interno del servidor.',
            error: error.message 
        });
    }
};

async function enviarNotificacionAUsuario(fcmToken, titulo, cuerpo, data = {}) {
    console.log("Enviando notificacion al usuario...");

    const mensaje = {
        token: fcmToken,
        notification: {
            title: titulo,
            body: cuerpo,
        },
        data: {
            tipo: "solicitud",
            id: "1234"
        } // opcional: enviar datos extras que sep uuedan manejar en el frontend
    };

    console.log(mensaje);

    try {
        const response = await admin.messaging().send(mensaje);
        console.log('Notificación enviada:', response);
    } catch (error) {
        console.error('Error enviando notificación:', error);
    }
}

async function cuandoTrabajadorAplica(postId, clienteId, trabajadorId) {
    // Lógica para registrar la aplicación...

    // Buscar el token FCM del cliente
    const cliente = await Usuario.findById(clienteId);
    if (!cliente?.fcmToken) {
        console.log('Cliente no tiene token FCM');
        return;
    }

    await enviarNotificacionAUsuario(
        cliente.fcmToken,
        'Nuevo trabajador interesado',
        'Un trabajador ha aplicado a tu publicación.',
        { tipo: 'aplicacion', postId }
    );
}

