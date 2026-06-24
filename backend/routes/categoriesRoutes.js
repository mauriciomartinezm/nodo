import {Router} from 'express';
import {
    getCategories,
    getCategory,
    createCategory,
    createUserCategory,
    getUserCategories
} from '../controllers/categoryController.js';

const categoryRouter = Router ();

categoryRouter.get('/api/getCategories', getCategories);
categoryRouter.get('/api/getCategory/:id', getCategory);
categoryRouter.post('/api/createCategory', createCategory);
categoryRouter.post('/api/createUserCategory', createUserCategory);
categoryRouter.get('/api/getUserCategories', getUserCategories);

export default categoryRouter;
