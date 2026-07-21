import {Router} from 'express';
import {
    finishJob,
} from '../controllers/jobController.js';

const jobRouter = Router ();

jobRouter.put('/api/finishJob', finishJob);

export default jobRouter;
