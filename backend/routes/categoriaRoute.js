import {Router} from 'express';
import {
    createCategoria,
    getCategorias,
} from '../controllers/categoriaController.js';

const categoriaRouter = Router ();

categoriaRouter.get('/api/getCategorias', getCategorias);
//clienteRouter.get('/api/getCliente/:id', getCliente);
categoriaRouter.post('/api/createCategoria', createCategoria);
//clienteRouter.delete('/api/deleteCliente/:id', deleteCliente);
//clienteRouter.put('/api/updateCliente/:id', updateCliente);
//clienteRouter.post('/api/loginCliente', loginCliente);

export default categoriaRouter;