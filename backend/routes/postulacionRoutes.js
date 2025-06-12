import {Router} from 'express';
import {
    postularse,
    getPostulacion,
    getPostulaciones,
    getPostulacionesByUserId,
    getPostulacionesByPostId,
    updatePostulacion
} from '../controllers/postulacionController.js';

const postulacionRouter = Router ();

postulacionRouter.post('/api/postularse', postularse);
postulacionRouter.get('/api/getPostulacion/:id', getPostulacion);
postulacionRouter.get('/api/getPostulaciones', getPostulaciones);
postulacionRouter.get('/api/getPostulacionesByUserId/:id', getPostulacionesByUserId);
postulacionRouter.get('/api/getPostulacionesByPostId/:id', getPostulacionesByPostId);
postulacionRouter.put('/api/updatePostulacion/:id', updatePostulacion);





export default postulacionRouter;