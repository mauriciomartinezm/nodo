import usuarioRouter from "./routes/usuariosRoutes.js";
import publicacionRouter from "./routes/publicacionesRoutes.js";
import categoriaRouter from "./routes/categoriasRoutes.js";
import firebaseRouter from "./routes/firebaseRoutes.js";
import express from "express";
import cors from "cors";
import notificacionRouter from "./routes/notificacionesRoutes.js"; //Con redis

const app = express();
app.use(cors());
app.use(express.json());

const port = 3001;

// Configuración de CORS

// Configuración del body parser para manejar las solicitudes JSON
app.use(usuarioRouter);
app.use(publicacionRouter);
app.use(categoriaRouter);
app.use(firebaseRouter);
app.use(notificacionRouter);
// Inicia el servidor
app.listen(port, "0.0.0.0", () => {
  console.log(`Server running on port ${port}`);
});