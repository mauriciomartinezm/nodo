import {Router} from 'express';
import {
    saveToken,
    deleteToken,
} from '../controllers/firebaseController.js';

const firebaseRouter = Router ();

firebaseRouter.post('/api/saveToken', saveToken);
firebaseRouter.put('/api/deleteToken', deleteToken);

export default firebaseRouter;