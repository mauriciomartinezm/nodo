import clienteRouter from "./routes/clienteRoute.js";
import restaurantRouter from "./routes/restaurantRoute.js";
import categoriaRouter from "./routes/categoriaRoute.js";
import horarioRouter from "./routes/horarioRoute.js";
//import { createPool } from "mysql2/promise";
import express from "express";
import cors from "cors";
import resenaRouter from "./routes/resenaRoute.js";
import reservaRouter from "./routes/reservaRoute.js";
import productoRouter from "./routes/productoRoute.js";
import socioRouter from "./routes/socioRoute.js";
import pedidoRouter from "./routes/pedidoRoute.js";

const app = express();
app.use(cors());
app.use(express.json());

const port = 3000;

// Configuración de CORS

// Configuración del body parser para manejar las solicitudes JSON
app.use(clienteRouter);
app.use(restaurantRouter);
app.use(categoriaRouter);
app.use(horarioRouter);
app.use(resenaRouter);
app.use(reservaRouter);
app.use(productoRouter);
app.use(socioRouter);
app.use(pedidoRouter);
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