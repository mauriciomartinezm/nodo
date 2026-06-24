import express from 'express';
import {
    createNotification,
    getNotificationsByUserId,
    getNotifications
} from '../controllers/notificacionController.js';

const notificationRouter = express.Router();

notificationRouter.post('/api/createNotification', createNotification);
notificationRouter.get('/api/getNotificationsByUserId/:usuarioId', getNotificationsByUserId);
notificationRouter.get('/api/getNotifications', getNotifications);


export default notificationRouter;
