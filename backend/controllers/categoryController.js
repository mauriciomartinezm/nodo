import { db } from "../database/db.js";
import { v4 as uuidv4 } from "uuid";
import jwt from "jsonwebtoken";

export const getCategory = async (req, res) => {
  console.log("Peticion en getCategory");
  try {
    const result = await db.query(
      "SELECT * FROM Categoria WHERE id = $1",
      [req.params.id]
    );
    res.json(result.rows[0]);
  } catch (error) {
    return res
      .status(500)
      .json({ message: "Error interno del servidor", error: error.message });
  }
};

export const getCategories = async (req, res) => {
  console.log("Peticion en getCategories");
  try {
    const result = await db.query("SELECT * FROM Categoria");
    res.json(result.rows);
  } catch (error) {
    return res
      .status(500)
      .json({ message: "Error interno del servidor", error: error.message });
  }
};

export const createCategory = async (req, res) => {
  console.log("Peticion recibida en /createCategory. Cuerpo de la petición: ");
  console.log(req.body);
  try {
    const { nombre, descripcion } = req.body;
    const id = uuidv4();
    const query = `
      INSERT INTO Categoria (id, nombre_categoria, descripcion)
      VALUES ($1, $2, $3)
    `;

    await db.query(query, [id, nombre, descripcion]);

    res
      .status(200)
      .json({
        message: "Categoria registrada exitosamente",
        categoria: { id, nombre, descripcion },
      });
  } catch (error) {
    console.error("Error al crear la categoria:", error);
    res
      .status(500)
      .json({
        message: "Error al registrar la categoria",
        error: error.message,
      });
  }
};

export const getUserCategories = async (req, res) => {
  console.log("Peticion en getUserCategories");
  try {
    const result = await db.query("SELECT * FROM usuario_categoria");
    res.json(result.rows);
  } catch (error) {
    return res
      .status(500)
      .json({ message: "Error interno del servidor", error: error.message });
  }
};

export const createUserCategory = async (req, res) => {
  console.log("📥 Petición recibida en /createUserCategory");
  console.log(req.body);

  const { id_usuario, id_categorias } = req.body;

  if (!id_usuario || !Array.isArray(id_categorias) || id_categorias.length === 0) {
    return res.status(400).json({
      message: "Debe enviar un id_usuario y un arreglo id_categorias con al menos un elemento.",
    });
  }

  try {
    await db.query("BEGIN");

    for (const categoryId of id_categorias) {
      console.log(`🟢 Insertando categoría ${categoryId}`);
      await db.query(
        "INSERT INTO usuario_categoria (id_usuario, id_categoria) VALUES ($1, $2)",
        [id_usuario, categoryId.trim()]
      );
      console.log(`✅ Categoría ${categoryId} registrada`);
    }

    await db.query("COMMIT");

    console.log(`✅ ${id_categorias.length} categorías registradas correctamente para el usuario ${id_usuario}`);

    res.status(200).json({
      message: "Categorías asignadas correctamente al usuario.",
      data: { id_usuario, id_categorias },
    });

  } catch (error) {
    await db.query("ROLLBACK");
    console.error("❌ Error al registrar usuario_categoria:", error.message);
    res.status(500).json({
      message: "Error al registrar las categorías del usuario.",
      error: error.message,
    });
  }
};

