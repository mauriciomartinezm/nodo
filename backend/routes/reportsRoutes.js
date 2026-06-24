import {Router} from 'express';
import {
    getReports,
    getReport,
    getReportByPostId,
    createReport
} from '../controllers/reporteController.js';

const reportRouter = Router ();

reportRouter.get('/api/getReports', getReports);
reportRouter.get('/api/getReport/:id', getReport);
reportRouter.get('/api/getReportByPostId/:id', getReportByPostId);
reportRouter.post('/api/createReport', createReport);

export default reportRouter;
