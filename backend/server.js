import userRouter from "./routes/usuariosRoutes.js";
import postRouter from "./routes/publicacionesRoutes.js";
import categoryRouter from "./routes/categoriasRoutes.js";
import notificationRouter from "./routes/notificacionesRoutes.js"; //Con redis
import applicationRouter from "./routes/postulacionRoutes.js";
import tokenRouter from "./routes/tokenRoutes.js";
import reportRouter from "./routes/reportesRoutes.js";
import jobRouter from "./routes/trabajosRoutes.js";
import storageRoutes from "./routes/storageRoutes.js";
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

// Inicia el servidor
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});
