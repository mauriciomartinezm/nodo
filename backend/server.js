import usuarioRouter from "./routes/usuariosRoutes.js";
import publicacionRouter from "./routes/publicacionesRoutes.js";
import categoriaRouter from "./routes/categoriasRoutes.js";
import notificacionRouter from "./routes/notificacionesRoutes.js"; //Con redis
import postulacionRouter from "./routes/postulacionRoutes.js";
import tokenRouter from "./routes/tokenRoutes.js";
import reporteRouter from "./routes/reportesRoutes.js";
import trabajoRouter from "./routes/trabajosRoutes.js";
import express from "express";
import cors from "cors";

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3001;

// Configuración de CORS

// Configuración del body parser para manejar las solicitudes JSON
app.use(usuarioRouter);
app.use(publicacionRouter);
app.use(categoriaRouter);
app.use(notificacionRouter);
app.use(postulacionRouter);
app.use(tokenRouter);
app.use(reporteRouter);
app.use(trabajoRouter);


// Inicia el servidor
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${port}`);
});