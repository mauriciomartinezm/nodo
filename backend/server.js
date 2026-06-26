import userRouter from "./routes/usersRoutes.js";
import postRouter from "./routes/postsRoutes.js";
import categoryRouter from "./routes/categoriesRoutes.js";
import notificationRouter from "./routes/notificationsRoutes.js"; //Con redis
import applicationRouter from "./routes/applicationsRoutes.js";
import tokenRouter from "./routes/tokenRoutes.js";
import reportRouter from "./routes/reportsRoutes.js";
import jobRouter from "./routes/jobsRoutes.js";
import storageRoutes from "./routes/storageRoutes.js";
import locationRouter from "./routes/locationsRoutes.js";
import express from "express";
import cors from "cors";

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3001;

// Configuración de CORS

// Configuración del body parser para manejar las solicitudes JSON
app.use(userRouter);
app.use(postRouter);
app.use(categoryRouter);
app.use(notificationRouter);
app.use(applicationRouter);
app.use(tokenRouter);
app.use(reportRouter);
app.use(jobRouter);
app.use(storageRoutes);
app.use(locationRouter);

// Inicia el servidor
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});
