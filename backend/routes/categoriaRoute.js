import {Router} from 'express';
import {
<<<<<<< HEAD
=======
    createCategoria,
>>>>>>> origin/ramaAuxiliar
    getCategorias,
} from '../controllers/categoriaController.js';

const categoriaRouter = Router ();

categoriaRouter.get('/api/getCategorias', getCategorias);
//clienteRouter.get('/api/getCliente/:id', getCliente);
<<<<<<< HEAD
//clienteRouter.post('/api/createCliente', createCliente);
=======
categoriaRouter.post('/api/createCategoria', createCategoria);
>>>>>>> origin/ramaAuxiliar
//clienteRouter.delete('/api/deleteCliente/:id', deleteCliente);
//clienteRouter.put('/api/updateCliente/:id', updateCliente);
//clienteRouter.post('/api/loginCliente', loginCliente);

export default categoriaRouter;