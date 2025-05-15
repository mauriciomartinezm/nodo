import clienteRouter from "./routes/clienteRoute.js";
import trabajadorRouter from "./routes/trabajadorRoute.js";
import publicacionRouter from "./routes/publicacionRoute.js";

import express from "express";
import cors from "cors";

const app = express();
app.use(cors());
app.use(express.json());

const port = 3000;

// Configuración de CORS

// Configuración del body parser para manejar las solicitudes JSON
app.use(clienteRouter);
app.use(trabajadorRouter);
app.use(publicacionRouter);

// Inicia el servidor
app.listen(port, "0.0.0.0", () => {
  console.log(`Server running on port ${port}`);
});