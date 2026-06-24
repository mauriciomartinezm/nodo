import {Router} from 'express';
import {
    apply,
    getApplication,
    getApplications,
    getApplicationsByUserId,
    getApplicationsByPostId,
    updateApplication,
    deleteApplication
} from '../controllers/applicationController.js';

const applicationRouter = Router ();

applicationRouter.post('/api/apply', apply);
applicationRouter.get('/api/getApplication/:id', getApplication);
applicationRouter.get('/api/getApplications', getApplications);
applicationRouter.get('/api/getApplicationsByUserId/:id', getApplicationsByUserId);
applicationRouter.get('/api/getApplicationsByPostId/:id', getApplicationsByPostId);
applicationRouter.put('/api/updateApplication/:id', updateApplication);
applicationRouter.delete('/api/deleteApplication/:id', deleteApplication);

export default applicationRouter;
