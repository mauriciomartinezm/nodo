--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8 (Debian 16.8-1.pgdg120+1)
-- Dumped by pg_dump version 17.4

-- Started on 2025-06-09 22:01:08

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 16683)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3429 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 17724)
-- Name: categoria_trabajo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria_trabajo (
    id character varying NOT NULL,
    nombre_cat character varying,
    descripcion text
);


ALTER TABLE public.categoria_trabajo OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17823)
-- Name: conversacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversacion (
    id character varying NOT NULL,
    id_cliente character varying,
    id_trabajador character varying
);


ALTER TABLE public.conversacion OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17794)
-- Name: disputa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disputa (
    id character varying NOT NULL,
    descripcion_disputa text,
    estatus character varying,
    fecha_creacion timestamp without time zone,
    fecha_resolucion timestamp without time zone,
    evidencia character varying,
    id_publicacion character varying,
    id_trabajador character varying
);


ALTER TABLE public.disputa OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17840)
-- Name: mensaje; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mensaje (
    id character varying NOT NULL,
    id_sala_chat character varying,
    id_remitente character varying,
    fecha_envio timestamp without time zone,
    contenido character varying,
    estado character varying
);


ALTER TABLE public.mensaje OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 17748)
-- Name: publicacion; Type: TABLE; Schema: public; Owner: postgres
--

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
    fotos character varying
);


ALTER TABLE public.publicacion OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17811)
-- Name: reporte; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reporte (
    id character varying NOT NULL,
    id_publicacion character varying,
    razon character varying
);


ALTER TABLE public.reporte OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17782)
-- Name: resena; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resena (
    id character varying NOT NULL,
    id_trabajador character varying,
    calificacion integer,
    comentario text,
    fecha_resena timestamp without time zone
);


ALTER TABLE public.resena OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 17731)
-- Name: servicio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servicio (
    id character varying NOT NULL,
    id_trabajador character varying,
    id_categoria character varying,
    titulo character varying,
    descripcion text,
    precio double precision,
    estado character varying,
    fecha_creacion timestamp without time zone
);


ALTER TABLE public.servicio OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17765)
-- Name: transaccion; Type: TABLE; Schema: public; Owner: postgres
--

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
    codigo_transaccion character varying
);


ALTER TABLE public.transaccion OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 17717)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

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
    categoria character varying,
    ubicacion character varying,
    descripcion character varying,
    calificacion_promedio double precision,
    trabajos_completados integer,
    fcm_token character varying
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 3415 (class 0 OID 17724)
-- Dependencies: 216
-- Data for Name: categoria_trabajo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria_trabajo (id, nombre_cat, descripcion) FROM stdin;
bc85b8d1-0d9e-407c-bea0-6325aabf0246	Regional	Future
4d66d9f5-9985-417f-8fb1-c117c725b156	Legacy	Global
b36b4658-91e8-4e2a-9cc3-27c071a44385	Future	Principal
4f336165-8708-4f82-8d10-d3b851335d7b	Chief	District
7b7fb53f-93b6-4658-9456-2e57d69d005f	Direct	District
54f09a8d-fedf-430d-8396-ff7680c08c1c	Regional Paradigm Manager	Incidunt ut iste molestiae unde magni.
09d8dbd5-c124-4b3a-bce4-7499657c626a	Product Web Supervisor	Sequi ex sit veritatis nostrum fugit ut id labore.
1e76f1a8-4a2b-4cfa-84db-ca2a4ab9ee6f	Senior Configuration Supervisor	Molestiae perspiciatis et et maxime.
0cd39a7c-1beb-40a4-bcd8-e8ea47fae31a	Legacy Accounts Administrator	Aspernatur id qui quo non repellat rerum.
338d3655-98cb-499b-a42d-b31328bd9b2b	Dynamic Tactics Liaison	Qui ut ut ut nobis autem aspernatur.
2fd13ef4-2459-4dc9-adca-68d786753ef8	Chief Paradigm Assistant	Maxime eum consectetur explicabo.
ba1e08ed-e86a-4ecf-b37a-b1e20cbcf15e	Legacy Web Liaison	Qui minus vel ut qui quas placeat.
\.


--
-- TOC entry 3422 (class 0 OID 17823)
-- Dependencies: 223
-- Data for Name: conversacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conversacion (id, id_cliente, id_trabajador) FROM stdin;
\.


--
-- TOC entry 3420 (class 0 OID 17794)
-- Dependencies: 221
-- Data for Name: disputa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.disputa (id, descripcion_disputa, estatus, fecha_creacion, fecha_resolucion, evidencia, id_publicacion, id_trabajador) FROM stdin;
\.


--
-- TOC entry 3423 (class 0 OID 17840)
-- Dependencies: 224
-- Data for Name: mensaje; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mensaje (id, id_sala_chat, id_remitente, fecha_envio, contenido, estado) FROM stdin;
\.


--
-- TOC entry 3417 (class 0 OID 17748)
-- Dependencies: 218
-- Data for Name: publicacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publicacion (id, id_cliente, id_categoria, titulo, descripcion_necesidad, ubicacion, presupuesto, fecha_publicacion, fecha_limite, estado, fotos) FROM stdin;
f7a9d9a1-154c-4203-902f-16d3f89f37e3	1040350494	4d66d9f5-9985-417f-8fb1-c117c725b156	prueba 1	ffffr	carepa	50000	2025-06-09 11:45:20	2025-06-09 00:00:00	pendiente	{"https://firebasestorage.googleapis.com/v0/b/nodo-b1ff4.firebasestorage.app/o/publicaciones%2F1000322942.heic?alt=media&token=adadd14c-bead-47cb-aba3-3e5c79db8897","https://firebasestorage.googleapis.com/v0/b/nodo-b1ff4.firebasestorage.app/o/publicaciones%2F1000322945.heic?alt=media&token=ddbd2990-a059-4d10-a41a-21612c1d7290","https://firebasestorage.googleapis.com/v0/b/nodo-b1ff4.firebasestorage.app/o/publicaciones%2F1000322944.heic?alt=media&token=e13acb20-1c1b-4006-b13e-855e6f77821f","https://firebasestorage.googleapis.com/v0/b/nodo-b1ff4.firebasestorage.app/o/publicaciones%2F1000322943.heic?alt=media&token=3b0203db-dede-405c-8c94-9b29523152d6"}
\.


--
-- TOC entry 3421 (class 0 OID 17811)
-- Dependencies: 222
-- Data for Name: reporte; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reporte (id, id_publicacion, razon) FROM stdin;
\.


--
-- TOC entry 3419 (class 0 OID 17782)
-- Dependencies: 220
-- Data for Name: resena; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resena (id, id_trabajador, calificacion, comentario, fecha_resena) FROM stdin;
\.


--
-- TOC entry 3416 (class 0 OID 17731)
-- Dependencies: 217
-- Data for Name: servicio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.servicio (id, id_trabajador, id_categoria, titulo, descripcion, precio, estado, fecha_creacion) FROM stdin;
\.


--
-- TOC entry 3418 (class 0 OID 17765)
-- Dependencies: 219
-- Data for Name: transaccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaccion (id, id_cliente, id_trabajador, monto, comision_pasarela, comision_app, fecha_transaccion, estatus, metodo_pago, codigo_transaccion) FROM stdin;
\.


--
-- TOC entry 3414 (class 0 OID 17717)
-- Dependencies: 215
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id, nombres, primer_apellido, segundo_apellido, email, telefono, fecha_nacimiento, contrasena, fecha_registro, foto_perfil, verificado, tipo_usuario, categoria, ubicacion, descripcion, calificacion_promedio, trabajos_completados, fcm_token) FROM stdin;
0987654321	Stella	Morelo	Morelo	stella@gmail.com	3202326975	2000-01-01	123	2025-06-09 01:17:17.162	https://firebasestorage.googleapis.com/v0/b/nodo-b1ff4.firebasestorage.app/o/perfiles%2FiconNodoBlue.png?alt=media&token=22b11580-c0ac-403e-89e3-5f09cc5cd25c	f	cliente	\N	\N	\N	\N	\N	fCf9cFlzTyWeJD1r21VFms:APA91bHe5W1_EB177_pdHwFhJorawm2BMVJMeOv3mYJzCwaPk7JSuEM0IqMqSoikGy4yvHA_7NaRAnCD56HWSSFUlGiY7qNLxzf6-0ysi07I8raP_BUMxDc
1002249870	Kehiber	Morelo	Ricardo	kehiber123@gmail.com	3202326975	2000-01-01	123	2025-06-09 15:44:54.773	https://firebasestorage.googleapis.com/v0/b/nodo-b1ff4.firebasestorage.app/o/perfiles%2FiconNodoBlue.png?alt=media&token=22b11580-c0ac-403e-89e3-5f09cc5cd25c	f	trabajador	Direct	Apartadó	Guapo, poderoso, armonioso	\N	\N	cYbH3XV8SvW83aFQOJ5jjM:APA91bHkPEUrxoFTV-zm9oGyzeaw1RrpmSiJPk1C3RuaNbFHuh46a7wcLfMxeMP3ki7HDy6cN32_YT4RcutSzIsu7alTNopVRtfl0U7-n_P1GDQ4XADe6Yw
1040350494	mauricio	martinez	martinez	mauromm1603@gmail.com	3205056994	2000-01-01	123	2025-06-08 18:01:49.969	https://firebasestorage.googleapis.com/v0/b/nodo-b1ff4.firebasestorage.app/o/perfiles%2FiconNodoBlue.png?alt=media&token=22b11580-c0ac-403e-89e3-5f09cc5cd25c	f	cliente	\N	\N	\N	\N	\N	e24YVhZqRLC2GwG_X1YhWt:APA91bFsXmPBXsgOn2t59qMEUNFcWUoKWEHQ8hqFgVtX-8W4RGWZFzb7qM04wr2KwmNkknvDQQrRQ6cRAuEz5gSCYMekpQw9EcXwA9iTh8KK0uUYUGYmb8Q
\.


--
-- TOC entry 3249 (class 2606 OID 17788)
-- Name: resena calificacion_resena_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resena
    ADD CONSTRAINT calificacion_resena_pkey PRIMARY KEY (id);


--
-- TOC entry 3241 (class 2606 OID 17730)
-- Name: categoria_trabajo categoria_trabajo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_trabajo
    ADD CONSTRAINT categoria_trabajo_pkey PRIMARY KEY (id);


--
-- TOC entry 3255 (class 2606 OID 17829)
-- Name: conversacion conversacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversacion
    ADD CONSTRAINT conversacion_pkey PRIMARY KEY (id);


--
-- TOC entry 3251 (class 2606 OID 17800)
-- Name: disputa disputa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disputa
    ADD CONSTRAINT disputa_pkey PRIMARY KEY (id);


--
-- TOC entry 3257 (class 2606 OID 17846)
-- Name: mensaje mensaje_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mensaje
    ADD CONSTRAINT mensaje_pkey PRIMARY KEY (id);


--
-- TOC entry 3245 (class 2606 OID 17754)
-- Name: publicacion publicacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion
    ADD CONSTRAINT publicacion_pkey PRIMARY KEY (id);


--
-- TOC entry 3253 (class 2606 OID 17817)
-- Name: reporte reporte_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reporte
    ADD CONSTRAINT reporte_pkey PRIMARY KEY (id);


--
-- TOC entry 3243 (class 2606 OID 17737)
-- Name: servicio servicio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicio
    ADD CONSTRAINT servicio_pkey PRIMARY KEY (id);


--
-- TOC entry 3247 (class 2606 OID 17771)
-- Name: transaccion transaccion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaccion
    ADD CONSTRAINT transaccion_pkey PRIMARY KEY (id);


--
-- TOC entry 3239 (class 2606 OID 17723)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 3264 (class 2606 OID 17789)
-- Name: resena calificacion_resena_id_trabajador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resena
    ADD CONSTRAINT calificacion_resena_id_trabajador_fkey FOREIGN KEY (id_trabajador) REFERENCES public.usuario(id);


--
-- TOC entry 3268 (class 2606 OID 17830)
-- Name: conversacion conversacion_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversacion
    ADD CONSTRAINT conversacion_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.usuario(id);


--
-- TOC entry 3269 (class 2606 OID 17835)
-- Name: conversacion conversacion_id_trabajador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversacion
    ADD CONSTRAINT conversacion_id_trabajador_fkey FOREIGN KEY (id_trabajador) REFERENCES public.usuario(id);


--
-- TOC entry 3265 (class 2606 OID 17801)
-- Name: disputa disputa_id_publicacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disputa
    ADD CONSTRAINT disputa_id_publicacion_fkey FOREIGN KEY (id_publicacion) REFERENCES public.publicacion(id);


--
-- TOC entry 3266 (class 2606 OID 17806)
-- Name: disputa disputa_id_trabajador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disputa
    ADD CONSTRAINT disputa_id_trabajador_fkey FOREIGN KEY (id_trabajador) REFERENCES public.usuario(id);


--
-- TOC entry 3270 (class 2606 OID 17847)
-- Name: mensaje mensaje_id_sala_chat_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mensaje
    ADD CONSTRAINT mensaje_id_sala_chat_fkey FOREIGN KEY (id_sala_chat) REFERENCES public.conversacion(id);


--
-- TOC entry 3260 (class 2606 OID 17760)
-- Name: publicacion publicacion_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion
    ADD CONSTRAINT publicacion_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categoria_trabajo(id);


--
-- TOC entry 3261 (class 2606 OID 17755)
-- Name: publicacion publicacion_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion
    ADD CONSTRAINT publicacion_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.usuario(id);


--
-- TOC entry 3267 (class 2606 OID 17818)
-- Name: reporte reporte_id_publicacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reporte
    ADD CONSTRAINT reporte_id_publicacion_fkey FOREIGN KEY (id_publicacion) REFERENCES public.publicacion(id);


--
-- TOC entry 3258 (class 2606 OID 17743)
-- Name: servicio servicio_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicio
    ADD CONSTRAINT servicio_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categoria_trabajo(id);


--
-- TOC entry 3259 (class 2606 OID 17738)
-- Name: servicio servicio_id_trabajador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicio
    ADD CONSTRAINT servicio_id_trabajador_fkey FOREIGN KEY (id_trabajador) REFERENCES public.usuario(id);


--
-- TOC entry 3262 (class 2606 OID 17772)
-- Name: transaccion transaccion_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaccion
    ADD CONSTRAINT transaccion_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.usuario(id);


--
-- TOC entry 3263 (class 2606 OID 17777)
-- Name: transaccion transaccion_id_trabajador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaccion
    ADD CONSTRAINT transaccion_id_trabajador_fkey FOREIGN KEY (id_trabajador) REFERENCES public.usuario(id);


--
-- TOC entry 3430 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2025-06-09 22:01:15

--
-- PostgreSQL database dump complete
--

