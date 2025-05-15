-- Database: railway

-- DROP DATABASE IF EXISTS railway;

CREATE DATABASE railway
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


CREATE TABLE Cliente (
  id VARCHAR PRIMARY KEY,
  nombre VARCHAR,
  email VARCHAR,
  contraseña VARCHAR,
  fecha_registro TIMESTAMP,
  foto_perfil VARCHAR,
  telefono VARCHAR,
  verificado BOOLEAN
);

CREATE TABLE Trabajador (
  id VARCHAR PRIMARY KEY,
  id_usuario VARCHAR REFERENCES Cliente(id),
  habilidad VARCHAR,
  experiencia VARCHAR,
  calificacion_promedio FLOAT,
  disponibilidad BOOLEAN,
  ubicacion VARCHAR,
  verificado BOOLEAN
);

CREATE TABLE Categoria_trabajo (
  id VARCHAR PRIMARY KEY,
  nombre_cat VARCHAR,
  descripcion TEXT
);

CREATE TABLE Servicio (
  id VARCHAR PRIMARY KEY,
  id_trabajador VARCHAR REFERENCES Trabajador(id),
  id_categoria VARCHAR REFERENCES Categoria_trabajo(id),
  titulo VARCHAR,
  descripcion TEXT,
  precio FLOAT,
  estado VARCHAR,
  fecha_creacion TIMESTAMP
);

CREATE TABLE Publicacion_necesidad (
  id VARCHAR PRIMARY KEY,
  id_cliente VARCHAR REFERENCES Cliente(id),
  id_categoria VARCHAR REFERENCES Categoria_trabajo(id),
  titulo VARCHAR,
  descripcion_necesidad TEXT,
  ubicacion VARCHAR,
  presupuesto FLOAT,
  fecha_publicacion TIMESTAMP,
  estado VARCHAR
);

CREATE TABLE Transaccion (
  id VARCHAR PRIMARY KEY,
  id_usuario VARCHAR REFERENCES Cliente(id),
  id_trabajador VARCHAR REFERENCES Trabajador(id),
  monto FLOAT,
  comision_pasarela FLOAT,
  comision_app FLOAT,
  fecha_transaccion TIMESTAMP,
  estatus VARCHAR,
  metodo_pago VARCHAR,
  codigo_transaccion VARCHAR
);

CREATE TABLE Calificacion_resena (
  id VARCHAR PRIMARY KEY,
  id_trabajador VARCHAR REFERENCES Trabajador(id),
  id_transaccion VARCHAR REFERENCES Transaccion(id),
  calificacion INT,
  comentario TEXT,
  fecha_resena TIMESTAMP
);

CREATE TABLE Disputa (
  id VARCHAR PRIMARY KEY,
  id_transaccion VARCHAR REFERENCES Transaccion(id),
  descripcion_disputa TEXT,
  estatus VARCHAR,
  fecha_creacion TIMESTAMP,
  fecha_resolucion TIMESTAMP,
  evidencia VARCHAR
);

CREATE TABLE Sala_chat (
  id VARCHAR PRIMARY KEY,
  id_usuario VARCHAR REFERENCES Cliente(id),
  id_trabajador VARCHAR REFERENCES Trabajador(id)
);

CREATE TABLE Mensaje (
  id VARCHAR PRIMARY KEY,
  id_sala_chat VARCHAR REFERENCES Sala_chat(id),
  id_usuario VARCHAR,
  fecha_envio TIMESTAMP,
  tipo_mensaje VARCHAR
);

SELECT * FROM Cliente WHERE id = "cli1";
-- CLIENTES
INSERT INTO Cliente (id, nombre, email, contraseña, fecha_registro, foto_perfil, telefono, verificado) VALUES
('cli1', 'Ana Pérez', 'ana@example.com', '1234', NOW(), 'ana.jpg', '3001234567', TRUE),
('cli2', 'Luis Gómez', 'luis@example.com', 'abcd', NOW(), 'luis.png', '3009876543', FALSE);

-- TRABAJADORES
INSERT INTO Trabajador (id, id_usuario, habilidad, experiencia, calificacion_promedio, disponibilidad, ubicacion, verificado) VALUES
('trab1', 'cli1', 'Plomería', '5 años de experiencia', 4.7, TRUE, 'Bogotá', TRUE),
('trab2', 'cli2', 'Electricidad', '3 años en instalaciones', 4.2, TRUE, 'Medellín', FALSE);

-- CATEGORÍAS DE TRABAJO
INSERT INTO Categoria_trabajo (id, nombre_cat, descripcion) VALUES
('cat1', 'Plomería', 'Reparación y mantenimiento de tuberías'),
('cat2', 'Electricidad', 'Instalaciones eléctricas y mantenimiento');

-- SERVICIOS
INSERT INTO Servicio (id, id_trabajador, id_categoria, titulo, descripcion, precio, estado, fecha_creacion) VALUES
('serv1', 'trab1', 'cat1', 'Reparación de fuga', 'Detecto y arreglo fugas de agua en casas', 80000, 'activo', NOW()),
('serv2', 'trab2', 'cat2', 'Instalación de enchufes', 'Instalación profesional de enchufes eléctricos', 60000, 'activo', NOW());

-- PUBLICACIONES DE NECESIDAD
INSERT INTO Publicacion_necesidad (id, id_cliente, id_categoria, titulo, descripcion_necesidad, ubicacion, presupuesto, fecha_publicacion, estado) VALUES
('pub1', 'cli2', 'cat1', 'Fuga en baño', 'Tengo una fuga que necesito reparar urgentemente', 'Medellín', 90000, NOW(), 'pendiente'),
('pub2', 'cli1', 'cat2', 'Corto circuito', 'Se fue la luz en una parte de la casa', 'Bogotá', 100000, NOW(), 'pendiente');

-- TRANSACCIONES
INSERT INTO Transaccion (id, id_usuario, id_trabajador, monto, comision_pasarela, comision_app, fecha_transaccion, estatus, metodo_pago, codigo_transaccion) VALUES
('tran1', 'cli2', 'trab1', 85000, 2500, 5000, NOW(), 'completado', 'tarjeta', 'TX123456'),
('tran2', 'cli1', 'trab2', 95000, 3000, 6000, NOW(), 'pendiente', 'efectivo', 'TX654321');

-- CALIFICACIONES Y RESEÑAS
INSERT INTO Calificacion_resena (id, id_trabajador, id_transaccion, calificacion, comentario, fecha_resena) VALUES
('cal1', 'trab1', 'tran1', 5, 'Excelente trabajo, muy puntual y eficiente.', NOW()),
('cal2', 'trab2', 'tran2', 4, 'Buen trabajo, pero llegó tarde.', NOW());

-- DISPUTAS
INSERT INTO Disputa (id, id_transaccion, descripcion_disputa, estatus, fecha_creacion, fecha_resolucion, evidencia) VALUES
('disp1', 'tran2', 'El trabajador no completó el trabajo acordado', 'abierta', NOW(), NULL, 'foto_incompleto.jpg');

-- SALAS DE CHAT
INSERT INTO Sala_chat (id, id_usuario, id_trabajador) VALUES
('chat1', 'cli1', 'trab1'),
('chat2', 'cli2', 'trab2');

-- MENSAJES
INSERT INTO Mensaje (id, id_sala_chat, id_usuario, fecha_envio, tipo_mensaje) VALUES
('msg1', 'chat1', 'cli1', NOW(), 'texto'),
('msg2', 'chat1', 'trab1', NOW(), 'texto'),
('msg3', 'chat2', 'cli2', NOW(), 'imagen');

