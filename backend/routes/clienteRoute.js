import {Router} from 'express';
import {
    getClientes,
    getCliente,
    createCliente,
    deleteCliente,
    updateCliente,
    loginCliente
} from '../controllers/clienteController.js';

const clienteRouter = Router ();

clienteRouter.get('/api/getClientes', getClientes);
clienteRouter.get('/api/getCliente/:id', getCliente);
clienteRouter.post('/api/createCliente', createCliente);
clienteRouter.delete('/api/deleteCliente/:id', deleteCliente);
clienteRouter.put('/api/updateCliente/:id', updateCliente);
clienteRouter.post('/api/loginCliente', loginCliente);

export default clienteRouter;