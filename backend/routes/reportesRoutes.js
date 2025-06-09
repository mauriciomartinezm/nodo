import {Router} from 'express';
import {
    getReportes,
    getReporte,
    getReporteByPublicacionId,
    createReporte
} from '../controllers/reporteController.js';

const reporteRouter = Router ();

reporteRouter.get('/api/getReportes', getReportes);
reporteRouter.get('/api/getReporte/:id', getReporte);
reporteRouter.get('/api/getReporteByPublicacionId/:id', getReporteByPublicacionId);
reporteRouter.post('/api/createReporte', createReporte);

export default reporteRouter;