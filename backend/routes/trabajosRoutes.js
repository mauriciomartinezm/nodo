import {Router} from 'express';
import {
    finalizarTrabajo,
} from '../controllers/trabajoController.js';

const trabajoRouter = Router ();

trabajoRouter.put('/api/finalizarTrabajo', finalizarTrabajo);
//usuarioRouter.get('/api/getUsuario/:id', getUsuario);
//usuarioRouter.post('/api/createUsuario', createUsuario);
//usuarioRouter.delete('/api/deleteUsuario/:id', deleteUsuario);
//usuarioRouter.put('/api/updateUsuario/:id', updateUsuario);
//usuarioRouter.post('/api/loginUsuario', loginUsuario);

export default trabajoRouter;