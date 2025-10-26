// routes/storageRoutes.js
import express from "express";
import { generarUrlSubida } from "../services/storageService.js";

const storageRoutes = express.Router();

storageRoutes.get("/api/generarUrlSubida", async (req, res) => {
  try {
    const { nombreArchivo } = req.query;

    if (!nombreArchivo) {
      return res.status(400).json({ error: "Falta el parámetro nombreArchivo" });
    }

    const url = await generarUrlSubida(nombreArchivo);
    res.json({ url });
  } catch (error) {
    console.error("Error generando URL firmada:", error);
    res.status(500).json({ error: "Error generando URL firmada" });
  }
});

export default storageRoutes;
