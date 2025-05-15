import {Router} from 'express';
import {
    getTrabajadores,
    getTrabajador,
    createTrabajador,
    deleteTrabajador,
    updateTrabajador,
    //loginTrabajador
} from '../controllers/trabajadorController.js';

const trabajadorRouter = Router ();

trabajadorRouter.get('/api/getTrabajadores', getTrabajadores);
trabajadorRouter.get('/api/getTrabajador/:id', getTrabajador);
trabajadorRouter.post('/api/createTrabajador', createTrabajador);
trabajadorRouter.delete('/api/deleteTrabajador/:id', deleteTrabajador);
trabajadorRouter.put('/api/updateTrabajador/:id', updateTrabajador);
//clienteRouter.post('/api/loginCliente', loginTrabajador);

export default trabajadorRouter;