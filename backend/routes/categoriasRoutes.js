import {Router} from 'express';
import {
    getCategorias,
    getCategoria,
    createCategoria
} from '../controllers/categoriaController.js';

const categoriaRouter = Router ();

categoriaRouter.get('/api/getCategorias', getCategorias);
categoriaRouter.get('/api/getCategoria/:id', getCategoria);
categoriaRouter.post('/api/createCategoria', createCategoria);

//clienteRouter.get('/api/getCliente/:id', getCliente);
//clienteRouter.delete('/api/deleteCliente/:id', deleteCliente);
//clienteRouter.put('/api/updateCliente/:id', updateCliente);
//clienteRouter.post('/api/loginCliente', loginCliente);

export default categoriaRouter;