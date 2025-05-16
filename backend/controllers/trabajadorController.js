import { db } from "../database/db.js";
import { v4 as uuidv4 } from "uuid";
import jwt from "jsonwebtoken";

export const getTrabajadores = async (req, res) => {
  try { 
    const result = await db.query("SELECT * FROM Trabajador");
    res.json(result.rows);
  } catch (error) {
    return res
      .status(500)
      .json({ message: "Error interno del servidor", error: error.message });
  }
};

export const getTrabajador = async (req, res) => {
  try {
  console.log(req.params.id);

    const result = await db.query(
      "SELECT * FROM Trabajador WHERE id = $1",
      [req.params.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "No existen registros" });
    }

    res.json(result.rows);
  } catch (error) {
    if (!res.headersSent) {
      res.status(500).json({ message: error.message });
    }
  }
};
export const getTrabajadorByUserId = async (req, res) => {
  try {
  console.log(req.params.id);

    const result = await db.query(
      "SELECT * FROM Trabajador WHERE id_usuario = $1",
      [req.params.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "No existen registros" });
    }

    res.json(result.rows);
  } catch (error) {
    if (!res.headersSent) {
      res.status(500).json({ message: error.message });
    }
  }
};
//

export const createTrabajador = async (req, res) => {
  try {
    const {
      id_usuario,
      habilidad,
      experiencia,
      calificacion_promedio,
      disponibilidad,
      ubicacion,
      verificado,
    } = req.body;

    // Validar que el cliente exista antes de crear el trabajador
    const userCheck = await db.query('SELECT 1 FROM cliente WHERE id = $1', [id_usuario]);
    if (userCheck.rowCount === 0) {
      return res.status(400).json({ message: "El cliente especificado no existe." });
    }
    const id = uuidv4();

    const query = `
      INSERT INTO trabajador (
        id,
        id_usuario,
        habilidad,
        experiencia,
        calificacion_promedio,
        disponibilidad,
        ubicacion,
        verificado
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
    `;

    await db.query(query, [
      id,
      id_usuario,
      habilidad,
      experiencia,
      calificacion_promedio,
      disponibilidad,
      ubicacion,
      verificado
    ]);

    res.status(200).json({
      message: "Trabajador creado exitosamente",
      trabajador: {
        id,
        id_usuario,
        habilidad,
        experiencia,
        calificacion_promedio,
        disponibilidad,
        ubicacion,
        verificado
      }
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};


export const updateTrabajador = async (req, res) => {
  try {
    const keys = Object.keys(req.body);
    const values = Object.values(req.body);

    // Construye dinámicamente el SET usando los índices $1, $2, ...
    const setClause = keys.map((key, index) => `${key} = $${index + 1}`).join(", ");

    // Añade el valor de ID al final para usarlo como último parámetro
    values.push(req.params.id);

    const query = `UPDATE Trabajador SET ${setClause} WHERE id = $${values.length}`;

    const result = await db.query(query, values);

    if (result.rowCount === 0) {
      return res.status(404).json({ message: "No se encuentra registrado" });
    }

    res.json({ message: "Datos actualizados exitosamente" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};


export const deleteTrabajador = async (req, res) => {
  try {
    const result = await db.query(
      "DELETE FROM Trabajador WHERE id = $1",
      [req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "No se encuentra registrado" });
    }

    res.json({ message: "Registro eliminado exitosamente" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
