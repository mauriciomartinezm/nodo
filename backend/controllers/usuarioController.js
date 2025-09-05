import { db } from "../database/db.js";
import { v4 as uuidv4 } from "uuid";
import jwt from "jsonwebtoken";
//
export const getUsuarios = async (req, res) => {
  try {
    const result = await db.query("SELECT * FROM Usuario");
    res.json(result.rows);
  } catch (error) {
    return res
      .status(500)
      .json({ message: "Error interno del servidor", error: error.message });
  }
};

export const getUsuario = async (req, res) => {
  try {
    const result = await db.query(
      "SELECT * FROM Usuario WHERE id = $1",
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

//Este createUsuario es dinámico. Este subprograma recibe los datos que se envía desde
//el frontend y va creando el query automáticamente
//El id se crea desde el backend con uuidv4
export const createUsuario = async (req, res) => {
  try {
    const data = req.body;
    //console.log(data);
    data.fecha_registro = new Date(new Date().getTime() - 5 * 60 * 60 * 1000); // UTC-5

    data.verificado = false; //Cualquier tipo de usuario recien creado por defecto tendrá false en verificado

    if (!data.id) {
      return res.status(400).json({ message: "El campo 'id' es obligatorio" });
    }
    // Obtener columnas y valores dinámicamente
    const columnas = Object.keys(data);                    // ["id", "nombre", "fecha_registro", ...]
    const valores = Object.values(data);                   // [123, "Juan", Date, false, ...]
    const placeholders = columnas.map((_, i) => `$${i + 1}`); // ["$1", "$2", "$3", ...]

    const query = `
      INSERT INTO Usuario (${columnas.join(', ')})
      VALUES (${placeholders.join(', ')})
    `;

    await db.query(query, valores);

    res.status(200).json({ message: "Usuario registrado exitosamente", usuario: data });
  } catch (error) {
    console.error("Error al crear Usuario:", error);
    res.status(500).json({ message: "Error al registrar usuario", error: error.message });
  }
};


export const loginUsuario = async (req, res) => {
  console.log("Peticion recibida en /loginUsuario")
  const { identificador, contrasena } = req.body; // puede ser teléfono o email

  try {
    const result = await db.query(
      "SELECT * FROM Usuario WHERE (telefono = $1 OR email = $1) AND contrasena = $2",
      [identificador, contrasena]
    );
    if (result.rows.length === 1) {
      const usuario = result.rows[0];
      
      console.log("Inicio de sesión exitoso");
      return res.status(200).json({
        messageSuccess: "Inicio de sesión exitoso",
        usuario: usuario,
      });
    } else {
      return res.status(401).json({ messageFail: "Credenciales inválidas" });
    }
  } catch (error) {
    console.error("Error en loginUsuario:", error);
    return res.status(500).json({ messageFail: "Error en el servidor", error: error.message });
  }
};


export const updateUsuario = async (req, res) => {
  try {
    const keys = Object.keys(req.body);
    const values = Object.values(req.body);
    // Construye dinámicamente el SET usando los índices $1, $2, ...
    const setClause = keys.map((key, index) => `${key} = $${index + 1}`).join(", ");

    // Añade el valor de ID al final para usarlo como último parámetro
    values.push(req.params.id);

    const query = `UPDATE Usuario SET ${setClause} WHERE id = $${values.length}`;

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
export const deleteUsuario = async (req, res) => {
  try {
    const result = await db.query(
      "DELETE FROM Usuario WHERE id = $1",
      [req.params.id]
    );
    if (result.rowCount === 0) {
      return res.status(404).json({ message: "No se encuentra registrado" });
    }

    res.json({ message: "Registro eliminado exitosamente" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};
