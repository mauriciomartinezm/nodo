import {Router} from 'express';
import {
    getUsers,
    getUser,
    createUser,
    deleteUser,
    updateUser,
    activateWorker,
    login,
    resetPassword,
} from '../controllers/userController.js';

const userRouter = Router ();

userRouter.get('/api/getUsers', getUsers);
userRouter.get('/api/getUser/:id', getUser);
userRouter.post('/api/createUser', createUser);
userRouter.delete('/api/deleteUser/:id', deleteUser);
userRouter.put('/api/updateUser/:id', updateUser);
userRouter.post('/api/activateWorker/:id', activateWorker);
userRouter.post('/api/login', login);
userRouter.post('/api/resetPassword', resetPassword);

export default userRouter;
