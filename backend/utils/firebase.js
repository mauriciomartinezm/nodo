import admin from 'firebase-admin';
import { guardarNotificacion } from '../services/notificacionService.js';
import { initializeApp, applicationDefault } from 'firebase-admin/app';
import serviceAccount from '../serviceAccount.js';

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    storageBucket: "gs://nodo-b1ff4.firebasestorage.app"
});
const bucket = admin.storage().bucket();
export default bucket;


export async function enviarNotificacionAUsuario(fcmToken, titulo, cuerpo, data = {}, usuarioId = null) {
    console.log("Enviando notificación al usuario...");

    const mensaje = {
        token: fcmToken,
        notification: {
            title: titulo,
            body: cuerpo,
        },
        data
    };

    try {
        const response = await admin.messaging().send(mensaje);
        console.log('Notificación enviada:', response);

        // Guarda la notificación en Redis si hay usuarioId
        if (usuarioId) {
            await guardarNotificacion(usuarioId, data.tipo || 'otro', titulo, cuerpo, data);
        }
    } catch (error) {
        console.error('Error enviando notificación:', error);
    }
}
