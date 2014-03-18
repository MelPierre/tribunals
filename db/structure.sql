--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: char_array_to_text(character varying[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION char_array_to_text(character varying[]) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT array_to_string($1, ' ')::text $_$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: aac_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE aac_categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: aac_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE aac_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aac_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE aac_categories_id_seq OWNED BY aac_categories.id;


--
-- Name: aac_decisions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE aac_decisions (
    id integer NOT NULL,
    claimant character varying(255),
    respondent character varying(255),
    text text,
    html text,
    doc_url character varying(255),
    doc_file character varying(255),
    pdf_file character varying(255),
    file_no_1 character varying(255),
    file_no_2 character varying(255),
    file_no_3 character varying(255),
    file_number character varying(255),
    ncn_citation character varying(255),
    ncn_code1 character varying(255),
    ncn_code2 character varying(255),
    ncn_year character varying(255),
    ncn character varying(255),
    reported_no_1 character varying(255),
    reported_no_2 character varying(255),
    reported_no_3 character varying(255),
    reported_number character varying(255),
    tribunal character varying(255),
    chamber character varying(255),
    chamber_group character varying(255),
    slug character varying(255),
    is_published boolean,
    notes text,
    keywords character varying(255),
    decision_date date,
    hearing_date date,
    publication_date date,
    last_updatedtime date,
    created_datetime date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    aac_decision_subcategory_id integer,
    old_sec_subcategory_id integer,
    aac_decision_category_id integer,
    search_text text
);


--
-- Name: aac_decisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE aac_decisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aac_decisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE aac_decisions_id_seq OWNED BY aac_decisions.id;


--
-- Name: aac_import_errors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE aac_import_errors (
    id integer NOT NULL,
    url character varying(255),
    error character varying(255),
    backtrace text,
    aac_decision_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: aac_import_errors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE aac_import_errors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aac_import_errors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE aac_import_errors_id_seq OWNED BY aac_import_errors.id;


--
-- Name: aac_judgements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE aac_judgements (
    id integer NOT NULL,
    aac_decision_id integer,
    judge_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: aac_judgements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE aac_judgements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aac_judgements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE aac_judgements_id_seq OWNED BY aac_judgements.id;


--
-- Name: aac_subcategories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE aac_subcategories (
    id integer NOT NULL,
    name character varying(255),
    aac_category_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: aac_subcategories_decisions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE aac_subcategories_decisions (
    id integer NOT NULL,
    aac_subcategory_id integer,
    aac_decision_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: aac_subcategories_decisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE aac_subcategories_decisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aac_subcategories_decisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE aac_subcategories_decisions_id_seq OWNED BY aac_subcategories_decisions.id;


--
-- Name: aac_subcategories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE aac_subcategories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aac_subcategories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE aac_subcategories_id_seq OWNED BY aac_subcategories.id;


--
-- Name: decisions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE decisions (
    id integer NOT NULL,
    doc_file character varying(255),
    promulgated_on date,
    html text,
    pdf_file character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    text text,
    original_filename character varying(255),
    appeal_number character varying(255),
    url character varying(255),
    tribunal_id integer,
    reported boolean,
    old_details_url character varying(255),
    starred boolean,
    country_guideline boolean,
    judges character varying(255)[] DEFAULT '{}'::character varying[],
    categories character varying(255)[] DEFAULT '{}'::character varying[],
    country character varying(255),
    claimant character varying(255),
    keywords character varying(255)[] DEFAULT '{}'::character varying[],
    case_notes character varying(255),
    case_name character varying(255),
    hearing_on date,
    ncn character varying(255),
    slug character varying(255),
    published_on date,
    search_text text
);


--
-- Name: decisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE decisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: decisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE decisions_id_seq OWNED BY decisions.id;


--
-- Name: eat_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE eat_categories (
    id integer NOT NULL,
    name character varying(255),
    obsolete character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: eat_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE eat_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eat_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE eat_categories_id_seq OWNED BY eat_categories.id;


--
-- Name: eat_category_decisions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE eat_category_decisions (
    id integer NOT NULL,
    eat_decision_id integer,
    eat_subcategory_id integer,
    eat_category_id integer,
    primary_jurisdiction integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: eat_category_decisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE eat_category_decisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eat_category_decisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE eat_category_decisions_id_seq OWNED BY eat_category_decisions.id;


--
-- Name: eat_category_managers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE eat_category_managers (
    id integer NOT NULL,
    eat_subcategory_id integer,
    eat_category_id integer,
    eat_subcategory_name character varying(255),
    obsolete character varying(255),
    rank character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: eat_category_managers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE eat_category_managers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eat_category_managers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE eat_category_managers_id_seq OWNED BY eat_category_managers.id;


--
-- Name: eat_decisions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE eat_decisions (
    id integer NOT NULL,
    claimant character varying(255),
    respondent character varying(255),
    text text,
    html text,
    doc_url character varying(255),
    doc_file character varying(255),
    pdf_file character varying(255),
    tribunal character varying(255),
    chamber character varying(255),
    chamber_group character varying(255),
    slug character varying(255),
    notes character varying(255),
    keywords character varying(255),
    decision_date date,
    hearing_date date,
    last_updatedtime date,
    filename character varying(255),
    file_number character varying(255),
    judges character varying(255),
    upload_date date,
    uploaded_by character varying(255),
    starred boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    search_text text
);


--
-- Name: eat_decisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE eat_decisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eat_decisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE eat_decisions_id_seq OWNED BY eat_decisions.id;


--
-- Name: eat_subcategories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE eat_subcategories (
    id integer NOT NULL,
    eat_category_id integer,
    name character varying(255),
    obsolete character varying(255),
    rank character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: eat_subcategories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE eat_subcategories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eat_subcategories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE eat_subcategories_id_seq OWNED BY eat_subcategories.id;


--
-- Name: ftt_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ftt_categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ftt_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ftt_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ftt_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ftt_categories_id_seq OWNED BY ftt_categories.id;


--
-- Name: ftt_decisions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ftt_decisions (
    id integer NOT NULL,
    claimant text,
    respondent character varying(255),
    text text,
    html text,
    doc_url character varying(255),
    doc_file character varying(255),
    pdf_file character varying(255),
    file_no_1 character varying(255),
    file_no_2 character varying(255),
    file_number character varying(255),
    old_main_subcategory_id integer,
    old_sec_subcategory_id integer,
    tribunal character varying(255),
    chamber character varying(255),
    chamber_group character varying(255),
    slug character varying(255),
    is_published boolean,
    notes text,
    decision_date date,
    hearing_date date,
    publication_date date,
    last_updatedtime date,
    created_datetime date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    search_text text
);


--
-- Name: ftt_decisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ftt_decisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ftt_decisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ftt_decisions_id_seq OWNED BY ftt_decisions.id;


--
-- Name: ftt_judges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ftt_judges (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ftt_judges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ftt_judges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ftt_judges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ftt_judges_id_seq OWNED BY ftt_judges.id;


--
-- Name: ftt_judgments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ftt_judgments (
    id integer NOT NULL,
    ftt_decision_id integer,
    ftt_judge_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ftt_judgments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ftt_judgments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ftt_judgments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ftt_judgments_id_seq OWNED BY ftt_judgments.id;


--
-- Name: ftt_subcategories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ftt_subcategories (
    id integer NOT NULL,
    name character varying(255),
    ftt_category_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ftt_subcategories_decisions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ftt_subcategories_decisions (
    id integer NOT NULL,
    ftt_subcategory_id integer,
    ftt_decision_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ftt_subcategories_decisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ftt_subcategories_decisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ftt_subcategories_decisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ftt_subcategories_decisions_id_seq OWNED BY ftt_subcategories_decisions.id;


--
-- Name: ftt_subcategories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ftt_subcategories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ftt_subcategories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ftt_subcategories_id_seq OWNED BY ftt_subcategories.id;


--
-- Name: import_errors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE import_errors (
    id integer NOT NULL,
    error character varying(255),
    backtrace text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    decision_id integer
);


--
-- Name: import_errors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE import_errors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: import_errors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE import_errors_id_seq OWNED BY import_errors.id;


--
-- Name: judges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE judges (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: judges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE judges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE judges_id_seq OWNED BY judges.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY aac_categories ALTER COLUMN id SET DEFAULT nextval('aac_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY aac_decisions ALTER COLUMN id SET DEFAULT nextval('aac_decisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY aac_import_errors ALTER COLUMN id SET DEFAULT nextval('aac_import_errors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY aac_judgements ALTER COLUMN id SET DEFAULT nextval('aac_judgements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY aac_subcategories ALTER COLUMN id SET DEFAULT nextval('aac_subcategories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY aac_subcategories_decisions ALTER COLUMN id SET DEFAULT nextval('aac_subcategories_decisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY decisions ALTER COLUMN id SET DEFAULT nextval('decisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY eat_categories ALTER COLUMN id SET DEFAULT nextval('eat_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY eat_category_decisions ALTER COLUMN id SET DEFAULT nextval('eat_category_decisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY eat_category_managers ALTER COLUMN id SET DEFAULT nextval('eat_category_managers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY eat_decisions ALTER COLUMN id SET DEFAULT nextval('eat_decisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY eat_subcategories ALTER COLUMN id SET DEFAULT nextval('eat_subcategories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ftt_categories ALTER COLUMN id SET DEFAULT nextval('ftt_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ftt_decisions ALTER COLUMN id SET DEFAULT nextval('ftt_decisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ftt_judges ALTER COLUMN id SET DEFAULT nextval('ftt_judges_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ftt_judgments ALTER COLUMN id SET DEFAULT nextval('ftt_judgments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ftt_subcategories ALTER COLUMN id SET DEFAULT nextval('ftt_subcategories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ftt_subcategories_decisions ALTER COLUMN id SET DEFAULT nextval('ftt_subcategories_decisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY import_errors ALTER COLUMN id SET DEFAULT nextval('import_errors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY judges ALTER COLUMN id SET DEFAULT nextval('judges_id_seq'::regclass);


--
-- Name: aac_decision_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY aac_categories
    ADD CONSTRAINT aac_decision_categories_pkey PRIMARY KEY (id);


--
-- Name: aac_decision_subcategories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY aac_subcategories
    ADD CONSTRAINT aac_decision_subcategories_pkey PRIMARY KEY (id);


--
-- Name: aac_decisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY aac_decisions
    ADD CONSTRAINT aac_decisions_pkey PRIMARY KEY (id);


--
-- Name: aac_import_errors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY aac_import_errors
    ADD CONSTRAINT aac_import_errors_pkey PRIMARY KEY (id);


--
-- Name: aac_judgements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY aac_judgements
    ADD CONSTRAINT aac_judgements_pkey PRIMARY KEY (id);


--
-- Name: aac_subcategories_decisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY aac_subcategories_decisions
    ADD CONSTRAINT aac_subcategories_decisions_pkey PRIMARY KEY (id);


--
-- Name: decisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY decisions
    ADD CONSTRAINT decisions_pkey PRIMARY KEY (id);


--
-- Name: eat_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY eat_categories
    ADD CONSTRAINT eat_categories_pkey PRIMARY KEY (id);


--
-- Name: eat_category_decisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY eat_category_decisions
    ADD CONSTRAINT eat_category_decisions_pkey PRIMARY KEY (id);


--
-- Name: eat_category_managers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY eat_category_managers
    ADD CONSTRAINT eat_category_managers_pkey PRIMARY KEY (id);


--
-- Name: eat_decisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY eat_decisions
    ADD CONSTRAINT eat_decisions_pkey PRIMARY KEY (id);


--
-- Name: eat_subcategories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY eat_subcategories
    ADD CONSTRAINT eat_subcategories_pkey PRIMARY KEY (id);


--
-- Name: ftt_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ftt_categories
    ADD CONSTRAINT ftt_categories_pkey PRIMARY KEY (id);


--
-- Name: ftt_decisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ftt_decisions
    ADD CONSTRAINT ftt_decisions_pkey PRIMARY KEY (id);


--
-- Name: ftt_judges_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ftt_judges
    ADD CONSTRAINT ftt_judges_pkey PRIMARY KEY (id);


--
-- Name: ftt_judgments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ftt_judgments
    ADD CONSTRAINT ftt_judgments_pkey PRIMARY KEY (id);


--
-- Name: ftt_subcategories_decisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ftt_subcategories_decisions
    ADD CONSTRAINT ftt_subcategories_decisions_pkey PRIMARY KEY (id);


--
-- Name: ftt_subcategories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ftt_subcategories
    ADD CONSTRAINT ftt_subcategories_pkey PRIMARY KEY (id);


--
-- Name: import_errors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY import_errors
    ADD CONSTRAINT import_errors_pkey PRIMARY KEY (id);


--
-- Name: judges_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY judges
    ADD CONSTRAINT judges_pkey PRIMARY KEY (id);


--
-- Name: aac_decisions_text_fts_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX aac_decisions_text_fts_idx ON aac_decisions USING gin (to_tsvector('english'::regconfig, text));


--
-- Name: aac_search_text_fts_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX aac_search_text_fts_index ON aac_decisions USING gin (to_tsvector('english'::regconfig, search_text));


--
-- Name: eat_all_fields_combined_fts_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX eat_all_fields_combined_fts_index ON eat_decisions USING gin (to_tsvector('english'::regconfig, ((((((((((COALESCE((file_number)::text, ''::text) || ' '::text) || COALESCE((claimant)::text, ''::text)) || ' '::text) || COALESCE((respondent)::text, ''::text)) || ' '::text) || COALESCE((notes)::text, ''::text)) || ' '::text) || COALESCE((keywords)::text, ''::text)) || ' '::text) || COALESCE(text, ''::text))));


--
-- Name: eat_search_text_fts_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX eat_search_text_fts_index ON eat_decisions USING gin (to_tsvector('english'::regconfig, search_text));


--
-- Name: ftt_all_fields_combined_fts_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ftt_all_fields_combined_fts_index ON ftt_decisions USING gin (to_tsvector('english'::regconfig, ((((((((COALESCE((file_number)::text, ''::text) || ' '::text) || COALESCE(claimant, ''::text)) || ' '::text) || COALESCE((respondent)::text, ''::text)) || ' '::text) || COALESCE(notes, ''::text)) || ' '::text) || COALESCE(text, ''::text))));


--
-- Name: ftt_decisions_text_fts_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ftt_decisions_text_fts_idx ON ftt_decisions USING gin (to_tsvector('english'::regconfig, text));


--
-- Name: ftt_search_text_fts_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ftt_search_text_fts_index ON ftt_decisions USING gin (to_tsvector('english'::regconfig, search_text));


--
-- Name: iac_search_text_fts_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX iac_search_text_fts_index ON decisions USING gin (to_tsvector('english'::regconfig, search_text));


--
-- Name: index_aac_decisions_on_aac_decision_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_aac_decisions_on_aac_decision_category_id ON aac_decisions USING btree (aac_decision_category_id);


--
-- Name: index_aac_decisions_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_aac_decisions_on_slug ON aac_decisions USING btree (slug);


--
-- Name: index_decisions_on_country; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_decisions_on_country ON decisions USING btree (country);


--
-- Name: index_decisions_on_promulgated_on; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_decisions_on_promulgated_on ON decisions USING btree (promulgated_on DESC);


--
-- Name: index_decisions_on_reported; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_decisions_on_reported ON decisions USING btree (reported);


--
-- Name: index_decisions_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_decisions_on_slug ON decisions USING btree (slug);


--
-- Name: index_eat_decisions_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_eat_decisions_on_slug ON eat_decisions USING btree (slug);


--
-- Name: index_ftt_decisions_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_ftt_decisions_on_slug ON ftt_decisions USING btree (slug);


--
-- Name: metadata_fts_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX metadata_fts_index ON decisions USING gin (to_tsvector('english'::regconfig, (((((((((((((((((ncn)::text || ' '::text) || char_array_to_text(judges)) || ' '::text) || char_array_to_text(categories)) || ' '::text) || char_array_to_text(keywords)) || ' '::text) || (appeal_number)::text) || ' '::text) || (case_notes)::text) || ' '::text) || (claimant)::text) || ' '::text) || (country)::text) || ' '::text) || (case_name)::text)));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130221154317');

INSERT INTO schema_migrations (version) VALUES ('20130227123458');

INSERT INTO schema_migrations (version) VALUES ('20130227124449');

INSERT INTO schema_migrations (version) VALUES ('20130307104637');

INSERT INTO schema_migrations (version) VALUES ('20130307105302');

INSERT INTO schema_migrations (version) VALUES ('20130308104302');

INSERT INTO schema_migrations (version) VALUES ('20130308120729');

INSERT INTO schema_migrations (version) VALUES ('20130312173409');

INSERT INTO schema_migrations (version) VALUES ('20130315173007');

INSERT INTO schema_migrations (version) VALUES ('20130315173212');

INSERT INTO schema_migrations (version) VALUES ('20130318113645');

INSERT INTO schema_migrations (version) VALUES ('20130318140942');

INSERT INTO schema_migrations (version) VALUES ('20130412104425');

INSERT INTO schema_migrations (version) VALUES ('20130412132257');

INSERT INTO schema_migrations (version) VALUES ('20130415111723');

INSERT INTO schema_migrations (version) VALUES ('20130416092328');

INSERT INTO schema_migrations (version) VALUES ('20130423122537');

INSERT INTO schema_migrations (version) VALUES ('20130711143547');

INSERT INTO schema_migrations (version) VALUES ('20130712131321');

INSERT INTO schema_migrations (version) VALUES ('20130724093005');

INSERT INTO schema_migrations (version) VALUES ('20130801162847');

INSERT INTO schema_migrations (version) VALUES ('20130801163401');

INSERT INTO schema_migrations (version) VALUES ('20130802112712');

INSERT INTO schema_migrations (version) VALUES ('20130802113158');

INSERT INTO schema_migrations (version) VALUES ('20130912145119');

INSERT INTO schema_migrations (version) VALUES ('20130927153456');

INSERT INTO schema_migrations (version) VALUES ('20131007113059');

INSERT INTO schema_migrations (version) VALUES ('20131010094352');

INSERT INTO schema_migrations (version) VALUES ('20131016150002');

INSERT INTO schema_migrations (version) VALUES ('20131017143129');

INSERT INTO schema_migrations (version) VALUES ('20131017144103');

INSERT INTO schema_migrations (version) VALUES ('20131018104102');

INSERT INTO schema_migrations (version) VALUES ('20131018104454');

INSERT INTO schema_migrations (version) VALUES ('20131018105418');

INSERT INTO schema_migrations (version) VALUES ('20131018113517');

INSERT INTO schema_migrations (version) VALUES ('20131018140933');

INSERT INTO schema_migrations (version) VALUES ('20131021095048');

INSERT INTO schema_migrations (version) VALUES ('20131021105145');

INSERT INTO schema_migrations (version) VALUES ('20131023150128');

INSERT INTO schema_migrations (version) VALUES ('20131024130509');

INSERT INTO schema_migrations (version) VALUES ('20131024141111');

INSERT INTO schema_migrations (version) VALUES ('20131024153318');

INSERT INTO schema_migrations (version) VALUES ('20131025123852');

INSERT INTO schema_migrations (version) VALUES ('20131028114444');

INSERT INTO schema_migrations (version) VALUES ('20131029134452');

INSERT INTO schema_migrations (version) VALUES ('20131030131127');

INSERT INTO schema_migrations (version) VALUES ('20131030131901');

INSERT INTO schema_migrations (version) VALUES ('20131030131946');

INSERT INTO schema_migrations (version) VALUES ('20131030132540');

INSERT INTO schema_migrations (version) VALUES ('20131030133450');

INSERT INTO schema_migrations (version) VALUES ('20131031121223');

INSERT INTO schema_migrations (version) VALUES ('20131101093540');

INSERT INTO schema_migrations (version) VALUES ('20131101132149');

INSERT INTO schema_migrations (version) VALUES ('20131101155203');

INSERT INTO schema_migrations (version) VALUES ('20131104135007');

INSERT INTO schema_migrations (version) VALUES ('20131105160142');

INSERT INTO schema_migrations (version) VALUES ('20131106123800');

INSERT INTO schema_migrations (version) VALUES ('20131111143056');

INSERT INTO schema_migrations (version) VALUES ('20131111145403');

INSERT INTO schema_migrations (version) VALUES ('20131111183343');

INSERT INTO schema_migrations (version) VALUES ('20131111190231');

INSERT INTO schema_migrations (version) VALUES ('20131113132233');

INSERT INTO schema_migrations (version) VALUES ('20131113141201');

INSERT INTO schema_migrations (version) VALUES ('20131114131154');

INSERT INTO schema_migrations (version) VALUES ('20131114132143');

INSERT INTO schema_migrations (version) VALUES ('20131114144626');

INSERT INTO schema_migrations (version) VALUES ('20131114145418');

INSERT INTO schema_migrations (version) VALUES ('20131115124041');

INSERT INTO schema_migrations (version) VALUES ('20131115125458');

INSERT INTO schema_migrations (version) VALUES ('20131119133616');

INSERT INTO schema_migrations (version) VALUES ('20131119143034');

INSERT INTO schema_migrations (version) VALUES ('20131121114934');
