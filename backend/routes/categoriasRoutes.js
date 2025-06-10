import {Router} from 'express';
import {
    getCategorias,
    getCategoria
} from '../controllers/categoriaController.js';

const categoriaRouter = Router ();

categoriaRouter.get('/api/getCategorias', getCategorias);
categoriaRouter.get('/api/getCategoria/:id', getCategoria);

//clienteRouter.get('/api/getCliente/:id', getCliente);
//clienteRouter.post('/api/createCliente', createCliente);
//clienteRouter.delete('/api/deleteCliente/:id', deleteCliente);
//clienteRouter.put('/api/updateCliente/:id', updateCliente);
//clienteRouter.post('/api/loginCliente', loginCliente);

export default categoriaRouter;