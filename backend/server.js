import clienteRouter from "./routes/clienteRoute.js";
import trabajadorRouter from "./routes/trabajadorRoute.js";

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

/*// Configuración de la conexión a la base de datos MySQL
export const pool = createPool({
  host: "b6737tipdo8cxkuodyo9-mysql.services.clever-cloud.com",
  port: "3306",
  user: "uhim7e19cwvekoxv",
  password: "UwYce5Nw2VF3UkEeDsi3",
  database: "b6737tipdo8cxkuodyo9",
});*/
// Inicia el servidor
app.listen(port, "0.0.0.0", () => {
  console.log(`Server running on port ${port}`);
});