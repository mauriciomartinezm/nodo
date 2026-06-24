import { db } from "../database/db.js";
import jwt from "jsonwebtoken";
import { v4 as uuidv4 } from "uuid";

export const getReports = async (req, res) => {
    console.log("Peticion recibida en /getReports");

    try {
        const result = await db.query("SELECT * FROM reporte");
        res.json(result.rows);
    } catch (error) {
        return res
            .status(500)
            .json({ message: "Error interno del servidor", error: error.message });
    }
};

export const getReport = async (req, res) => {
    console.log("Peticion recibida en /getReport");

    try {
        console.log(req.params.id);

        const result = await db.query(
            "SELECT * FROM reporte WHERE id = $1",
            [req.params.id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ message: "No existen registros" });
        }

        res.json(result.rows[0]);
    } catch (error) {
        if (!res.headersSent) {
            res.status(500).json({ message: error.message });
        }
    }
};
export const getReportByPostId = async (req, res) => {
    console.log("Peticion recibida en /getReportByPostId");

    try {
        console.log(req.params.id);

        const result = await db.query(
            "SELECT * FROM reporte WHERE id_publicacion = $1",
            [req.params.id]
        );

        if (result.rows.length === 0) {
            return res.status(200).json({ message: "No existen registros" });
        }

        res.json(result.rows);
    } catch (error) {
        if (!res.headersSent) {
            res.status(500).json({ message: error.message });
        }
    }
};
//
export const createReport = async (req, res) => {
    console.log("Peticion recibida en /createReport, cuerpo de la peticion: ");
    console.log(req.body);
    try {
        const {
            id_publicacion,
            razon
        } = req.body;

        // Validación de campos obligatorios (quitamos fotos de la validación)
        if (!id_publicacion || !razon ) {
            return res.status(400).json({ message: "Faltan campos obligatorios." });
        }

        // Validar que la publicacion exista
        const postCheck = await db.query("SELECT id FROM publicacion WHERE id = $1", [id_publicacion]);
        if (postCheck.rowCount === 0) {
            return res.status(404).json({ message: "La publicacion no existe." });
        }

        // Generar ID con uuidv4
        const id = uuidv4();

        // Insertar la publicación
        const query = `
      INSERT INTO reporte
      (id, id_publicacion, razon)
      VALUES ($1, $2, $3)
    `;

        await db.query(query, [
            id,
            id_publicacion,
            razon
        ]);

        res.status(201).json({
            id,
            id_publicacion,
            razon,
            mensaje: "Reporte creado exitosamente"
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error interno del servidor", error: error.message });
    }
};
