import express from 'express';
import {
    agregarNotificacion,
    getNotificacionesByUserId,
    getNotificaciones
} from '../controllers/notificacionController.js';

const notificacionRouter = express.Router();

notificacionRouter.post('/api/agregarNotificacion', agregarNotificacion);
notificacionRouter.get('/api/getNotificacionesByUserId/:usuarioId', getNotificacionesByUserId);
notificacionRouter.get('/api/getNotificaciones', getNotificaciones);


export default notificacionRouter;
