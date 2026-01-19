CREATE TABLE IF NOT EXISTS public.bom_data
(
    id integer NOT NULL DEFAULT nextval('bom_data_id_seq'::regclass),
    plant character varying(50) COLLATE pg_catalog."default" NOT NULL,
    year integer NOT NULL,
    month integer,
    material character varying(100) COLLATE pg_catalog."default" NOT NULL,
    release_type character varying(10) COLLATE pg_catalog."default" NOT NULL,
    production_type character varying(10) COLLATE pg_catalog."default",
    component character varying(100) COLLATE pg_catalog."default",
    quantity numeric(15,4),
    component_release_type character varying(10) COLLATE pg_catalog."default",
    component_production_type character varying(10) COLLATE pg_catalog."default",
    component_quantity numeric(15,4),
    CONSTRAINT bom_data_pkey PRIMARY KEY (id)
)