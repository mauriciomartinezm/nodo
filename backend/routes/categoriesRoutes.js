import {Router} from 'express';
import {
    getGeneralCategories,
    getGeneralCategory,
    createGeneralCategory,
    getSpecificCategories,
    getSpecificCategory,
    createSpecificCategory,
    getWorkerCategories,
    createWorkerCategory
} from '../controllers/categoryController.js';

const categoryRouter = Router ();

categoryRouter.get('/api/getGeneralCategories', getGeneralCategories);
categoryRouter.get('/api/getGeneralCategory/:id', getGeneralCategory);
categoryRouter.post('/api/createGeneralCategory', createGeneralCategory);

categoryRouter.get('/api/getSpecificCategories', getSpecificCategories);
categoryRouter.get('/api/getSpecificCategory/:id', getSpecificCategory);
categoryRouter.post('/api/createSpecificCategory', createSpecificCategory);

categoryRouter.get('/api/getWorkerCategories', getWorkerCategories);
categoryRouter.post('/api/createWorkerCategory', createWorkerCategory);

export default categoryRouter;
