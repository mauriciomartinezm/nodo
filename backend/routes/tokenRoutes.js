import {Router} from 'express';
import {
    saveToken,
    deleteToken,
} from '../controllers/tokenController.js';

const tokenRouter = Router ();

tokenRouter.post('/api/saveToken', saveToken);
tokenRouter.put('/api/deleteToken', deleteToken);


export default tokenRouter;