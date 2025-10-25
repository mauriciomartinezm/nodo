drop table if exists categoria;
CREATE TABLE public.categoria (
    id character varying NOT NULL,
    nombre character varying,
    descripcion text,
    CONSTRAINT categoria_pkey PRIMARY KEY (id)
);

drop table if exists conversacion;
CREATE TABLE public.conversacion (
    id character varying NOT NULL,
    id_cliente character varying,
    id_trabajador character varying,
    CONSTRAINT conversacion_pkey PRIMARY KEY (id)
);

drop table if exists disputa;
CREATE TABLE public.disputa (
    id character varying NOT NULL,
    descripcion_disputa text,
    estatus character varying,
    fecha_creacion timestamp without time zone,
    fecha_resolucion timestamp without time zone,
    evidencia character varying,
    id_publicacion character varying,
    id_trabajador character varying,
    CONSTRAINT disputa_pkey PRIMARY KEY (id)
);

drop table if exists mensaje;
CREATE TABLE public.mensaje (
    id character varying NOT NULL,
    id_sala_chat character varying,
    id_remitente character varying,
    fecha_envio timestamp without time zone,
    contenido character varying,
    estado character varying,
    CONSTRAINT mensaje_pkey PRIMARY KEY (id)
);

drop table if exists publicacion;
CREATE TABLE public.publicacion (
    id character varying NOT NULL,
    id_cliente character varying,
    id_categoria character varying,
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

drop table if exists reporte;
CREATE TABLE public.reporte (
    id character varying NOT NULL,
    id_publicacion character varying,
    razon character varying,
    CONSTRAINT reporte_pkey PRIMARY KEY (id)
);

drop table if exists resena;
CREATE TABLE public.resena (
    id character varying NOT NULL,
    id_trabajador character varying,
    calificacion integer,
    comentario text,
    fecha_resena timestamp without time zone,
    CONSTRAINT resena_pkey PRIMARY KEY (id)
);

drop table if exists servicio;
CREATE TABLE public.servicio (
    id character varying NOT NULL,
    id_trabajador character varying,
    id_categoria character varying,
    titulo character varying,
    descripcion text,
    precio double precision,
    estado character varying,
    fecha_creacion timestamp without time zone,
    CONSTRAINT servicio_pkey PRIMARY KEY (id)
);

drop table if exists transaccion;
CREATE TABLE public.transaccion (
    id character varying NOT NULL,
    id_cliente character varying,
    id_trabajador character varying,
    monto double precision,
    comision_pasarela double precision,
    comision_app double precision,
    fecha_transaccion timestamp without time zone,
    estatus character varying,
    metodo_pago character varying,
    codigo_transaccion character varying,
    CONSTRAINT transaccion_pkey PRIMARY KEY (id)
);

drop table if exists usuario;
CREATE TABLE public.usuario (
    id character varying NOT NULL,
    nombres character varying,
    primer_apellido character varying,
    segundo_apellido character varying,
    email character varying,
    telefono character varying,
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

drop table if exists usuario_categoria;
CREATE TABLE usuario_categoria (
  id_usuario character varying NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
  id_categoria character varying NOT NULL REFERENCES categoria(id) ON DELETE CASCADE,
  PRIMARY KEY (id_usuario, id_categoria)
);