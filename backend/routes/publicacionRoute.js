import {Router} from 'express';
import {
    getPublicaciones,
    getPublicacion,
    createPublicacion,
    deletePublicacion,
    updatePublicacion
} from '../controllers/publicacionController.js';

const publicacionRouter = Router ();

publicacionRouter.get('/api/getPublicaciones', getPublicaciones);
publicacionRouter.get('/api/getPublicacion/:id', getPublicacion);
publicacionRouter.post('/api/createPublicacion', createPublicacion);
publicacionRouter.delete('/api/deletePublicacion/:id', deletePublicacion);
publicacionRouter.put('/api/updatePublicacion/:id', updatePublicacion);

export default publicacionRouter;