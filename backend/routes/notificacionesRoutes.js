import express from 'express';
import {
    createNotificacion,
    getNotificacionesByUserId,
    getNotificaciones
} from '../controllers/notificacionController.js';

const notificacionRouter = express.Router();

notificacionRouter.post('/api/createNotificacion', createNotificacion);
notificacionRouter.get('/api/getNotificacionesByUserId/:usuarioId', getNotificacionesByUserId);
notificacionRouter.get('/api/getNotificaciones', getNotificaciones);


export default notificacionRouter;
