--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2025-05-05 19:25:38

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
-- TOC entry 887 (class 1247 OID 16526)
-- Name: estadoPago; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."estadoPago" AS ENUM (
    'pendiente',
    'completado',
    'cancelado'
);


ALTER TYPE public."estadoPago" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 226 (class 1259 OID 16457)
-- Name: CategoriaGasto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CategoriaGasto" (
    "idCategoria" bigint NOT NULL,
    nombre character varying(20) NOT NULL,
    descripcion character varying(150)
);


ALTER TABLE public."CategoriaGasto" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16456)
-- Name: CategoriaGasto_idCategoria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."CategoriaGasto_idCategoria_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."CategoriaGasto_idCategoria_seq" OWNER TO postgres;

--
-- TOC entry 4881 (class 0 OID 0)
-- Dependencies: 225
-- Name: CategoriaGasto_idCategoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."CategoriaGasto_idCategoria_seq" OWNED BY public."CategoriaGasto"."idCategoria";


--
-- TOC entry 221 (class 1259 OID 16413)
-- Name: DetalleGasto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."DetalleGasto" (
    "idGasto" bigint NOT NULL,
    "idUsuario" bigint NOT NULL,
    "montoPagado" numeric,
    "montoAdeudado" numeric
);


ALTER TABLE public."DetalleGasto" OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16508)
-- Name: DetallePago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."DetallePago" (
    "idPago" bigint NOT NULL,
    "idUsuario" bigint NOT NULL,
    "idUsuarioDestino" bigint,
    "montoAsignado" numeric
);


ALTER TABLE public."DetallePago" OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16397)
-- Name: Gasto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Gasto" (
    "idGasto" bigint NOT NULL,
    descripcion character varying(300),
    monto bigint NOT NULL,
    fecha date,
    "idCategoria" bigint,
    "idGrupo" bigint,
    "idUsuario" bigint
);


ALTER TABLE public."Gasto" OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16396)
-- Name: Gasto_idGasto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Gasto_idGasto_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Gasto_idGasto_seq" OWNER TO postgres;

--
-- TOC entry 4882 (class 0 OID 0)
-- Dependencies: 219
-- Name: Gasto_idGasto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Gasto_idGasto_seq" OWNED BY public."Gasto"."idGasto";


--
-- TOC entry 223 (class 1259 OID 16435)
-- Name: Grupo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Grupo" (
    "idGrupo" bigint NOT NULL,
    nombre character varying(30) NOT NULL,
    descripcion character varying(250)
);


ALTER TABLE public."Grupo" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16434)
-- Name: Grupo_idGrupo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Grupo_idGrupo_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Grupo_idGrupo_seq" OWNER TO postgres;

--
-- TOC entry 4883 (class 0 OID 0)
-- Dependencies: 222
-- Name: Grupo_idGrupo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Grupo_idGrupo_seq" OWNED BY public."Grupo"."idGrupo";


--
-- TOC entry 228 (class 1259 OID 16469)
-- Name: ObjetivoGasto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ObjetivoGasto" (
    "idObjetivo" bigint NOT NULL,
    "idUsuario" bigint NOT NULL,
    "idCategoria" bigint NOT NULL,
    "montoMaximoGasto" numeric NOT NULL,
    descripcion character varying(250),
    "fechaLimite" date
);


ALTER TABLE public."ObjetivoGasto" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16468)
-- Name: ObjetivoGasto_idObjetivo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ObjetivoGasto_idObjetivo_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ObjetivoGasto_idObjetivo_seq" OWNER TO postgres;

--
-- TOC entry 4884 (class 0 OID 0)
-- Dependencies: 227
-- Name: ObjetivoGasto_idObjetivo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ObjetivoGasto_idObjetivo_seq" OWNED BY public."ObjetivoGasto"."idObjetivo";


--
-- TOC entry 230 (class 1259 OID 16495)
-- Name: Pago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Pago" (
    "idPago" bigint NOT NULL,
    monto numeric NOT NULL,
    fecha date,
    "idUsuarioOrigen" bigint NOT NULL,
    estado public."estadoPago" NOT NULL
);


ALTER TABLE public."Pago" OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16494)
-- Name: Pago_idPago_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Pago_idPago_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Pago_idPago_seq" OWNER TO postgres;

--
-- TOC entry 4885 (class 0 OID 0)
-- Dependencies: 229
-- Name: Pago_idPago_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Pago_idPago_seq" OWNED BY public."Pago"."idPago";


--
-- TOC entry 224 (class 1259 OID 16441)
-- Name: PorcentajeUsuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PorcentajeUsuario" (
    "idGrupo" bigint NOT NULL,
    "idUsuario" bigint NOT NULL
);


ALTER TABLE public."PorcentajeUsuario" OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16390)
-- Name: Usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Usuario" (
    "idUsuario" bigint NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50) NOT NULL,
    "contraseñaHash" character varying(255) NOT NULL
);


ALTER TABLE public."Usuario" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16389)
-- Name: Usuario_idUsuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Usuario_idUsuario_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Usuario_idUsuario_seq" OWNER TO postgres;

--
-- TOC entry 4886 (class 0 OID 0)
-- Dependencies: 217
-- Name: Usuario_idUsuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Usuario_idUsuario_seq" OWNED BY public."Usuario"."idUsuario";


--
-- TOC entry 4684 (class 2604 OID 16460)
-- Name: CategoriaGasto idCategoria; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CategoriaGasto" ALTER COLUMN "idCategoria" SET DEFAULT nextval('public."CategoriaGasto_idCategoria_seq"'::regclass);


--
-- TOC entry 4682 (class 2604 OID 16400)
-- Name: Gasto idGasto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gasto" ALTER COLUMN "idGasto" SET DEFAULT nextval('public."Gasto_idGasto_seq"'::regclass);


--
-- TOC entry 4683 (class 2604 OID 16438)
-- Name: Grupo idGrupo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Grupo" ALTER COLUMN "idGrupo" SET DEFAULT nextval('public."Grupo_idGrupo_seq"'::regclass);


--
-- TOC entry 4685 (class 2604 OID 16472)
-- Name: ObjetivoGasto idObjetivo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ObjetivoGasto" ALTER COLUMN "idObjetivo" SET DEFAULT nextval('public."ObjetivoGasto_idObjetivo_seq"'::regclass);


--
-- TOC entry 4686 (class 2604 OID 16498)
-- Name: Pago idPago; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pago" ALTER COLUMN "idPago" SET DEFAULT nextval('public."Pago_idPago_seq"'::regclass);


--
-- TOC entry 4681 (class 2604 OID 16393)
-- Name: Usuario idUsuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario" ALTER COLUMN "idUsuario" SET DEFAULT nextval('public."Usuario_idUsuario_seq"'::regclass);


--
-- TOC entry 4870 (class 0 OID 16457)
-- Dependencies: 226
-- Data for Name: CategoriaGasto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CategoriaGasto" ("idCategoria", nombre, descripcion) FROM stdin;
\.


--
-- TOC entry 4865 (class 0 OID 16413)
-- Dependencies: 221
-- Data for Name: DetalleGasto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."DetalleGasto" ("idGasto", "idUsuario", "montoPagado", "montoAdeudado") FROM stdin;
\.


--
-- TOC entry 4875 (class 0 OID 16508)
-- Dependencies: 231
-- Data for Name: DetallePago; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."DetallePago" ("idPago", "idUsuario", "idUsuarioDestino", "montoAsignado") FROM stdin;
\.


--
-- TOC entry 4864 (class 0 OID 16397)
-- Dependencies: 220
-- Data for Name: Gasto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Gasto" ("idGasto", descripcion, monto, fecha, "idCategoria", "idGrupo", "idUsuario") FROM stdin;
\.


--
-- TOC entry 4867 (class 0 OID 16435)
-- Dependencies: 223
-- Data for Name: Grupo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Grupo" ("idGrupo", nombre, descripcion) FROM stdin;
\.


--
-- TOC entry 4872 (class 0 OID 16469)
-- Dependencies: 228
-- Data for Name: ObjetivoGasto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ObjetivoGasto" ("idObjetivo", "idUsuario", "idCategoria", "montoMaximoGasto", descripcion, "fechaLimite") FROM stdin;
\.


--
-- TOC entry 4874 (class 0 OID 16495)
-- Dependencies: 230
-- Data for Name: Pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Pago" ("idPago", monto, fecha, "idUsuarioOrigen", estado) FROM stdin;
\.


--
-- TOC entry 4868 (class 0 OID 16441)
-- Dependencies: 224
-- Data for Name: PorcentajeUsuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."PorcentajeUsuario" ("idGrupo", "idUsuario") FROM stdin;
\.


--
-- TOC entry 4862 (class 0 OID 16390)
-- Dependencies: 218
-- Data for Name: Usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Usuario" ("idUsuario", nombre, apellido, "contraseñaHash") FROM stdin;
\.


--
-- TOC entry 4887 (class 0 OID 0)
-- Dependencies: 225
-- Name: CategoriaGasto_idCategoria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."CategoriaGasto_idCategoria_seq"', 1, false);


--
-- TOC entry 4888 (class 0 OID 0)
-- Dependencies: 219
-- Name: Gasto_idGasto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Gasto_idGasto_seq"', 1, false);


--
-- TOC entry 4889 (class 0 OID 0)
-- Dependencies: 222
-- Name: Grupo_idGrupo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Grupo_idGrupo_seq"', 1, false);


--
-- TOC entry 4890 (class 0 OID 0)
-- Dependencies: 227
-- Name: ObjetivoGasto_idObjetivo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ObjetivoGasto_idObjetivo_seq"', 1, false);


--
-- TOC entry 4891 (class 0 OID 0)
-- Dependencies: 229
-- Name: Pago_idPago_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Pago_idPago_seq"', 1, false);


--
-- TOC entry 4892 (class 0 OID 0)
-- Dependencies: 217
-- Name: Usuario_idUsuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Usuario_idUsuario_seq"', 1, false);


--
-- TOC entry 4704 (class 2606 OID 16514)
-- Name: DetallePago PK_IdPago_IdUsuario; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DetallePago"
    ADD CONSTRAINT "PK_IdPago_IdUsuario" PRIMARY KEY ("idPago", "idUsuario");


--
-- TOC entry 4698 (class 2606 OID 16462)
-- Name: CategoriaGasto idCategoria; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CategoriaGasto"
    ADD CONSTRAINT "idCategoria" PRIMARY KEY ("idCategoria");


--
-- TOC entry 4690 (class 2606 OID 16402)
-- Name: Gasto idGasto; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gasto"
    ADD CONSTRAINT "idGasto" PRIMARY KEY ("idGasto");


--
-- TOC entry 4694 (class 2606 OID 16440)
-- Name: Grupo idGrupo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Grupo"
    ADD CONSTRAINT "idGrupo" PRIMARY KEY ("idGrupo");


--
-- TOC entry 4688 (class 2606 OID 16395)
-- Name: Usuario idUsuario; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "idUsuario" PRIMARY KEY ("idUsuario");


--
-- TOC entry 4692 (class 2606 OID 16433)
-- Name: DetalleGasto pkIdGastoUsuario; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DetalleGasto"
    ADD CONSTRAINT "pkIdGastoUsuario" PRIMARY KEY ("idGasto", "idUsuario");


--
-- TOC entry 4696 (class 2606 OID 16445)
-- Name: PorcentajeUsuario pkIdGrupo_Usuario; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PorcentajeUsuario"
    ADD CONSTRAINT "pkIdGrupo_Usuario" PRIMARY KEY ("idGrupo", "idUsuario");


--
-- TOC entry 4700 (class 2606 OID 16476)
-- Name: ObjetivoGasto pkIdObjetivo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ObjetivoGasto"
    ADD CONSTRAINT "pkIdObjetivo" PRIMARY KEY ("idObjetivo");


--
-- TOC entry 4702 (class 2606 OID 16502)
-- Name: Pago pkIdPago; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pago"
    ADD CONSTRAINT "pkIdPago" PRIMARY KEY ("idPago");


--
-- TOC entry 4715 (class 2606 OID 16515)
-- Name: DetallePago FK_UsuarioDestino; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DetallePago"
    ADD CONSTRAINT "FK_UsuarioDestino" FOREIGN KEY ("idUsuarioDestino") REFERENCES public."Usuario"("idUsuario");


--
-- TOC entry 4705 (class 2606 OID 16463)
-- Name: Gasto FK_idCategoria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gasto"
    ADD CONSTRAINT "FK_idCategoria" FOREIGN KEY ("idCategoria") REFERENCES public."CategoriaGasto"("idCategoria") NOT VALID;


--
-- TOC entry 4706 (class 2606 OID 16489)
-- Name: Gasto FK_idGrupo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gasto"
    ADD CONSTRAINT "FK_idGrupo" FOREIGN KEY ("idGrupo") REFERENCES public."Grupo"("idGrupo") NOT VALID;


--
-- TOC entry 4707 (class 2606 OID 16520)
-- Name: Gasto FK_idUsuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gasto"
    ADD CONSTRAINT "FK_idUsuario" FOREIGN KEY ("idUsuario") REFERENCES public."Usuario"("idUsuario") NOT VALID;


--
-- TOC entry 4712 (class 2606 OID 16482)
-- Name: ObjetivoGasto fkIdCategoria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ObjetivoGasto"
    ADD CONSTRAINT "fkIdCategoria" FOREIGN KEY ("idCategoria") REFERENCES public."CategoriaGasto"("idCategoria");


--
-- TOC entry 4713 (class 2606 OID 16477)
-- Name: ObjetivoGasto fkIdUsuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ObjetivoGasto"
    ADD CONSTRAINT "fkIdUsuario" FOREIGN KEY ("idUsuario") REFERENCES public."Usuario"("idUsuario");


--
-- TOC entry 4714 (class 2606 OID 16503)
-- Name: Pago fkIdUsuarioOrigen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pago"
    ADD CONSTRAINT "fkIdUsuarioOrigen" FOREIGN KEY ("idUsuarioOrigen") REFERENCES public."Usuario"("idUsuario");


--
-- TOC entry 4708 (class 2606 OID 16422)
-- Name: DetalleGasto idGasto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DetalleGasto"
    ADD CONSTRAINT "idGasto" FOREIGN KEY ("idGasto") REFERENCES public."Gasto"("idGasto") NOT VALID;


--
-- TOC entry 4710 (class 2606 OID 16446)
-- Name: PorcentajeUsuario idGrupo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PorcentajeUsuario"
    ADD CONSTRAINT "idGrupo" FOREIGN KEY ("idGrupo") REFERENCES public."Grupo"("idGrupo");


--
-- TOC entry 4709 (class 2606 OID 16427)
-- Name: DetalleGasto idUsuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DetalleGasto"
    ADD CONSTRAINT "idUsuario" FOREIGN KEY ("idUsuario") REFERENCES public."Usuario"("idUsuario") NOT VALID;


--
-- TOC entry 4711 (class 2606 OID 16451)
-- Name: PorcentajeUsuario idUsuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PorcentajeUsuario"
    ADD CONSTRAINT "idUsuario" FOREIGN KEY ("idUsuario") REFERENCES public."Usuario"("idUsuario");


-- Completed on 2025-05-05 19:25:38

--
-- PostgreSQL database dump complete
--

