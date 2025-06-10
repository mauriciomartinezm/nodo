import { db } from "../database/db.js";
import { v4 as uuidv4 } from "uuid";
import jwt from "jsonwebtoken";

export const getCategorias = async (req, res) => {
  console.log("Peticion en getCategorias");
  try {
    const result = await db.query("SELECT * FROM Categoria");
    res.json(result.rows);
  } catch (error) {
    return res
      .status(500)
      .json({ message: "Error interno del servidor", error: error.message });
  }
};
/*
export const getCliente = async (req, res) => {
  try {
  console.log(req.params.id);

    const result = await db.query(
      "SELECT * FROM Cliente WHERE id = $1",
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
//como el registro tiene varios pasos se debe de hacer de otra manera
/*export const createCliente = async (req, res) => {
  try {
    const {
      id,
      nombre,
      email,
      contrasena,
      fecha_registro,
      foto_perfil,
      telefono,
      verificado
    } = req.body;
    const query =
      "INSERT INTO Cliente (id, nombre, email, contraseña, fecha_registro, foto_perfil, telefono, verificado) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)";
    await db.query(query, [
      id,
      nombre,
      email,
      contrasena,
      fecha_registro,
      foto_perfil,
      telefono,
      verificado
    ]);

    res.status(200).json({
      id,
      nombre,
      email,
      contrasena,
      fecha_registro,
      foto_perfil,
      telefono,
      verificado,
      mensaje: "Datos guardados exitosamente",
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};*/

export const createCategoria = async (req, res) => {
  console.log(req.body);
  try {
    const { nombre_cat, descripcion } = req.body;
    const id = uuidv4();
    const query = `
      INSERT INTO Categoria (id, nombre_cat, descripcion)
      VALUES ($1, $2, $3)
    `;

    await db.query(query, [id, nombre_cat, descripcion]);

    res
      .status(200)
      .json({
        message: "Categoria registrada exitosamente",
        categoria: { id, nombre_cat, descripcion },
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

/*
export const loginCliente = async (req, res) => {
  const { telefono, contrasena } = req.body;

  try {
    const result = await db.query(
      "SELECT * FROM Cliente WHERE telefono = $1 AND contraseña = $2",
      [telefono, contrasena]
    );
    //console.log(result.rows);

    if (result.rows.length === 1) {
      const cliente = result.rows[0];
      //const payload = {
      //  id: user.id,
      //  nombre: user.nombre,
      //  apellido: user.apellido,
      //  correo: user.correo,
      //  imagen_perfil: user.imagen_perfil,
      //  telefono: user.telefono,
      //  direccion: user.direccion,
      //  fecha_nacimiento: user.fecha_nacimiento,
      //  preferencias: user.preferencias,
      //};
      //
      //const token = jwt.sign(payload, process.env.JWT_SECRET);
      //
      return res.status(200).json({
        messageSuccess: "Inicio de sesión exitoso",
        //token,
        cliente: cliente
        //{
          //id: user.id,
          //nombre: user.nombre,
          //email: user.email,
          //contrasena: user.contraseña,
          //fecha_registro: user.fecha_registro,
          //foto_perfil: user.foto_perfil,
          //telefono: user.telefono,
          //verificado: user.verificado,
          //id_cliente: user.id_cliente,
        //},
      });
    } else {
      return res.status(401).json({ messageFail: "Credenciales inválidas" });
    }
  } catch (error) {
    return res.status(401).json({ unknown: error });
  }
};
*/
/* lo mismo que en la anterior, como el registro tiene varios pasos se debe de hacer un update para los demas campos
export const updateCliente = async (req, res) => {
  try {
    const keys = Object.keys(req.body);
    const values = Object.values(req.body);

    // Construye dinámicamente el SET usando los índices $1, $2, ...
    const setClause = keys.map((key, index) => ${key} = $${index + 1}).join(", ");

    // Añade el valor de ID al final para usarlo como último parámetro
    values.push(req.params.id);

    const query = UPDATE Cliente SET ${setClause} WHERE id = $${values.length};

    const result = await db.query(query, values);

    if (result.rowCount === 0) {
      return res.status(404).json({ message: "No se encuentra registrado" });
    }

    res.json({ message: "Datos actualizados exitosamente" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
};*/

/*
export const updateCliente = async (req, res) => {
  try {
    const { id } = req.params;
    const { telefono, fecha_nacimiento, contrasena } = req.body;

    const query = `
      UPDATE Cliente
      SET telefono = $1,
          fecha_nacimiento = $2,
          contraseña = $3
      WHERE id = $4
    `;

    await db.query(query, [telefono, fecha_nacimiento, contrasena, id]);


    res.status(200).json({ message: "Cliente actualizado con éxito" });
  } catch (error) {
    console.error("Error al actualizar cliente:", error);
    res.status(500).json({ message: "Error en la actualización", error: error.message });
  }
};


export const deleteCliente = async (req, res) => {
  try {
    const result = await db.query(
      "DELETE FROM Cliente WHERE id = $1",
      [req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "No se encuentra registrado" });
    }

    res.json({ message: "Registro eliminado exitosamente" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

 */
