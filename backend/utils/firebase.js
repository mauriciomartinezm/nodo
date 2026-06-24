import admin from 'firebase-admin';
import { saveNotification } from '../services/notificationService.js';
import { initializeApp, applicationDefault } from 'firebase-admin/app';
import serviceAccount from '../serviceAccount.js';

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    storageBucket: "nodo-b1ff4.firebasestorage.app"
});
const bucket = admin.storage().bucket();
export default bucket;


export async function sendNotificationToUser(fcmToken, title, body, data = {}, userId = null) {
    console.log("Enviando notificación al usuario...");

    const message = {
        token: fcmToken,
        notification: {
            title: title,
            body: body,
        },
        data
    };

    try {
        const response = await admin.messaging().send(message);
        console.log('Notificación enviada:', response);

        // Guarda la notificación en Redis si hay userId
        /*if (userId) {
            await saveNotification(userId, data.tipo || 'otro', title, body, data);
        }*/
    } catch (error) {
        console.error('Error enviando notificación:', error);
    }
}
