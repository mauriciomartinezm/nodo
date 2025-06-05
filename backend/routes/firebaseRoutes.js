import {Router} from 'express';
import {
    saveToken,
} from '../controllers/firebaseController.js';

const firebaseRouter = Router ();

firebaseRouter.post('/api/saveToken', saveToken);

export default firebaseRouter;