import {Router} from 'express';
import {
    getPosts,
    getPostsForWorker,
    getPost,
    getPostsByUserId,
    createPost,
    deletePost,
    updatePost,
    addPostPhotos
} from '../controllers/postController.js';

const postRouter = Router ();

postRouter.get('/api/getPosts', getPosts);
postRouter.get('/api/getPostsForWorker/:workerId', getPostsForWorker);
postRouter.get('/api/getPost/:id', getPost);
postRouter.get('/api/getPostsByUserId/:id', getPostsByUserId);
postRouter.post('/api/createPost', createPost);
postRouter.delete('/api/deletePost/:id', deletePost);
postRouter.put('/api/updatePost/:id', updatePost);
postRouter.post('/api/addPostPhotos/:id', addPostPhotos);

export default postRouter;
