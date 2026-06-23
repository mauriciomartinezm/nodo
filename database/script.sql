-- Esquema actualizado 2026-06-22.
-- Reemplaza al script anterior: agrega Postulacion e Historial_servicio (ya usadas
-- por el backend pero nunca declaradas), reestructura Resena, elimina Servicio
-- (descartada como idea de producto), y mantiene categorias como muchos-a-muchos
-- (usuario_categoria / publicacion_categoria) en vez de FK unica.
-- Ver memoria de proyecto "schema_business_rules" para el detalle de cada decision.

drop table if exists usuario_categoria;
drop table if exists publicacion_categoria;
drop table if exists resena;
drop table if exists historial_servicio;
drop table if exists disputa;
drop table if exists reporte;
drop table if exists mensaje;
drop table if exists conversacion;
drop table if exists postulacion;
drop table if exists publicacion;
drop table if exists transaccion;
drop table if exists servicio;
drop table if exists usuario;
drop table if exists categoria;

CREATE TABLE public.categoria (
    id character varying NOT NULL,
    nombre_categoria character varying,
    descripcion text,
    CONSTRAINT categoria_pkey PRIMARY KEY (id)
);

CREATE TABLE public.usuario (
    id character varying NOT NULL,
    nombres character varying,
    primer_apellido character varying,
    segundo_apellido character varying,
    email character varying UNIQUE,
    telefono character varying UNIQUE,
    fecha_nacimiento character varying,
    contrasena character varying,
    fecha_registro timestamp without time zone,
    foto_perfil character varying,
    verificado boolean,
    tipo_usuario character varying,
    ubicacion character varying,
    descripcion character varying,
    calificacion_promedio double precision,
    trabajos_completados integer,
    fcm_token character varying,
    CONSTRAINT usuario_pkey PRIMARY KEY (id)
);

-- Un trabajador puede ofrecer varias categorias (electricista, jardinero, etc.)
CREATE TABLE public.usuario_categoria (
    id_usuario character varying NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
    id_categoria character varying NOT NULL REFERENCES categoria(id) ON DELETE CASCADE,
    PRIMARY KEY (id_usuario, id_categoria)
);

CREATE TABLE public.publicacion (
    id character varying NOT NULL,
    id_cliente character varying REFERENCES usuario(id),
    titulo character varying,
    descripcion_necesidad text,
    ubicacion character varying,
    presupuesto double precision,
    fecha_publicacion timestamp without time zone,
    fecha_limite timestamp without time zone,
    estado character varying,
    fotos character varying,
    CONSTRAINT publicacion_pkey PRIMARY KEY (id)
);

-- Una publicacion puede requerir varias categorias (plomero, albañil, etc.)
CREATE TABLE public.publicacion_categoria (
    id_publicacion character varying NOT NULL REFERENCES publicacion(id) ON DELETE CASCADE,
    id_categoria character varying NOT NULL REFERENCES categoria(id) ON DELETE CASCADE,
    PRIMARY KEY (id_publicacion, id_categoria)
);

CREATE TABLE public.postulacion (
    id character varying NOT NULL,
    id_publicacion character varying REFERENCES publicacion(id),
    id_trabajador character varying REFERENCES usuario(id),
    fecha_postulacion timestamp without time zone,
    estado character varying, -- pendiente, aceptado, rechazado, considerado, retirada
    CONSTRAINT postulacion_pkey PRIMARY KEY (id)
);

CREATE TABLE public.transaccion (
    id character varying NOT NULL,
    monto double precision,
    comision_pasarela double precision,
    comision_app double precision,
    fecha_transaccion timestamp without time zone,
    estatus character varying,
    metodo_pago character varying,
    codigo_transaccion character varying,
    CONSTRAINT transaccion_pkey PRIMARY KEY (id)
);

-- Se crea al aceptarse una postulacion (fecha_inicio), independientemente de si
-- el servicio luego se completa, se cancela, etc. fecha_finalizacion/estado se
-- actualizan segun el desenlace. id_transaccion se asocia cuando el pago se liquida.
CREATE TABLE public.historial_servicio (
    id character varying NOT NULL,
    id_transaccion character varying UNIQUE REFERENCES transaccion(id),
    id_trabajador character varying REFERENCES usuario(id),
    id_publicacion character varying REFERENCES publicacion(id),
    fecha_inicio timestamp without time zone,
    fecha_finalizacion timestamp without time zone,
    calificacion integer,
    estado character varying, -- en curso, completado, cancelado, etc.
    notas_trabajador text,
    notas_cliente text,
    CONSTRAINT historial_servicio_pkey PRIMARY KEY (id)
);

CREATE TABLE public.conversacion (
    id character varying NOT NULL,
    id_cliente character varying REFERENCES usuario(id),
    id_trabajador character varying REFERENCES usuario(id),
    CONSTRAINT conversacion_pkey PRIMARY KEY (id)
);

CREATE TABLE public.mensaje (
    id character varying NOT NULL,
    id_conversacion character varying REFERENCES conversacion(id),
    id_remitente character varying REFERENCES usuario(id),
    fecha_envio timestamp without time zone,
    contenido character varying,
    estado character varying,
    CONSTRAINT mensaje_pkey PRIMARY KEY (id)
);

-- Calificacion bidireccional: solo valida si existe una relacion de servicio real
-- (id_historial_servicio) entre calificador y calificado. La validacion de esa regla
-- vive en el backend, no en el esquema.
CREATE TABLE public.resena (
    id character varying NOT NULL,
    id_calificador character varying REFERENCES usuario(id),
    id_calificado character varying REFERENCES usuario(id),
    id_historial_servicio character varying REFERENCES historial_servicio(id),
    calificacion integer,
    comentario text,
    fecha_resena timestamp without time zone,
    CONSTRAINT resena_pkey PRIMARY KEY (id)
);

CREATE TABLE public.disputa (
    id character varying NOT NULL,
    descripcion_disputa text,
    estatus character varying,
    fecha_creacion timestamp without time zone,
    fecha_resolucion timestamp without time zone,
    evidencia character varying,
    id_publicacion character varying REFERENCES publicacion(id),
    id_trabajador character varying REFERENCES usuario(id),
    CONSTRAINT disputa_pkey PRIMARY KEY (id)
);

CREATE TABLE public.reporte (
    id character varying NOT NULL,
    id_publicacion character varying REFERENCES publicacion(id),
    razon character varying,
    CONSTRAINT reporte_pkey PRIMARY KEY (id)
);
