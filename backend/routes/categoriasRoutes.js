import {Router} from 'express';
import {
    getCategorias,
    getCategoria,
    createCategoria,
    createUsuarioCategoria,
    getUsuarioCategorias
} from '../controllers/categoriaController.js';

const categoriaRouter = Router ();

categoriaRouter.get('/api/getCategorias', getCategorias);
categoriaRouter.get('/api/getCategoria/:id', getCategoria);
categoriaRouter.post('/api/createCategoria', createCategoria);
categoriaRouter.post('/api/createUsuarioCategoria', createUsuarioCategoria);
categoriaRouter.get('/api/getUsuarioCategorias', getUsuarioCategorias);
//clienteRouter.get('/api/getCliente/:id', getCliente);
//clienteRouter.delete('/api/deleteCliente/:id', deleteCliente);
//clienteRouter.put('/api/updateCliente/:id', updateCliente);
//clienteRouter.post('/api/loginCliente', loginCliente);

export default categoriaRouter;