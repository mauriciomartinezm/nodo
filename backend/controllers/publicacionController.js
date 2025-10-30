import { db } from "../database/db.js";
import jwt from "jsonwebtoken";
import { v4 as uuidv4 } from "uuid";
import { guardarNotificacion } from '../services/notificacionService.js';
import { notificarTrabajadoresPorCategorias } from "../services/notificacionService.js";
export const getPublicaciones = async (req, res) => {
  try {
    const result = await db.query("SELECT * FROM publicacion");
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
      "SELECT * FROM publicacion WHERE id = $1",
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
      "SELECT * FROM publicacion WHERE id_cliente = $1",
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


export const createPublicacion = async (req, res) => {
  console.log("Petición en /createPublicacion. Cuerpo de la petición: ");
  console.log(req.body);

  try {
    const {
      id_cliente,
      titulo,
      id_categorias, // 👈 ahora es un arreglo de IDs
      ubicacion,
      presupuesto,
      fecha_limite,
      descripcion_necesidad,
      fotos
    } = req.body;

    // Valor por defecto para fotos
    const fotosFinal = fotos || "sin fotos";

    // Validar campos obligatorios
    if (!id_cliente || !id_categorias || !Array.isArray(id_categorias) || id_categorias.length === 0 ||
        !titulo || !descripcion_necesidad || !ubicacion || !presupuesto || !fecha_limite) {
      return res.status(400).json({ message: "Faltan campos obligatorios o categorías inválidas." });
    }

    // Validar que el cliente exista
    const clienteCheck = await db.query("SELECT id FROM Usuario WHERE id = $1", [id_cliente]);
    if (clienteCheck.rowCount === 0) {
      return res.status(404).json({ message: "El Cliente no existe." });
    }

    // Validar que todas las categorías existan
    const categoriasQuery = `
      SELECT id, nombre FROM Categoria WHERE id = ANY($1)
    `;
    const categoriasResult = await db.query(categoriasQuery, [id_categorias]);

    if (categoriasResult.rowCount !== id_categorias.length) {
      return res.status(404).json({ message: "Una o más categorías no existen." });
    }

    // Generar ID para la publicación
    const id = uuidv4();

    // Insertar publicación (sin id_categoria)
    const queryPublicacion = `
      INSERT INTO publicacion 
      (id, id_cliente, titulo, descripcion_necesidad, ubicacion, presupuesto, fecha_publicacion, fecha_limite, estado, fotos)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, 'pendiente', $9)
    `;
    await db.query(queryPublicacion, [
      id,
      id_cliente,
      titulo,
      descripcion_necesidad,
      ubicacion,
      presupuesto,
      new Date(),
      fecha_limite,
      fotosFinal
    ]);

    // Insertar las relaciones en publicacion_categoria
    for (const idCat of id_categorias) {
      await db.query(
        "INSERT INTO publicacion_categoria (id_publicacion, id_categoria) VALUES ($1, $2)",
        [id, idCat]
      );
    }

    // --- LLAMAR SUBPROGRAMA DE NOTIFICACIONES ---
    await notificarTrabajadoresPorCategorias(id, id_cliente, id_categorias, categoriasResult);

    // --- RESPUESTA ---
    res.status(201).json({
      id,
      id_cliente,
      id_categorias,
      titulo,
      descripcion_necesidad,
      ubicacion,
      presupuesto,
      fecha_limite,
      fotos: fotosFinal,
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
    const publicacionId = req.params.id;
    values.push(publicacionId);

    const query = `UPDATE publicacion SET ${setClause} WHERE id = $${values.length}`;

    const result = await db.query(query, values);

    if (result.rowCount === 0) {
      return res.status(404).json({ message: "No se encuentra registrado" });
    }

    // 🔔 Si se está actualizando el estado a "finalizada"
    /*if (req.body.estado && req.body.estado === "finalizada") {
      // Obtener el id_cliente de la publicación
      const trabajadorResult = await db.query(
        `SELECT id_trabajador FROM Postulacion WHERE id_publicacion = $1`,
        [publicacionId]
      );

      if (trabajadorResult.rows.length > 0) {
        const idTrabajador = trabajadorResult.rows[0].id_trabajador;

        // 🔔 Aquí puedes llamar una función para enviar la notificación
        await guardarNotificacion(
          idTrabajador,
          'trabajo completado',
          'Trabajo finalizado',
          'Tu trabajo ha sido finalizada con éxito. ¡No olvides dejar tu reseña!',
          { publicacionId: req.params.id }
        );

      }
    }*/

    res.json({ message: "Datos actualizados exitosamente" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};


export const deletePublicacion = async (req, res) => {
  try {
    const client = await db.connect(); // Inicia conexión manual si usas pool

    await client.query('BEGIN'); // Comienza transacción

    // 1. Eliminar las postulaciones asociadas
    await client.query(
      'DELETE FROM postulacion WHERE id_publicacion = $1',
      [req.params.id]
    );

    // 2. Eliminar la publicación
    const result = await client.query(
      'DELETE FROM publicacion WHERE id = $1',
      [req.params.id]
    );

    await client.query('COMMIT'); // Confirma transacción
    client.release();

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'No se encuentra registrado' });
    }

    res.json({ message: 'Registro eliminado exitosamente' });

  } catch (error) {
    await client.query('ROLLBACK'); // Revierte si hay error
    client.release();
    res.status(500).json({ message: error.message });
  }
};

