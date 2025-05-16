import { db } from "../database/db.js";
import jwt from "jsonwebtoken";
import { v4 as uuidv4 } from "uuid";

export const getPublicaciones = async (req, res) => {
  try {
    const result = await db.query("SELECT * FROM publicacion_necesidad");
    res.json(result.rows);
  } catch (error) {
    return res
      .status(500)
      .json({ message: "Error interno del servidor", error: error.message });
  }
};

export const getPublicacion = async (req, res) => {
  try {
  console.log(req.params.id);

    const result = await db.query(
      "SELECT * FROM publicacion_necesidad WHERE id = $1",
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
export const getPublicacionesByUserId = async (req, res) => {
  try {
  console.log(req.params.id);

    const result = await db.query(
      "SELECT * FROM publicacion_necesidad WHERE id_cliente = $1",
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


export const createPublicacion = async (req, res) => {
  console.log(req.body);
  try {
    const {
      id_cliente,
      id_categoria,
      titulo,
      descripcion_necesidad,
      ubicacion,
      presupuesto,
      fecha_publicacion,
      estado
    } = req.body;

    // Validación de campos obligatorios
    if (!id_cliente || !id_categoria || !titulo || !descripcion_necesidad || !ubicacion || !presupuesto || !estado) {
      return res.status(400).json({ message: "Faltan campos obligatorios." });
    }

    // Validar que el cliente exista
    const clienteCheck = await db.query("SELECT id FROM cliente WHERE id = $1", [id_cliente]);
    if (clienteCheck.rowCount === 0) {
      return res.status(404).json({ message: "El cliente no existe." });
    }

    // Validar que la categoría exista
    const categoriaCheck = await db.query("SELECT id FROM categoria_trabajo WHERE id = $1", [id_categoria]);
    console.log(categoriaCheck);

    if (categoriaCheck.rowCount === 0) {
      return res.status(404).json({ message: "La categoría no existe." });
    }
    // Generar ID con uuidv4
    const id = uuidv4();

    // Insertar la publicación
    const query = `
      INSERT INTO publicacion_necesidad 
      (id, id_cliente, id_categoria, titulo, descripcion_necesidad, ubicacion, presupuesto, fecha_publicacion, estado)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
    `;

    await db.query(query, [
      id,
      id_cliente,
      id_categoria,
      titulo,
      descripcion_necesidad,
      ubicacion,
      presupuesto,
      fecha_publicacion || new Date(),
      estado
    ]);
    res.status(201).json({
      id,
      id_cliente,
      id_categoria,
      titulo,
      descripcion_necesidad,
      ubicacion,
      presupuesto,
      fecha_publicacion: fecha_publicacion || new Date(),
      estado,
      mensaje: "Publicación creada exitosamente"
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error interno del servidor", error: error.message });
  }
};



export const updatePublicacion = async (req, res) => {
  try {
    const keys = Object.keys(req.body);
    const values = Object.values(req.body);

    // Construye dinámicamente el SET usando los índices $1, $2, ...
    const setClause = keys.map((key, index) => `${key} = $${index + 1}`).join(", ");

    // Añade el valor de ID al final para usarlo como último parámetro
    values.push(req.params.id);

    const query = `UPDATE publicacion_necesidad SET ${setClause} WHERE id = $${values.length}`;

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


export const deletePublicacion = async (req, res) => {
  try {
    const result = await db.query(
      "DELETE FROM publicacion_necesidad WHERE id = $1",
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
