import { db } from "../database/db.js";
import jwt from "jsonwebtoken";
import { v4 as uuidv4 } from "uuid";
import { guardarNotificacion } from '../services/notificacionService.js';

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
      id_categoria,
      ubicacion,
      presupuesto,
      fecha_limite,
      descripcion_necesidad,
      fotos // Este parámetro puede ser undefined
    } = req.body;
    // Asignar valor por defecto si no hay fotos
    const fotosFinal = fotos || "sin fotos"; // Esto asigna "sin fotos" si fotos es falsy (undefined, null, etc.)

    // Validación de campos obligatorios (quitamos fotos de la validación)
    if (!id_cliente || !id_categoria || !titulo || !descripcion_necesidad || !ubicacion || !presupuesto || !fecha_limite) {
      return res.status(400).json({ message: "Faltan campos obligatorios." });
    }

    // Validar que el cliente exista
    const clienteCheck = await db.query("SELECT id FROM Usuario WHERE id = $1", [id_cliente]);
    if (clienteCheck.rowCount === 0) {
      return res.status(404).json({ message: "El Cliente no existe." });
    }

    // Validar que la categoría exista
    const categoriaCheck = await db.query("SELECT * FROM Categoria WHERE id = $1", [id_categoria]);
    console.log("Categoria: ");
    console.log(categoriaCheck);

    if (categoriaCheck.rowCount === 0) {
      return res.status(404).json({ message: "La categoría no existe." });
    }

    // Guardar el nombre de la categoría
    const nombreCategoria = categoriaCheck.rows[0].nombre_cat;

    // Generar ID con uuidv4
    const id = uuidv4();

    // Insertar la publicación
    const query = `
      INSERT INTO publicacion 
      (id, id_cliente, id_categoria, titulo, descripcion_necesidad, ubicacion, presupuesto, fecha_publicacion, fecha_limite, estado, fotos)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 'pendiente', $10)
    `;

    await db.query(query, [
      id,
      id_cliente,
      id_categoria,
      titulo,
      descripcion_necesidad,
      ubicacion,
      presupuesto,
      new Date(), // fecha_publicacion
      fecha_limite,
      fotosFinal // Usamos la variable con el valor por defecto
    ]);

    res.status(201).json({
      id,
      id_cliente,
      id_categoria,
      titulo,
      descripcion_necesidad,
      ubicacion,
      presupuesto,
      fecha_limite,
      fotos: fotosFinal, // Enviamos el valor que se guardó
      mensaje: "Publicación creada exitosamente"
    });

    // --- ENVIAR NOTIFICACIONES A TRABAJADORES ---
    // 1. Buscar trabajadores con la misma id_categoria
    const trabajadoresQuery = `
      SELECT id FROM Usuario WHERE id_categoria = $1
    `;
    const trabajadoresResult = await db.query(trabajadoresQuery, [id_categoria]);
    let trabajadoresIds = trabajadoresResult.rows.map(row => row.id);
    console.log("Trabajadores IDs antes de filtrar: ", trabajadoresIds);

    // 2. Filtrar el id_cliente (dueño de la publicación) de la lista de trabajadores
    console.log(id_cliente);
    trabajadoresIds = trabajadoresIds.filter(trabajadorId => trabajadorId !== id_cliente);

    console.log("Trabajadores IDs después de filtrar (excluyendo al dueño): ", trabajadoresIds);
    // 2. Enviar notificación a cada trabajador
    for (const trabajadorId of trabajadoresIds) {
      try {
        await guardarNotificacion(
          trabajadorId,
          'oferta',
          'Nueva oportunidad laboral',
          `¡Se encuentra disponible una nueva oportunidad laboral en la categoría ${nombreCategoria}!`, // Customize the message
          {
            publicacionId: id.toString(),
            trabajadorId: trabajadorId.toString()
          }
        );
        console.log(`Notificación enviada al trabajador con ID: ${trabajadorId} para la publicación: ${id}`);
      } catch (notificationError) {
        console.error(`Error enviando notificación al trabajador ${trabajadorId}:`, notificationError);
        // Decide how to handle individual notification failures (e.g., log, but continue to next worker)
      }
    }
    // --- FIN DE NOTIFICACIONES ---

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

