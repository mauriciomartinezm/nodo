import {Router} from 'express';
import {
    postularse,
} from '../controllers/postulacionController.js';

const postulacionRouter = Router ();

postulacionRouter.post('/api/postularse', postularse);


export default postulacionRouter;