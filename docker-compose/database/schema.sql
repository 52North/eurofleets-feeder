--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.7

-- Started on 2023-05-05 14:31:01 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 12 (class 2615 OID 19192)
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;

--
-- TOC entry 10 (class 2615 OID 19448)
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 19020)
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- TOC entry 5406 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- TOC entry 4 (class 3079 OID 19181)
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- TOC entry 5407 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- TOC entry 2 (class 3079 OID 17989)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 5408 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- TOC entry 5 (class 3079 OID 19193)
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- TOC entry 5409 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- TOC entry 3 (class 3079 OID 19021)
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- TOC entry 5410 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 309 (class 1259 OID 37095)
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    category_id bigint NOT NULL,
    identifier character varying(255) NOT NULL,
    name character varying(255),
    description text
);


ALTER TABLE public.category OWNER TO postgres;

--
-- TOC entry 5411 (class 0 OID 0)
-- Dependencies: 309
-- Name: TABLE category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.category IS 'Storage of the categories which should be used to group the data (e.g. grouping of phemomenon).';


--
-- TOC entry 5412 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN category.category_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.category.category_id IS 'PK column of the table';


--
-- TOC entry 5413 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN category.identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.category.identifier IS 'Unique identifier of the category which can be used for filtering. Should be a URI, UUID. E.g. http://www.example.org/123, 123-321';


--
-- TOC entry 5414 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN category.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.category.name IS 'The human readable name of the category.';


--
-- TOC entry 5415 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN category.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.category.description IS 'A short description of the category';


--
-- TOC entry 310 (class 1259 OID 37102)
-- Name: category_i18n; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category_i18n (
    category_i18n_id bigint NOT NULL,
    fk_category_id bigint NOT NULL,
    locale character varying(255) NOT NULL,
    name character varying(255),
    description text
);


ALTER TABLE public.category_i18n OWNER TO postgres;

--
-- TOC entry 5416 (class 0 OID 0)
-- Dependencies: 310
-- Name: TABLE category_i18n; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.category_i18n IS 'Storage for internationalizations of categories.';


--
-- TOC entry 5417 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN category_i18n.category_i18n_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.category_i18n.category_i18n_id IS 'PK column of the table';


--
-- TOC entry 5418 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN category_i18n.fk_category_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.category_i18n.fk_category_id IS 'Reference to the category table this internationalization belongs to. ISO 639 Codes (http://www.loc.gov/standards/iso639-2/php/code_list.php)';


--
-- TOC entry 5419 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN category_i18n.locale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.category_i18n.locale IS 'Locale/language specification for this entry';


--
-- TOC entry 5420 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN category_i18n.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.category_i18n.name IS 'Locale/language specific name of the category';


--
-- TOC entry 5421 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN category_i18n.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.category_i18n.description IS 'Locale/language specific description of the category';


--
-- TOC entry 278 (class 1259 OID 37064)
-- Name: category_i18n_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_i18n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_i18n_seq OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 37065)
-- Name: category_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_seq OWNER TO postgres;

--
-- TOC entry 311 (class 1259 OID 37109)
-- Name: codespace; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.codespace (
    codespace_id bigint NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.codespace OWNER TO postgres;

--
-- TOC entry 5422 (class 0 OID 0)
-- Dependencies: 311
-- Name: TABLE codespace; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.codespace IS 'Storage of codespaces which can be domain specific.';


--
-- TOC entry 5423 (class 0 OID 0)
-- Dependencies: 311
-- Name: COLUMN codespace.codespace_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.codespace.codespace_id IS 'PK column of the table';


--
-- TOC entry 5424 (class 0 OID 0)
-- Dependencies: 311
-- Name: COLUMN codespace.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.codespace.name IS 'Name/definition of the codespace, e.g. of a domain';


--
-- TOC entry 280 (class 1259 OID 37066)
-- Name: codespace_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.codespace_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.codespace_seq OWNER TO postgres;

--
-- TOC entry 312 (class 1259 OID 37114)
-- Name: composite_phenomenon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.composite_phenomenon (
    fk_child_phenomenon_id bigint NOT NULL,
    fk_parent_phenomenon_id bigint NOT NULL
);


ALTER TABLE public.composite_phenomenon OWNER TO postgres;

--
-- TOC entry 5425 (class 0 OID 0)
-- Dependencies: 312
-- Name: TABLE composite_phenomenon; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.composite_phenomenon IS 'Storage of hierarchies between phenomenon, e.g. for composite phenomenon like weather with temperature, windspeed, ...';


--
-- TOC entry 5426 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN composite_phenomenon.fk_child_phenomenon_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.composite_phenomenon.fk_child_phenomenon_id IS 'Reference to the child phenomenon in phenomenon table.';


--
-- TOC entry 5427 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN composite_phenomenon.fk_parent_phenomenon_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.composite_phenomenon.fk_parent_phenomenon_id IS 'Reference to the parent phenomenon in phenomenon table.';


--
-- TOC entry 313 (class 1259 OID 37119)
-- Name: dataset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dataset (
    dataset_id bigint NOT NULL,
    discriminator character varying(255),
    identifier character varying(255),
    sta_identifier character varying(255),
    name character varying(255),
    description text,
    first_time timestamp without time zone,
    last_time timestamp without time zone,
    result_time_start timestamp without time zone,
    result_time_end timestamp without time zone,
    observed_area public.geometry,
    fk_procedure_id bigint NOT NULL,
    fk_phenomenon_id bigint NOT NULL,
    fk_offering_id bigint NOT NULL,
    fk_category_id bigint NOT NULL,
    fk_feature_id bigint,
    fk_platform_id bigint,
    fk_unit_id bigint,
    fk_format_id bigint,
    fk_aggregation_id bigint,
    first_value numeric(20,10),
    last_value numeric(20,10),
    fk_first_observation_id bigint,
    fk_last_observation_id bigint,
    dataset_type character varying(255) DEFAULT 'not_initialized'::character varying NOT NULL,
    observation_type character varying(255) DEFAULT 'not_initialized'::character varying NOT NULL,
    value_type character varying(255) DEFAULT 'not_initialized'::character varying NOT NULL,
    is_deleted smallint DEFAULT 0 NOT NULL,
    is_disabled smallint DEFAULT 0 NOT NULL,
    is_published smallint DEFAULT 1 NOT NULL,
    is_mobile smallint DEFAULT 0 NOT NULL,
    is_insitu smallint DEFAULT 1 NOT NULL,
    is_hidden smallint DEFAULT 0 NOT NULL,
    origin_timezone character varying(40),
    decimals integer,
    fk_identifier_codespace_id bigint,
    fk_name_codespace_id bigint,
    fk_value_profile_id bigint,
    CONSTRAINT dataset_dataset_type_check CHECK (((dataset_type)::text = ANY ((ARRAY['individualObservation'::character varying, 'sampling'::character varying, 'timeseries'::character varying, 'profile'::character varying, 'trajectory'::character varying, 'not_initialized'::character varying])::text[]))),
    CONSTRAINT dataset_is_deleted_check CHECK ((is_deleted = ANY (ARRAY[1, 0]))),
    CONSTRAINT dataset_is_disabled_check CHECK ((is_disabled = ANY (ARRAY[1, 0]))),
    CONSTRAINT dataset_is_hidden_check CHECK ((is_hidden = ANY (ARRAY[1, 0]))),
    CONSTRAINT dataset_is_insitu_check CHECK ((is_insitu = ANY (ARRAY[1, 0]))),
    CONSTRAINT dataset_is_mobile_check CHECK ((is_mobile = ANY (ARRAY[1, 0]))),
    CONSTRAINT dataset_is_published_check CHECK ((is_published = ANY (ARRAY[1, 0]))),
    CONSTRAINT dataset_observation_type_check CHECK (((observation_type)::text = ANY ((ARRAY['simple'::character varying, 'profile'::character varying, 'timeseries'::character varying, 'trajectory'::character varying, 'not_initialized'::character varying])::text[]))),
    CONSTRAINT dataset_value_type_check CHECK (((value_type)::text = ANY ((ARRAY['quantity'::character varying, 'count'::character varying, 'text'::character varying, 'category'::character varying, 'bool'::character varying, 'geometry'::character varying, 'blob'::character varying, 'reference'::character varying, 'complex'::character varying, 'dataarray'::character varying, 'not_initialized'::character varying])::text[])))
);


ALTER TABLE public.dataset OWNER TO postgres;

--
-- TOC entry 5428 (class 0 OID 0)
-- Dependencies: 313
-- Name: TABLE dataset; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.dataset IS 'Storage of the dataset, the core table of the whole database model.';


--
-- TOC entry 5429 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.dataset_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.dataset_id IS 'PK column of the table';


--
-- TOC entry 5430 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.discriminator; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.discriminator IS 'Indicator used by Hibernate to distinguish between different types of datasets. Used e.g. for STA DatasetAggregations.';


--
-- TOC entry 5431 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.identifier IS 'Unique identifier of the dataset which can be used for filtering, e.g. GetObservationById in the SOS and can be encoded in WaterML 2.0 oder TimeseriesML 1.0 outputs.';


--
-- TOC entry 5432 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.sta_identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.sta_identifier IS 'Unique identifier used by SensorThingsAPI for addressing the entity. Should be a URI (reference to a vocabulary entry), UUID. E.g. 123, 123-321';


--
-- TOC entry 5433 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.name IS 'The human readable name of the dataset.';


--
-- TOC entry 5434 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.description IS 'A short description of the dataset';


--
-- TOC entry 5435 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.first_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.first_time IS 'The timestamp of the temporally first observation that belongs to this dataset.';


--
-- TOC entry 5436 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.last_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.last_time IS 'The timestamp of the temporally last observation that belongs to this dataset.';


--
-- TOC entry 5437 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.result_time_start; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.result_time_start IS 'The timestamp of the earliest result time of the observations that belong to this dataset.';


--
-- TOC entry 5438 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.result_time_end; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.result_time_end IS 'The timestamp of the latest result time of the observations that belong to this dataset.';


--
-- TOC entry 5439 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.fk_procedure_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.fk_procedure_id IS 'Reference to the procedure that belongs that belongs to this dataset.';


--
-- TOC entry 5440 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.fk_phenomenon_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.fk_phenomenon_id IS 'Reference to the phenomenon that belongs that belongs to this dataset.';


--
-- TOC entry 5441 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.fk_offering_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.fk_offering_id IS 'Reference to the offering that belongs that belongs to this dataset.';


--
-- TOC entry 5442 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.fk_category_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.fk_category_id IS 'Reference to the category that belongs that belongs to this dataset.';


--
-- TOC entry 5443 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.fk_feature_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.fk_feature_id IS 'Reference to the feature that belongs that belongs to this dataset.';


--
-- TOC entry 5444 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.fk_platform_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.fk_platform_id IS 'Reference to the platform that belongs that belongs to this dataset.';


--
-- TOC entry 5445 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.fk_unit_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.fk_unit_id IS 'Reference to the unit of the observations that belongs to this dataset.';


--
-- TOC entry 5446 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.fk_format_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.fk_format_id IS 'Reference to the observationType in the format table. Required by the SOS to persist the valid observationType for the dataset.';


--
-- TOC entry 5447 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.fk_aggregation_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.fk_aggregation_id IS 'Reference to the aggregation if this dataset belongs to one.';


--
-- TOC entry 5448 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.first_value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.first_value IS 'The value of the temporally first observation that belongs to this dataset.';


--
-- TOC entry 5449 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.last_value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.last_value IS 'The value of the temporally last quantity observation that belongs to this dataset.';


--
-- TOC entry 5450 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.fk_first_observation_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.fk_first_observation_id IS 'Reference to the temporally first observation in the observation table that belongs to this dataset.';


--
-- TOC entry 5451 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.fk_last_observation_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.fk_last_observation_id IS 'Reference to the temporally last observation in the observation table that belongs to this dataset.';


--
-- TOC entry 5452 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.dataset_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.dataset_type IS 'Indicator whether the dataset provides individualObservation (individual observations), timeseries (timeseries obervations) or trajectories (trajectory observations).';


--
-- TOC entry 5453 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.observation_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.observation_type IS 'Indicator whether the dataset observations are of type simple (a simple observation, e.g. a scalar value like the temperature) or profile (profile observations)';


--
-- TOC entry 5454 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.value_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.value_type IS 'Indicator of the type of the single values. Valid values are quantity (scalar values), count (integer values), text (textual values), category (categorical values), bool (boolean values), reference (references, e.g. link to a source, photo, video)';


--
-- TOC entry 5455 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.is_deleted; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.is_deleted IS 'Flag that indicates if this dataset is deleted';


--
-- TOC entry 5456 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.is_disabled; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.is_disabled IS 'Flag that indicates if this dataset is disabled for insertion of new data';


--
-- TOC entry 5457 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.is_published; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.is_published IS 'Flag that indicates if this dataset should be published';


--
-- TOC entry 5458 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.is_mobile; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.is_mobile IS 'Flag that indicates if the procedure is mobile (1/true) or stationary (0/false).';


--
-- TOC entry 5459 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.is_insitu; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.is_insitu IS 'Flag that indicates if the procedure is insitu (1/true) or remote (0/false).';


--
-- TOC entry 5460 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.is_hidden; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.is_hidden IS 'Flag that indicates if this dataset should be hidden, e.g. for sub-datasets of a complex datasets';


--
-- TOC entry 5461 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.origin_timezone; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.origin_timezone IS 'Define the origin timezone of the dataset timestamps. Possible values are offset (+02:00), id (CET) or full name (Europe/Berlin). It no time zone is defined, UTC would be used as default.';


--
-- TOC entry 5462 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.decimals; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.decimals IS 'Number of decimals that should be present in the output of the observation values. If no value is set, all decimals would be present.';


--
-- TOC entry 5463 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.fk_identifier_codespace_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.fk_identifier_codespace_id IS 'The codespace of the dataset identifier, reference to the codespace table. Can be null.';


--
-- TOC entry 5464 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.fk_name_codespace_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.fk_name_codespace_id IS 'The codespace of the dataset name, reference to the codespace table. Can be null.';


--
-- TOC entry 5465 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN dataset.fk_value_profile_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset.fk_value_profile_id IS 'Reference to the vertical metadata that belongs to this profile dataset.';


--
-- TOC entry 314 (class 1259 OID 37144)
-- Name: dataset_i18n; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dataset_i18n (
    dataset_i18n_id bigint NOT NULL,
    fk_dataset_id bigint NOT NULL,
    locale character varying(255) NOT NULL,
    name character varying(255),
    description text
);


ALTER TABLE public.dataset_i18n OWNER TO postgres;

--
-- TOC entry 5466 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN dataset_i18n.dataset_i18n_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_i18n.dataset_i18n_id IS 'PK column of the table';


--
-- TOC entry 5467 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN dataset_i18n.fk_dataset_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_i18n.fk_dataset_id IS 'Reference to the dataset table this internationalization belongs to.';


--
-- TOC entry 5468 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN dataset_i18n.locale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_i18n.locale IS 'Locale/language specification for this entry. ISO 639 Codes (http://www.loc.gov/standards/iso639-2/php/code_list.php)';


--
-- TOC entry 5469 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN dataset_i18n.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_i18n.name IS 'Locale/language specific name of the dataset entity';


--
-- TOC entry 5470 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN dataset_i18n.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_i18n.description IS 'Locale/language specific description of the dataset entity';


--
-- TOC entry 281 (class 1259 OID 37067)
-- Name: dataset_i18n_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dataset_i18n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dataset_i18n_seq OWNER TO postgres;

--
-- TOC entry 315 (class 1259 OID 37151)
-- Name: dataset_parameter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dataset_parameter (
    parameter_id bigint NOT NULL,
    type character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    last_update timestamp without time zone,
    domain character varying(255),
    fk_dataset_id bigint NOT NULL,
    fk_parent_parameter_id bigint,
    value_boolean smallint,
    value_category character varying(255),
    fk_unit_id bigint,
    value_count integer,
    value_quantity numeric(19,2),
    value_text character varying(255),
    value_xml text,
    value_json text,
    value_temporal_from timestamp without time zone,
    value_temporal_to timestamp without time zone,
    CONSTRAINT dataset_parameter_type_check CHECK (((type)::text = ANY ((ARRAY['bool'::character varying, 'category'::character varying, 'count'::character varying, 'quantity'::character varying, 'text'::character varying, 'xml'::character varying, 'json'::character varying, 'complex'::character varying, 'temporal'::character varying])::text[])))
);


ALTER TABLE public.dataset_parameter OWNER TO postgres;

--
-- TOC entry 5471 (class 0 OID 0)
-- Dependencies: 315
-- Name: TABLE dataset_parameter; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.dataset_parameter IS 'Storage for additional information for platforms';


--
-- TOC entry 5472 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.parameter_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.parameter_id IS 'PK column of the table';


--
-- TOC entry 5473 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.type IS 'Indicator used by Hibernate to map value specific entities.';


--
-- TOC entry 5474 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.name IS 'The name of the parameter';


--
-- TOC entry 5475 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.description IS 'A short description of the parameter';


--
-- TOC entry 5476 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.last_update; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.last_update IS 'Timestamp that provides the time of the last modification of this entry';


--
-- TOC entry 5477 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.domain; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.domain IS 'The domain this parameter belongs to.';


--
-- TOC entry 5478 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.fk_dataset_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.fk_dataset_id IS 'Reference to the Dataset this Parameter describes.';


--
-- TOC entry 5479 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.fk_parent_parameter_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.fk_parent_parameter_id IS 'Reference to the Dataset this Parameter describes.';


--
-- TOC entry 5480 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.value_boolean; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.value_boolean IS 'Storage of a boolean parameter value.';


--
-- TOC entry 5481 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.value_category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.value_category IS 'Storage of a categorical parameter value.';


--
-- TOC entry 5482 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.fk_unit_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.fk_unit_id IS 'Reference to the unit of this value in the unit table';


--
-- TOC entry 5483 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.value_count; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.value_count IS 'Storage of a count parameter value.';


--
-- TOC entry 5484 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.value_quantity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.value_quantity IS 'Storage of a quantity parameter value.';


--
-- TOC entry 5485 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.value_text; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.value_text IS 'Storage of a textual parameter value.';


--
-- TOC entry 5486 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.value_xml; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.value_xml IS 'Storage of a XML encoded parameter value.';


--
-- TOC entry 5487 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.value_json; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.value_json IS 'Storage of a JSON encoded parameter value.';


--
-- TOC entry 5488 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.value_temporal_from; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.value_temporal_from IS 'Storage of a temporal from parameter value.';


--
-- TOC entry 5489 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN dataset_parameter.value_temporal_to; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_parameter.value_temporal_to IS 'Storage of a temporal to parameter value.';


--
-- TOC entry 316 (class 1259 OID 37159)
-- Name: dataset_reference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dataset_reference (
    fk_dataset_id_from bigint NOT NULL,
    sort_order integer NOT NULL,
    fk_dataset_id_to bigint NOT NULL
);


ALTER TABLE public.dataset_reference OWNER TO postgres;

--
-- TOC entry 5490 (class 0 OID 0)
-- Dependencies: 316
-- Name: TABLE dataset_reference; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.dataset_reference IS 'Storage of reference datasets, e.g. level zero, medium water level,etc. for water level.';


--
-- TOC entry 5491 (class 0 OID 0)
-- Dependencies: 316
-- Name: COLUMN dataset_reference.fk_dataset_id_from; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_reference.fk_dataset_id_from IS 'Reference to the dataset that has reference datasets';


--
-- TOC entry 5492 (class 0 OID 0)
-- Dependencies: 316
-- Name: COLUMN dataset_reference.sort_order; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_reference.sort_order IS 'Provides the sort order for the reference datasets.';


--
-- TOC entry 5493 (class 0 OID 0)
-- Dependencies: 316
-- Name: COLUMN dataset_reference.fk_dataset_id_to; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dataset_reference.fk_dataset_id_to IS 'Reference to the dataset that belongs to another dataset and provides values like level zero, medium water level,etc. for water level.';


--
-- TOC entry 282 (class 1259 OID 37068)
-- Name: dataset_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dataset_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dataset_seq OWNER TO postgres;

--
-- TOC entry 317 (class 1259 OID 37164)
-- Name: feature; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feature (
    feature_id bigint NOT NULL,
    discriminator character varying(255),
    fk_format_id bigint NOT NULL,
    identifier character varying(255) NOT NULL,
    sta_identifier character varying(255) NOT NULL,
    fk_identifier_codespace_id bigint,
    name character varying(255),
    fk_name_codespace_id bigint,
    description text,
    xml text,
    url character varying(255),
    geom public.geometry
);


ALTER TABLE public.feature OWNER TO postgres;

--
-- TOC entry 5494 (class 0 OID 0)
-- Dependencies: 317
-- Name: TABLE feature; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.feature IS 'Storage of the features (OfInterest). A feature represents the observed location, route, or area. As examples, the location of the weather station or the water level location, a ferry (Cuxhaven-Helgoland) or a lake of interest.';


--
-- TOC entry 5495 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN feature.feature_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature.feature_id IS 'PK column of the table';


--
-- TOC entry 5496 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN feature.discriminator; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature.discriminator IS 'Indicator used by Hibernate to map value specific entities (e.g. of a WaterML 2.0 MonitoringPoint) which are stored in separate tables.';


--
-- TOC entry 5497 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN feature.fk_format_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature.fk_format_id IS 'Reference to the featureType in the format table. Required by the SOS to identify the typ of the feature, e.g. http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint.';


--
-- TOC entry 5498 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN feature.identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature.identifier IS 'Unique identifier of the feature which is used for filtering. Should be a URI, UUID. E.g. http://www.example.org/123, 123-321';


--
-- TOC entry 5499 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN feature.sta_identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature.sta_identifier IS 'Unique identifier used by SensorThingsAPI for addressing the entity. Should be a URI (reference to a vocabulary entry), UUID. E.g. 123, 123-321';


--
-- TOC entry 5500 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN feature.fk_identifier_codespace_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature.fk_identifier_codespace_id IS 'The codespace of the feature identifier, reference to the codespace table.';


--
-- TOC entry 5501 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN feature.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature.name IS 'The human readable name of the feature.';


--
-- TOC entry 5502 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN feature.fk_name_codespace_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature.fk_name_codespace_id IS 'The codespace of the feature name, reference to the codespace table.';


--
-- TOC entry 5503 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN feature.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature.description IS 'A short description of the feature';


--
-- TOC entry 5504 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN feature.xml; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature.xml IS 'The XML encoded representation of the feature.';


--
-- TOC entry 5505 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN feature.url; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature.url IS 'Optional URL to an external resource that describes the feature, e.g. a WFS';


--
-- TOC entry 5506 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN feature.geom; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature.geom IS 'The geometry/location of feature';


--
-- TOC entry 318 (class 1259 OID 37171)
-- Name: feature_hierarchy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feature_hierarchy (
    fk_child_feature_id bigint NOT NULL,
    fk_parent_feature_id bigint NOT NULL
);


ALTER TABLE public.feature_hierarchy OWNER TO postgres;

--
-- TOC entry 5507 (class 0 OID 0)
-- Dependencies: 318
-- Name: TABLE feature_hierarchy; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.feature_hierarchy IS 'Storage of hierarchies between features';


--
-- TOC entry 5508 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN feature_hierarchy.fk_child_feature_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_hierarchy.fk_child_feature_id IS 'Reference to the child feature in feature table.';


--
-- TOC entry 5509 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN feature_hierarchy.fk_parent_feature_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_hierarchy.fk_parent_feature_id IS 'Reference to the parent feature in feature table.';


--
-- TOC entry 319 (class 1259 OID 37176)
-- Name: feature_i18n; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feature_i18n (
    feature_i18n_id bigint NOT NULL,
    fk_feature_id bigint NOT NULL,
    locale character varying(255) NOT NULL,
    name character varying(255),
    description text
);


ALTER TABLE public.feature_i18n OWNER TO postgres;

--
-- TOC entry 5510 (class 0 OID 0)
-- Dependencies: 319
-- Name: TABLE feature_i18n; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.feature_i18n IS 'Storage for internationalizations of features.';


--
-- TOC entry 5511 (class 0 OID 0)
-- Dependencies: 319
-- Name: COLUMN feature_i18n.feature_i18n_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_i18n.feature_i18n_id IS 'PK column of the table';


--
-- TOC entry 5512 (class 0 OID 0)
-- Dependencies: 319
-- Name: COLUMN feature_i18n.fk_feature_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_i18n.fk_feature_id IS 'Reference to the feature table this internationalization belongs to.';


--
-- TOC entry 5513 (class 0 OID 0)
-- Dependencies: 319
-- Name: COLUMN feature_i18n.locale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_i18n.locale IS 'Locale/language specification for this entry. ISO 639 Codes (http://www.loc.gov/standards/iso639-2/php/code_list.php)';


--
-- TOC entry 5514 (class 0 OID 0)
-- Dependencies: 319
-- Name: COLUMN feature_i18n.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_i18n.name IS 'Locale/language specific name of the feature';


--
-- TOC entry 5515 (class 0 OID 0)
-- Dependencies: 319
-- Name: COLUMN feature_i18n.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_i18n.description IS 'Locale/language specific description of the feature';


--
-- TOC entry 283 (class 1259 OID 37069)
-- Name: feature_i18n_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feature_i18n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.feature_i18n_seq OWNER TO postgres;

--
-- TOC entry 320 (class 1259 OID 37183)
-- Name: feature_parameter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feature_parameter (
    parameter_id bigint NOT NULL,
    type character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    last_update timestamp without time zone,
    domain character varying(255),
    fk_feature_id bigint NOT NULL,
    fk_parent_parameter_id bigint,
    value_boolean smallint,
    value_category character varying(255),
    fk_unit_id bigint,
    value_count integer,
    value_quantity numeric(19,2),
    value_text character varying(255),
    value_xml text,
    value_json text,
    value_temporal_from timestamp without time zone,
    value_temporal_to timestamp without time zone,
    CONSTRAINT feature_parameter_type_check CHECK (((type)::text = ANY ((ARRAY['bool'::character varying, 'category'::character varying, 'count'::character varying, 'quantity'::character varying, 'text'::character varying, 'xml'::character varying, 'json'::character varying, 'complex'::character varying, 'temporal'::character varying])::text[])))
);


ALTER TABLE public.feature_parameter OWNER TO postgres;

--
-- TOC entry 5516 (class 0 OID 0)
-- Dependencies: 320
-- Name: TABLE feature_parameter; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.feature_parameter IS 'Storage for additional information for platforms';


--
-- TOC entry 5517 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.parameter_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.parameter_id IS 'PK column of the table';


--
-- TOC entry 5518 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.type IS 'Indicator used by Hibernate to map value specific entities.';


--
-- TOC entry 5519 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.name IS 'The name of the parameter';


--
-- TOC entry 5520 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.description IS 'A short description of the parameter';


--
-- TOC entry 5521 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.last_update; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.last_update IS 'Timestamp that provides the time of the last modification of this entry';


--
-- TOC entry 5522 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.domain; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.domain IS 'The domain this parameter belongs to.';


--
-- TOC entry 5523 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.fk_feature_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.fk_feature_id IS 'Reference to the Feature this Parameter describes.';


--
-- TOC entry 5524 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.fk_parent_parameter_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.fk_parent_parameter_id IS 'Reference to the Feature this Parameter describes.';


--
-- TOC entry 5525 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.value_boolean; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.value_boolean IS 'Storage of a boolean parameter value.';


--
-- TOC entry 5526 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.value_category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.value_category IS 'Storage of a categorical parameter value.';


--
-- TOC entry 5527 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.fk_unit_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.fk_unit_id IS 'Reference to the unit of this value in the unit table';


--
-- TOC entry 5528 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.value_count; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.value_count IS 'Storage of a count parameter value.';


--
-- TOC entry 5529 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.value_quantity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.value_quantity IS 'Storage of a quantity parameter value.';


--
-- TOC entry 5530 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.value_text; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.value_text IS 'Storage of a textual parameter value.';


--
-- TOC entry 5531 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.value_xml; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.value_xml IS 'Storage of a XML encoded parameter value.';


--
-- TOC entry 5532 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.value_json; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.value_json IS 'Storage of a JSON encoded parameter value.';


--
-- TOC entry 5533 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.value_temporal_from; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.value_temporal_from IS 'Storage of a temporal from parameter value.';


--
-- TOC entry 5534 (class 0 OID 0)
-- Dependencies: 320
-- Name: COLUMN feature_parameter.value_temporal_to; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.feature_parameter.value_temporal_to IS 'Storage of a temporal to parameter value.';


--
-- TOC entry 284 (class 1259 OID 37070)
-- Name: feature_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feature_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.feature_seq OWNER TO postgres;

--
-- TOC entry 321 (class 1259 OID 37191)
-- Name: format; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.format (
    format_id bigint NOT NULL,
    definition character varying(255) NOT NULL
);


ALTER TABLE public.format OWNER TO postgres;

--
-- TOC entry 5535 (class 0 OID 0)
-- Dependencies: 321
-- Name: TABLE format; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.format IS 'Storage of types (feature, observation) and formats (procedure)., e.g. http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement and http://www.opengis.net/sensorml/2.0';


--
-- TOC entry 5536 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN format.format_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.format.format_id IS 'PK column of the table';


--
-- TOC entry 5537 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN format.definition; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.format.definition IS 'The definition of the format.';


--
-- TOC entry 285 (class 1259 OID 37071)
-- Name: format_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.format_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.format_seq OWNER TO postgres;

--
-- TOC entry 322 (class 1259 OID 37196)
-- Name: historical_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historical_location (
    historical_location_id bigint NOT NULL,
    identifier character varying(255) NOT NULL,
    sta_identifier character varying(255) NOT NULL,
    fk_platform_id bigint NOT NULL,
    "time" timestamp without time zone NOT NULL
);


ALTER TABLE public.historical_location OWNER TO postgres;

--
-- TOC entry 5538 (class 0 OID 0)
-- Dependencies: 322
-- Name: COLUMN historical_location.identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.historical_location.identifier IS 'Unique identifier of the HistoricalLocation. Should be a URI, UUID. E.g. http://www.example.org/123, 123-321.';


--
-- TOC entry 5539 (class 0 OID 0)
-- Dependencies: 322
-- Name: COLUMN historical_location.sta_identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.historical_location.sta_identifier IS 'Unique identifier used by SensorThingsAPI for addressing the entity. Should be a URI (reference to a vocabulary entry), UUID. E.g. 123, 123-321';


--
-- TOC entry 286 (class 1259 OID 37072)
-- Name: historical_location_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.historical_location_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.historical_location_seq OWNER TO postgres;

--
-- TOC entry 323 (class 1259 OID 37203)
-- Name: location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location (
    location_id bigint NOT NULL,
    identifier character varying(255) NOT NULL,
    sta_identifier character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    location text,
    geom public.geometry,
    fk_format_id bigint NOT NULL
);


ALTER TABLE public.location OWNER TO postgres;

--
-- TOC entry 5540 (class 0 OID 0)
-- Dependencies: 323
-- Name: COLUMN location.identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location.identifier IS 'Unique identifier of the location. Should be a URI, UUID. E.g. http://www.example.org/123, 123-321.';


--
-- TOC entry 5541 (class 0 OID 0)
-- Dependencies: 323
-- Name: COLUMN location.sta_identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location.sta_identifier IS 'Unique identifier used by SensorThingsAPI for addressing the entity. Should be a URI (reference to a vocabulary entry), UUID. E.g. 123, 123-321';


--
-- TOC entry 324 (class 1259 OID 37210)
-- Name: location_historical_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_historical_location (
    fk_location_id bigint NOT NULL,
    fk_historical_location_id bigint NOT NULL
);


ALTER TABLE public.location_historical_location OWNER TO postgres;

--
-- TOC entry 325 (class 1259 OID 37215)
-- Name: location_i18n; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_i18n (
    location_i18n_id bigint NOT NULL,
    fk_location_id bigint NOT NULL,
    locale character varying(255) NOT NULL,
    name character varying(255),
    description text,
    location text
);


ALTER TABLE public.location_i18n OWNER TO postgres;

--
-- TOC entry 5542 (class 0 OID 0)
-- Dependencies: 325
-- Name: COLUMN location_i18n.location_i18n_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_i18n.location_i18n_id IS 'PK column of the table';


--
-- TOC entry 5543 (class 0 OID 0)
-- Dependencies: 325
-- Name: COLUMN location_i18n.fk_location_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_i18n.fk_location_id IS 'Reference to the feature table this internationalization belongs to.';


--
-- TOC entry 5544 (class 0 OID 0)
-- Dependencies: 325
-- Name: COLUMN location_i18n.locale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_i18n.locale IS 'Locale/language specification for this entry';


--
-- TOC entry 5545 (class 0 OID 0)
-- Dependencies: 325
-- Name: COLUMN location_i18n.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_i18n.name IS 'Locale/language specific name of the location';


--
-- TOC entry 5546 (class 0 OID 0)
-- Dependencies: 325
-- Name: COLUMN location_i18n.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_i18n.description IS 'Locale/language specific description of the location';


--
-- TOC entry 5547 (class 0 OID 0)
-- Dependencies: 325
-- Name: COLUMN location_i18n.location; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_i18n.location IS 'Locale/language specific location property of the location';


--
-- TOC entry 287 (class 1259 OID 37073)
-- Name: location_i18n_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.location_i18n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.location_i18n_seq OWNER TO postgres;

--
-- TOC entry 326 (class 1259 OID 37222)
-- Name: location_parameter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_parameter (
    parameter_id bigint NOT NULL,
    type character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    last_update timestamp without time zone,
    domain character varying(255),
    fk_location_id bigint NOT NULL,
    fk_parent_parameter_id bigint,
    value_boolean smallint,
    value_category character varying(255),
    fk_unit_id bigint,
    value_count integer,
    value_quantity numeric(19,2),
    value_text character varying(255),
    value_xml text,
    value_json text,
    value_temporal_from timestamp without time zone,
    value_temporal_to timestamp without time zone,
    CONSTRAINT location_parameter_type_check CHECK (((type)::text = ANY ((ARRAY['bool'::character varying, 'category'::character varying, 'count'::character varying, 'quantity'::character varying, 'text'::character varying, 'xml'::character varying, 'json'::character varying, 'complex'::character varying, 'temporal'::character varying])::text[])))
);


ALTER TABLE public.location_parameter OWNER TO postgres;

--
-- TOC entry 5548 (class 0 OID 0)
-- Dependencies: 326
-- Name: TABLE location_parameter; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.location_parameter IS 'Storage for additional information for platforms';


--
-- TOC entry 5549 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.parameter_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.parameter_id IS 'PK column of the table';


--
-- TOC entry 5550 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.type IS 'Indicator used by Hibernate to map value specific entities.';


--
-- TOC entry 5551 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.name IS 'The name of the parameter';


--
-- TOC entry 5552 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.description IS 'A short description of the parameter';


--
-- TOC entry 5553 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.last_update; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.last_update IS 'Timestamp that provides the time of the last modification of this entry';


--
-- TOC entry 5554 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.domain; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.domain IS 'The domain this parameter belongs to.';


--
-- TOC entry 5555 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.fk_location_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.fk_location_id IS 'Reference to the Location this Parameter describes.';


--
-- TOC entry 5556 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.fk_parent_parameter_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.fk_parent_parameter_id IS 'Reference to the Location this Parameter describes.';


--
-- TOC entry 5557 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.value_boolean; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.value_boolean IS 'Storage of a boolean parameter value.';


--
-- TOC entry 5558 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.value_category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.value_category IS 'Storage of a categorical parameter value.';


--
-- TOC entry 5559 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.fk_unit_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.fk_unit_id IS 'Reference to the unit of this value in the unit table';


--
-- TOC entry 5560 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.value_count; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.value_count IS 'Storage of a count parameter value.';


--
-- TOC entry 5561 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.value_quantity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.value_quantity IS 'Storage of a quantity parameter value.';


--
-- TOC entry 5562 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.value_text; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.value_text IS 'Storage of a textual parameter value.';


--
-- TOC entry 5563 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.value_xml; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.value_xml IS 'Storage of a XML encoded parameter value.';


--
-- TOC entry 5564 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.value_json; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.value_json IS 'Storage of a JSON encoded parameter value.';


--
-- TOC entry 5565 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.value_temporal_from; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.value_temporal_from IS 'Storage of a temporal from parameter value.';


--
-- TOC entry 5566 (class 0 OID 0)
-- Dependencies: 326
-- Name: COLUMN location_parameter.value_temporal_to; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.location_parameter.value_temporal_to IS 'Storage of a temporal to parameter value.';


--
-- TOC entry 288 (class 1259 OID 37074)
-- Name: location_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.location_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.location_seq OWNER TO postgres;

--
-- TOC entry 327 (class 1259 OID 37230)
-- Name: observation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.observation (
    observation_id bigint NOT NULL,
    value_type character varying(255) NOT NULL,
    fk_dataset_id bigint NOT NULL,
    sampling_time_start timestamp without time zone NOT NULL,
    sampling_time_end timestamp without time zone NOT NULL,
    result_time timestamp without time zone,
    identifier character varying(255),
    sta_identifier character varying(255) NOT NULL,
    fk_identifier_codespace_id bigint,
    name character varying(255),
    fk_name_codespace_id bigint,
    description text,
    is_deleted smallint DEFAULT 0 NOT NULL,
    valid_time_start timestamp without time zone,
    valid_time_end timestamp without time zone,
    sampling_geometry public.geometry,
    value_identifier character varying(255),
    value_name character varying(255),
    value_description character varying(255),
    vertical_from numeric(20,10) DEFAULT 0 NOT NULL,
    vertical_to numeric(20,10) DEFAULT 0 NOT NULL,
    fk_parent_observation_id bigint,
    value_quantity numeric(20,10),
    value_text character varying(255),
    value_count integer,
    value_category character varying(255),
    value_boolean smallint,
    detection_limit_flag smallint,
    detection_limit numeric(20,10),
    value_reference character varying(255),
    value_geometry public.geometry,
    value_array text,
    fk_result_template_id bigint,
    CONSTRAINT observation_detection_limit_flag_check CHECK ((detection_limit_flag = ANY (ARRAY[NULL::integer, '-1'::integer, 1]))),
    CONSTRAINT observation_is_deleted_check CHECK ((is_deleted = ANY (ARRAY[1, 0]))),
    CONSTRAINT observation_value_type_check CHECK (((value_type)::text = ANY ((ARRAY['quantity'::character varying, 'count'::character varying, 'text'::character varying, 'category'::character varying, 'bool'::character varying, 'profile'::character varying, 'complex'::character varying, 'dataarray'::character varying, 'geometry'::character varying, 'blob'::character varying, 'reference'::character varying, 'trajectory'::character varying, 'sensorML20'::character varying])::text[])))
);


ALTER TABLE public.observation OWNER TO postgres;

--
-- TOC entry 5567 (class 0 OID 0)
-- Dependencies: 327
-- Name: TABLE observation; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.observation IS 'Storage of the observation values with the timestamp and additional metadata. The metadata are height/depth values for profile observation and sampling geometries for trajectory observations. In each observation entry only one value_... column should be filled with a value!';


--
-- TOC entry 5568 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.observation_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.observation_id IS 'PK column of the table';


--
-- TOC entry 5569 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.value_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.value_type IS 'Indicator used by Hibernate to map value specific entities. Valid values are quantity (scalar values in value_quantity), count (integer values in value_count), text (textual values in value_text), category (categorical values in value_category), bool (boolean values in value_boolean), reference (references in value_reference, e.g. link to a source, photo, video)';


--
-- TOC entry 5570 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.fk_dataset_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.fk_dataset_id IS 'Reference to the dataset to which this observation belongs.';


--
-- TOC entry 5571 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.sampling_time_start; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.sampling_time_start IS 'The timestamp when the observation period has started or the observation took place. In the the latter, sampling_time_start and sampling_time_end are equal.';


--
-- TOC entry 5572 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.sampling_time_end; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.sampling_time_end IS 'The timestamp when the measurement period has finished or the observation took place. In the the latter, sampling_time_start and sampling_time_end are equal.';


--
-- TOC entry 5573 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.result_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.result_time IS 'The timestamp when the observation was published. Might be identical with sampling_time_start and sampling_time_end.';


--
-- TOC entry 5574 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.identifier IS 'Unique identifier of the observation which can be for used filtering, e.g. GetObservationById in the SOS. Should be a URI, UUID. E.g. http://www.example.org/123, 123-321';


--
-- TOC entry 5575 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.sta_identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.sta_identifier IS 'Unique identifier used by SensorThingsAPI for addressing the entity. Should be a URI (reference to a vocabulary entry), UUID. E.g. 123, 123-321';


--
-- TOC entry 5576 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.fk_identifier_codespace_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.fk_identifier_codespace_id IS 'The codespace of the data/observation identifier, reference to the codespace table. Can be null.';


--
-- TOC entry 5577 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.name IS 'The human readable name of the observation.';


--
-- TOC entry 5578 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.fk_name_codespace_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.fk_name_codespace_id IS 'The codespace of the data/observation name, reference to the codespace table. Can be null.';


--
-- TOC entry 5579 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.description IS 'A short description of the observation';


--
-- TOC entry 5580 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.is_deleted; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.is_deleted IS 'Flag that indicates if this observation is deleted';


--
-- TOC entry 5581 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.valid_time_start; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.valid_time_start IS 'The timestamp from when the obervation is valid, e.g. forcaste observations';


--
-- TOC entry 5582 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.valid_time_end; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.valid_time_end IS 'The timestamp until when the obervation is valid, e.g. forcaste observations';


--
-- TOC entry 5583 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.sampling_geometry; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.sampling_geometry IS 'The geometry that represents the location where the observation was observed, e.g. mobile observations (trajectories) where this geometry is different from the feature geometry.';


--
-- TOC entry 5584 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.value_identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.value_identifier IS 'Identifier of the value. E.g. used in OGC SWE encoded values like SweText';


--
-- TOC entry 5585 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.value_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.value_name IS 'Identifier of the name. E.g. used in OGC SWE encoded values like SweText';


--
-- TOC entry 5586 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.value_description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.value_description IS 'Identifier of the description. E.g. used in OGC SWE encoded values like SweText';


--
-- TOC entry 5587 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.vertical_from; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.vertical_from IS 'The start level of a vertical observation, required for profile observations';


--
-- TOC entry 5588 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.vertical_to; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.vertical_to IS 'The end level or the level of a vertical observation, required for profile observations';


--
-- TOC entry 5589 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.fk_parent_observation_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.fk_parent_observation_id IS 'Reference to the parent observation in the case of complex observations like profiles, complex or swedataarray observations.';


--
-- TOC entry 5590 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.detection_limit_flag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.detection_limit_flag IS 'Flag that indicates if measured value lower/higher of the detection limit.';


--
-- TOC entry 5591 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.detection_limit; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.detection_limit IS 'The detection limit';


--
-- TOC entry 5592 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.value_reference; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.value_reference IS 'The reference value (URI) of an observation (ReferenceObservation)';


--
-- TOC entry 5593 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.value_geometry; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.value_geometry IS 'The geometry value of an observation (GeometryObservation)';


--
-- TOC entry 5594 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.value_array; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.value_array IS 'The textual value of an observation (SweDataArrayObservation))';


--
-- TOC entry 5595 (class 0 OID 0)
-- Dependencies: 327
-- Name: COLUMN observation.fk_result_template_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation.fk_result_template_id IS 'Reference to the result template which holds the structure and encoding.';


--
-- TOC entry 328 (class 1259 OID 37243)
-- Name: observation_i18n; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.observation_i18n (
    observation_i18n_id bigint NOT NULL,
    fk_observation_id bigint NOT NULL,
    locale character varying(255) NOT NULL,
    name character varying(255),
    description text,
    value_name character varying(255),
    value_description character varying(255)
);


ALTER TABLE public.observation_i18n OWNER TO postgres;

--
-- TOC entry 5596 (class 0 OID 0)
-- Dependencies: 328
-- Name: COLUMN observation_i18n.observation_i18n_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_i18n.observation_i18n_id IS 'PK column of the table';


--
-- TOC entry 5597 (class 0 OID 0)
-- Dependencies: 328
-- Name: COLUMN observation_i18n.fk_observation_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_i18n.fk_observation_id IS 'Reference to the data table this internationalization belongs to.';


--
-- TOC entry 5598 (class 0 OID 0)
-- Dependencies: 328
-- Name: COLUMN observation_i18n.locale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_i18n.locale IS 'Locale/language specification for this entry. ISO 639 Codes (http://www.loc.gov/standards/iso639-2/php/code_list.php)';


--
-- TOC entry 5599 (class 0 OID 0)
-- Dependencies: 328
-- Name: COLUMN observation_i18n.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_i18n.name IS 'Locale/language specific name of the data entity';


--
-- TOC entry 5600 (class 0 OID 0)
-- Dependencies: 328
-- Name: COLUMN observation_i18n.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_i18n.description IS 'Locale/language specific description of the data entity';


--
-- TOC entry 5601 (class 0 OID 0)
-- Dependencies: 328
-- Name: COLUMN observation_i18n.value_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_i18n.value_name IS 'Locale/language specific name of the data entity';


--
-- TOC entry 5602 (class 0 OID 0)
-- Dependencies: 328
-- Name: COLUMN observation_i18n.value_description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_i18n.value_description IS 'Locale/language specific description of the data entity';


--
-- TOC entry 289 (class 1259 OID 37075)
-- Name: observation_i18n_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.observation_i18n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.observation_i18n_seq OWNER TO postgres;

--
-- TOC entry 329 (class 1259 OID 37250)
-- Name: observation_parameter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.observation_parameter (
    parameter_id bigint NOT NULL,
    type character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    last_update timestamp without time zone,
    domain character varying(255),
    fk_observation_id bigint NOT NULL,
    fk_parent_parameter_id bigint,
    value_boolean smallint,
    value_category character varying(255),
    fk_unit_id bigint,
    value_count integer,
    value_quantity numeric(19,2),
    value_text character varying(255),
    value_xml text,
    value_json text,
    value_temporal_from timestamp without time zone,
    value_temporal_to timestamp without time zone,
    CONSTRAINT observation_parameter_type_check CHECK (((type)::text = ANY ((ARRAY['bool'::character varying, 'category'::character varying, 'count'::character varying, 'quantity'::character varying, 'text'::character varying, 'xml'::character varying, 'json'::character varying, 'complex'::character varying, 'temporal'::character varying])::text[])))
);


ALTER TABLE public.observation_parameter OWNER TO postgres;

--
-- TOC entry 5603 (class 0 OID 0)
-- Dependencies: 329
-- Name: TABLE observation_parameter; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.observation_parameter IS 'Storage of relations between observation and related parameter';


--
-- TOC entry 5604 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.parameter_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.parameter_id IS 'PK column of the table';


--
-- TOC entry 5605 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.type IS 'Indicator used by Hibernate to map value specific entities.';


--
-- TOC entry 5606 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.name IS 'The name of the parameter';


--
-- TOC entry 5607 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.description IS 'A short description of the parameter';


--
-- TOC entry 5608 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.last_update; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.last_update IS 'Timestamp that provides the time of the last modification of this entry';


--
-- TOC entry 5609 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.domain; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.domain IS 'The domain this parameter belongs to.';


--
-- TOC entry 5610 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.fk_observation_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.fk_observation_id IS 'Reference to the Observation this Parameter describes.';


--
-- TOC entry 5611 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.fk_parent_parameter_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.fk_parent_parameter_id IS 'Reference to the Observation this Parameter describes.';


--
-- TOC entry 5612 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.value_boolean; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.value_boolean IS 'Storage of a boolean parameter value.';


--
-- TOC entry 5613 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.value_category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.value_category IS 'Storage of a categorical parameter value.';


--
-- TOC entry 5614 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.fk_unit_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.fk_unit_id IS 'Reference to the unit of this value in the unit table';


--
-- TOC entry 5615 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.value_count; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.value_count IS 'Storage of a count parameter value.';


--
-- TOC entry 5616 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.value_quantity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.value_quantity IS 'Storage of a quantity parameter value.';


--
-- TOC entry 5617 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.value_text; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.value_text IS 'Storage of a textual parameter value.';


--
-- TOC entry 5618 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.value_xml; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.value_xml IS 'Storage of a XML encoded parameter value.';


--
-- TOC entry 5619 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.value_json; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.value_json IS 'Storage of a JSON encoded parameter value.';


--
-- TOC entry 5620 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.value_temporal_from; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.value_temporal_from IS 'Storage of a temporal from parameter value.';


--
-- TOC entry 5621 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN observation_parameter.value_temporal_to; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.observation_parameter.value_temporal_to IS 'Storage of a temporal to parameter value.';


--
-- TOC entry 290 (class 1259 OID 37076)
-- Name: observation_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.observation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.observation_seq OWNER TO postgres;

--
-- TOC entry 330 (class 1259 OID 37258)
-- Name: offering; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offering (
    offering_id bigint NOT NULL,
    identifier character varying(255) NOT NULL,
    fk_identifier_codespace_id bigint,
    name character varying(255),
    fk_name_codespace_id bigint,
    description text,
    sampling_time_start timestamp without time zone,
    sampling_time_end timestamp without time zone,
    result_time_start timestamp without time zone,
    result_time_end timestamp without time zone,
    valid_time_start timestamp without time zone,
    valid_time_end timestamp without time zone,
    geom public.geometry
);


ALTER TABLE public.offering OWNER TO postgres;

--
-- TOC entry 5622 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE offering; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.offering IS 'Storage of the offerings which is required by the SOS. An offering is used in SOS to group records according to specific criteria. In the INSPIRE context, an offering is an "INSPRE spatial dataset," an identifiable collection of spatial data.';


--
-- TOC entry 5623 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN offering.offering_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering.offering_id IS 'PK column of the table';


--
-- TOC entry 5624 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN offering.identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering.identifier IS 'Unique identifier of the offering which can be used for filtering. Should be a URI, UUID. E.g. http://www.example.org/123, 123-321.';


--
-- TOC entry 5625 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN offering.fk_identifier_codespace_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering.fk_identifier_codespace_id IS 'The codespace of the offering identifier, reference to the codespace table.';


--
-- TOC entry 5626 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN offering.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering.name IS 'The human readable name of the offering.';


--
-- TOC entry 5627 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN offering.fk_name_codespace_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering.fk_name_codespace_id IS 'The codespace of the offering name, reference to the codespace table.';


--
-- TOC entry 5628 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN offering.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering.description IS 'A short description of the offering';


--
-- TOC entry 5629 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN offering.sampling_time_start; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering.sampling_time_start IS 'The minimum samplingTimeStart of all observation that belong to this offering. If the column is empty, the information is calculated during the cache update and stored locally. Used for the capabilities of the SOS.';


--
-- TOC entry 5630 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN offering.sampling_time_end; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering.sampling_time_end IS 'The maximum samplingTimeStart of all observation that belong to this offering. If the column is empty, the information is calculated during the cache update and stored locally. Used for the capabilities of the SOS.';


--
-- TOC entry 5631 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN offering.result_time_start; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering.result_time_start IS 'The minimum resultTimeStart of all observation that belong to this offering. If the column is empty, the information is calculated during the cache update and stored locally. Used for the capabilities of the SOS.';


--
-- TOC entry 5632 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN offering.result_time_end; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering.result_time_end IS 'The maximum resultTimeEnd of all observation that belong to this offering. If the column is empty, the information is calculated during the cache update and stored locally. Used for the capabilities of the SOS.';


--
-- TOC entry 5633 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN offering.valid_time_start; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering.valid_time_start IS 'The minimum validTimeStart of all observation that belong to this offering. If the column is empty, the information is calculated during the cache update and stored locally. Used for the capabilities of the SOS.';


--
-- TOC entry 5634 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN offering.valid_time_end; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering.valid_time_end IS 'The maximum validTimeEnd of all observation that belong to this offering. If the column is empty, the information is calculated during the cache update and stored locally. Used for the capabilities of the SOS.';


--
-- TOC entry 5635 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN offering.geom; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering.geom IS 'The envelope/geometry of all features or samplingGeometries of observations that belong to this offering. If the column is empty, the information is calculated during the cache update and stored locally. Used for the capabilities of the SOS.';


--
-- TOC entry 331 (class 1259 OID 37265)
-- Name: offering_feature_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offering_feature_type (
    fk_offering_id bigint NOT NULL,
    fk_format_id bigint NOT NULL
);


ALTER TABLE public.offering_feature_type OWNER TO postgres;

--
-- TOC entry 5636 (class 0 OID 0)
-- Dependencies: 331
-- Name: TABLE offering_feature_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.offering_feature_type IS 'Relation to store the valid  featureTypes for the offering';


--
-- TOC entry 5637 (class 0 OID 0)
-- Dependencies: 331
-- Name: COLUMN offering_feature_type.fk_offering_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering_feature_type.fk_offering_id IS 'The related offering';


--
-- TOC entry 5638 (class 0 OID 0)
-- Dependencies: 331
-- Name: COLUMN offering_feature_type.fk_format_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering_feature_type.fk_format_id IS 'The reference of the related featureType from the format table';


--
-- TOC entry 332 (class 1259 OID 37270)
-- Name: offering_hierarchy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offering_hierarchy (
    fk_child_offering_id bigint NOT NULL,
    fk_parent_offering_id bigint NOT NULL
);


ALTER TABLE public.offering_hierarchy OWNER TO postgres;

--
-- TOC entry 5639 (class 0 OID 0)
-- Dependencies: 332
-- Name: COLUMN offering_hierarchy.fk_child_offering_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering_hierarchy.fk_child_offering_id IS 'Reference to the child offering in offering table.';


--
-- TOC entry 5640 (class 0 OID 0)
-- Dependencies: 332
-- Name: COLUMN offering_hierarchy.fk_parent_offering_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering_hierarchy.fk_parent_offering_id IS 'Reference to the parent offering in offering table.';


--
-- TOC entry 333 (class 1259 OID 37275)
-- Name: offering_i18n; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offering_i18n (
    offering_i18n_id bigint NOT NULL,
    fk_offering_id bigint NOT NULL,
    locale character varying(255) NOT NULL,
    name character varying(255),
    description text
);


ALTER TABLE public.offering_i18n OWNER TO postgres;

--
-- TOC entry 5641 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE offering_i18n; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.offering_i18n IS 'Storage for internationalizations of offerings.';


--
-- TOC entry 5642 (class 0 OID 0)
-- Dependencies: 333
-- Name: COLUMN offering_i18n.offering_i18n_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering_i18n.offering_i18n_id IS 'PK column of the table';


--
-- TOC entry 5643 (class 0 OID 0)
-- Dependencies: 333
-- Name: COLUMN offering_i18n.fk_offering_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering_i18n.fk_offering_id IS 'Reference to the offering table this internationalization belongs to.';


--
-- TOC entry 5644 (class 0 OID 0)
-- Dependencies: 333
-- Name: COLUMN offering_i18n.locale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering_i18n.locale IS 'Locale/language specification for this entry. ISO 639 Codes (http://www.loc.gov/standards/iso639-2/php/code_list.php)';


--
-- TOC entry 5645 (class 0 OID 0)
-- Dependencies: 333
-- Name: COLUMN offering_i18n.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering_i18n.name IS 'Locale/language specific name of the offering';


--
-- TOC entry 5646 (class 0 OID 0)
-- Dependencies: 333
-- Name: COLUMN offering_i18n.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering_i18n.description IS 'Locale/language specific description of the offering';


--
-- TOC entry 291 (class 1259 OID 37077)
-- Name: offering_i18n_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.offering_i18n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.offering_i18n_seq OWNER TO postgres;

--
-- TOC entry 334 (class 1259 OID 37282)
-- Name: offering_observation_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offering_observation_type (
    fk_offering_id bigint NOT NULL,
    fk_format_id bigint NOT NULL
);


ALTER TABLE public.offering_observation_type OWNER TO postgres;

--
-- TOC entry 5647 (class 0 OID 0)
-- Dependencies: 334
-- Name: TABLE offering_observation_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.offering_observation_type IS 'Relation to store the valid observationTypes for the offering';


--
-- TOC entry 5648 (class 0 OID 0)
-- Dependencies: 334
-- Name: COLUMN offering_observation_type.fk_offering_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering_observation_type.fk_offering_id IS 'The related offering';


--
-- TOC entry 5649 (class 0 OID 0)
-- Dependencies: 334
-- Name: COLUMN offering_observation_type.fk_format_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering_observation_type.fk_format_id IS 'The reference of the related observationType from the format table';


--
-- TOC entry 335 (class 1259 OID 37287)
-- Name: offering_related_feature; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.offering_related_feature (
    fk_offering_id bigint NOT NULL,
    fk_related_feature_id bigint NOT NULL
);


ALTER TABLE public.offering_related_feature OWNER TO postgres;

--
-- TOC entry 5650 (class 0 OID 0)
-- Dependencies: 335
-- Name: TABLE offering_related_feature; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.offering_related_feature IS 'Storage tfor the relation between offering and relatedFeature';


--
-- TOC entry 5651 (class 0 OID 0)
-- Dependencies: 335
-- Name: COLUMN offering_related_feature.fk_offering_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering_related_feature.fk_offering_id IS 'The related offering';


--
-- TOC entry 5652 (class 0 OID 0)
-- Dependencies: 335
-- Name: COLUMN offering_related_feature.fk_related_feature_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.offering_related_feature.fk_related_feature_id IS 'The reference to the relatedFeature from the relatedFeature table';


--
-- TOC entry 292 (class 1259 OID 37078)
-- Name: offering_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.offering_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.offering_seq OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 37079)
-- Name: parameter_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.parameter_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.parameter_seq OWNER TO postgres;

--
-- TOC entry 336 (class 1259 OID 37292)
-- Name: phenomenon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.phenomenon (
    phenomenon_id bigint NOT NULL,
    identifier character varying(255) NOT NULL,
    sta_identifier character varying(255) NOT NULL,
    fk_identifier_codespace_id bigint,
    name character varying(255),
    fk_name_codespace_id bigint,
    description text
);


ALTER TABLE public.phenomenon OWNER TO postgres;

--
-- TOC entry 5653 (class 0 OID 0)
-- Dependencies: 336
-- Name: TABLE phenomenon; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.phenomenon IS 'Storage of the phenomenon/observableProperties, e.g. air temperature, water temperature, ...';


--
-- TOC entry 5654 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN phenomenon.phenomenon_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon.phenomenon_id IS 'PK column of the table';


--
-- TOC entry 5655 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN phenomenon.identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon.identifier IS 'Unique identifier of the phenomenon which can be used for filtering. Should be a URI (reference to a vocabulary entry), UUID. E.g. http://www.example.org/123, 123-321';


--
-- TOC entry 5656 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN phenomenon.sta_identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon.sta_identifier IS 'Unique identifier used by SensorThingsAPI for addressing the entity. Should be a URI (reference to a vocabulary entry), UUID. E.g. 123, 123-321';


--
-- TOC entry 5657 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN phenomenon.fk_identifier_codespace_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon.fk_identifier_codespace_id IS 'The codespace of the phenomenon identifier, reference to the codespace table.';


--
-- TOC entry 5658 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN phenomenon.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon.name IS 'The human readable name of the phenomenon.';


--
-- TOC entry 5659 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN phenomenon.fk_name_codespace_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon.fk_name_codespace_id IS 'The codespace of the phenomenon name, reference to the codespace table.';


--
-- TOC entry 5660 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN phenomenon.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon.description IS 'A short description of the phenomenon';


--
-- TOC entry 337 (class 1259 OID 37299)
-- Name: phenomenon_i18n; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.phenomenon_i18n (
    phenomenon_i18n_id bigint NOT NULL,
    fk_phenomenon_id bigint NOT NULL,
    locale character varying(255) NOT NULL,
    name character varying(255),
    description text
);


ALTER TABLE public.phenomenon_i18n OWNER TO postgres;

--
-- TOC entry 5661 (class 0 OID 0)
-- Dependencies: 337
-- Name: TABLE phenomenon_i18n; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.phenomenon_i18n IS 'Storage for internationalizations of phenomenon.';


--
-- TOC entry 5662 (class 0 OID 0)
-- Dependencies: 337
-- Name: COLUMN phenomenon_i18n.phenomenon_i18n_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_i18n.phenomenon_i18n_id IS 'PK column of the table';


--
-- TOC entry 5663 (class 0 OID 0)
-- Dependencies: 337
-- Name: COLUMN phenomenon_i18n.fk_phenomenon_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_i18n.fk_phenomenon_id IS 'Reference to the phenomenon table this internationalization belongs to.';


--
-- TOC entry 5664 (class 0 OID 0)
-- Dependencies: 337
-- Name: COLUMN phenomenon_i18n.locale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_i18n.locale IS 'Locale/language specification for this entry. ISO 639 Codes (http://www.loc.gov/standards/iso639-2/php/code_list.php)';


--
-- TOC entry 5665 (class 0 OID 0)
-- Dependencies: 337
-- Name: COLUMN phenomenon_i18n.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_i18n.name IS 'Locale/language specific name of the phenomenon';


--
-- TOC entry 5666 (class 0 OID 0)
-- Dependencies: 337
-- Name: COLUMN phenomenon_i18n.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_i18n.description IS 'Locale/language specific description of the phenomenon';


--
-- TOC entry 294 (class 1259 OID 37080)
-- Name: phenomenon_i18n_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.phenomenon_i18n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phenomenon_i18n_seq OWNER TO postgres;

--
-- TOC entry 338 (class 1259 OID 37306)
-- Name: phenomenon_parameter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.phenomenon_parameter (
    parameter_id bigint NOT NULL,
    type character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    last_update timestamp without time zone,
    domain character varying(255),
    fk_phenomenon_id bigint NOT NULL,
    fk_parent_parameter_id bigint,
    value_boolean smallint,
    value_category character varying(255),
    fk_unit_id bigint,
    value_count integer,
    value_quantity numeric(19,2),
    value_text character varying(255),
    value_xml text,
    value_json text,
    value_temporal_from timestamp without time zone,
    value_temporal_to timestamp without time zone,
    CONSTRAINT phenomenon_parameter_type_check CHECK (((type)::text = ANY ((ARRAY['bool'::character varying, 'category'::character varying, 'count'::character varying, 'quantity'::character varying, 'text'::character varying, 'xml'::character varying, 'json'::character varying, 'complex'::character varying, 'temporal'::character varying])::text[])))
);


ALTER TABLE public.phenomenon_parameter OWNER TO postgres;

--
-- TOC entry 5667 (class 0 OID 0)
-- Dependencies: 338
-- Name: TABLE phenomenon_parameter; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.phenomenon_parameter IS 'Storage for additional information for platforms';


--
-- TOC entry 5668 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.parameter_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.parameter_id IS 'PK column of the table';


--
-- TOC entry 5669 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.type IS 'Indicator used by Hibernate to map value specific entities.';


--
-- TOC entry 5670 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.name IS 'The name of the parameter';


--
-- TOC entry 5671 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.description IS 'A short description of the parameter';


--
-- TOC entry 5672 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.last_update; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.last_update IS 'Timestamp that provides the time of the last modification of this entry';


--
-- TOC entry 5673 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.domain; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.domain IS 'The domain this parameter belongs to.';


--
-- TOC entry 5674 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.fk_phenomenon_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.fk_phenomenon_id IS 'Reference to the Phenomenon this Parameter describes.';


--
-- TOC entry 5675 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.fk_parent_parameter_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.fk_parent_parameter_id IS 'Reference to the Phenomenon this Parameter describes.';


--
-- TOC entry 5676 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.value_boolean; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.value_boolean IS 'Storage of a boolean parameter value.';


--
-- TOC entry 5677 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.value_category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.value_category IS 'Storage of a categorical parameter value.';


--
-- TOC entry 5678 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.fk_unit_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.fk_unit_id IS 'Reference to the unit of this value in the unit table';


--
-- TOC entry 5679 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.value_count; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.value_count IS 'Storage of a count parameter value.';


--
-- TOC entry 5680 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.value_quantity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.value_quantity IS 'Storage of a quantity parameter value.';


--
-- TOC entry 5681 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.value_text; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.value_text IS 'Storage of a textual parameter value.';


--
-- TOC entry 5682 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.value_xml; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.value_xml IS 'Storage of a XML encoded parameter value.';


--
-- TOC entry 5683 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.value_json; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.value_json IS 'Storage of a JSON encoded parameter value.';


--
-- TOC entry 5684 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.value_temporal_from; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.value_temporal_from IS 'Storage of a temporal from parameter value.';


--
-- TOC entry 5685 (class 0 OID 0)
-- Dependencies: 338
-- Name: COLUMN phenomenon_parameter.value_temporal_to; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.phenomenon_parameter.value_temporal_to IS 'Storage of a temporal to parameter value.';


--
-- TOC entry 295 (class 1259 OID 37081)
-- Name: phenomenon_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.phenomenon_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phenomenon_seq OWNER TO postgres;

--
-- TOC entry 339 (class 1259 OID 37314)
-- Name: platform; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.platform (
    platform_id bigint NOT NULL,
    identifier character varying(255) NOT NULL,
    sta_identifier character varying(255) NOT NULL,
    fk_identifier_codespace_id bigint,
    name character varying(255),
    fk_name_codespace_id bigint,
    description text
);


ALTER TABLE public.platform OWNER TO postgres;

--
-- TOC entry 5686 (class 0 OID 0)
-- Dependencies: 339
-- Name: TABLE platform; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.platform IS 'Storage of the platforms. With a platform several procedures can be grouped or in the case of citizen science the platform can be the camera or mobile phone. An example of a platform is a vessel that has multiple sensors (Procedure). In most cases, the platform is the same as the platform or procedure, such as a weather station or a water level location.';


--
-- TOC entry 5687 (class 0 OID 0)
-- Dependencies: 339
-- Name: COLUMN platform.platform_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform.platform_id IS 'PK column of the table';


--
-- TOC entry 5688 (class 0 OID 0)
-- Dependencies: 339
-- Name: COLUMN platform.identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform.identifier IS 'Unique identifier of the platform which can be used for filtering. Should be a URI, UUID. E.g. http://www.example.org/123, 123-321';


--
-- TOC entry 5689 (class 0 OID 0)
-- Dependencies: 339
-- Name: COLUMN platform.sta_identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform.sta_identifier IS 'Unique identifier used by SensorThingsAPI for addressing the entity. Should be a URI (reference to a vocabulary entry), UUID. E.g. 123, 123-321';


--
-- TOC entry 5690 (class 0 OID 0)
-- Dependencies: 339
-- Name: COLUMN platform.fk_identifier_codespace_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform.fk_identifier_codespace_id IS 'The codespace of the platform identifier, reference to the codespace table.';


--
-- TOC entry 5691 (class 0 OID 0)
-- Dependencies: 339
-- Name: COLUMN platform.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform.name IS 'The human readable name of the platform.';


--
-- TOC entry 5692 (class 0 OID 0)
-- Dependencies: 339
-- Name: COLUMN platform.fk_name_codespace_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform.fk_name_codespace_id IS 'The codespace of the platform name, reference to the codespace table.';


--
-- TOC entry 5693 (class 0 OID 0)
-- Dependencies: 339
-- Name: COLUMN platform.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform.description IS 'A short description of the platform';


--
-- TOC entry 340 (class 1259 OID 37321)
-- Name: platform_i18n; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.platform_i18n (
    platform_i18n_id bigint NOT NULL,
    fk_platform_id bigint NOT NULL,
    locale character varying(255) NOT NULL,
    name character varying(255),
    description text
);


ALTER TABLE public.platform_i18n OWNER TO postgres;

--
-- TOC entry 5694 (class 0 OID 0)
-- Dependencies: 340
-- Name: COLUMN platform_i18n.platform_i18n_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_i18n.platform_i18n_id IS 'PK column of the table';


--
-- TOC entry 5695 (class 0 OID 0)
-- Dependencies: 340
-- Name: COLUMN platform_i18n.fk_platform_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_i18n.fk_platform_id IS 'Reference to the platform table this internationalization belongs to.';


--
-- TOC entry 5696 (class 0 OID 0)
-- Dependencies: 340
-- Name: COLUMN platform_i18n.locale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_i18n.locale IS 'Locale/language specification for this entry. ISO 639 Codes (http://www.loc.gov/standards/iso639-2/php/code_list.php)';


--
-- TOC entry 5697 (class 0 OID 0)
-- Dependencies: 340
-- Name: COLUMN platform_i18n.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_i18n.name IS 'Locale/language specific name of the platform';


--
-- TOC entry 5698 (class 0 OID 0)
-- Dependencies: 340
-- Name: COLUMN platform_i18n.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_i18n.description IS 'Locale/language specific description of the platform';


--
-- TOC entry 296 (class 1259 OID 37082)
-- Name: platform_i18n_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.platform_i18n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.platform_i18n_seq OWNER TO postgres;

--
-- TOC entry 341 (class 1259 OID 37328)
-- Name: platform_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.platform_location (
    fk_platform_id bigint NOT NULL,
    fk_location_id bigint NOT NULL
);


ALTER TABLE public.platform_location OWNER TO postgres;

--
-- TOC entry 342 (class 1259 OID 37333)
-- Name: platform_parameter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.platform_parameter (
    parameter_id bigint NOT NULL,
    type character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    last_update timestamp without time zone,
    domain character varying(255),
    fk_platform_id bigint NOT NULL,
    fk_parent_parameter_id bigint,
    value_category character varying(255),
    fk_unit_id bigint,
    value_boolean smallint,
    value_count integer,
    value_quantity numeric(19,2),
    value_text character varying(255),
    value_xml text,
    value_json text,
    value_temporal_from timestamp without time zone,
    value_temporal_to timestamp without time zone,
    CONSTRAINT platform_parameter_type_check CHECK (((type)::text = ANY ((ARRAY['bool'::character varying, 'category'::character varying, 'count'::character varying, 'quantity'::character varying, 'text'::character varying, 'xml'::character varying, 'json'::character varying, 'complex'::character varying, 'temporal'::character varying])::text[])))
);


ALTER TABLE public.platform_parameter OWNER TO postgres;

--
-- TOC entry 5699 (class 0 OID 0)
-- Dependencies: 342
-- Name: TABLE platform_parameter; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.platform_parameter IS 'Storage for additional information for platforms';


--
-- TOC entry 5700 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.parameter_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.parameter_id IS 'PK column of the table';


--
-- TOC entry 5701 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.type IS 'Indicator used by Hibernate to map value specific entities.';


--
-- TOC entry 5702 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.name IS 'The name of the parameter';


--
-- TOC entry 5703 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.description IS 'A short description of the parameter';


--
-- TOC entry 5704 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.last_update; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.last_update IS 'Timestamp that provides the time of the last modification of this entry';


--
-- TOC entry 5705 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.domain; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.domain IS 'The domain this parameter belongs to.';


--
-- TOC entry 5706 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.fk_platform_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.fk_platform_id IS 'Reference to the Platform this Parameter describes.';


--
-- TOC entry 5707 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.fk_parent_parameter_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.fk_parent_parameter_id IS 'Reference to the Platform this Parameter describes.';


--
-- TOC entry 5708 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.value_category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.value_category IS 'Storage of a categorical parameter value.';


--
-- TOC entry 5709 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.fk_unit_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.fk_unit_id IS 'Reference to the unit of this value in the unit table';


--
-- TOC entry 5710 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.value_boolean; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.value_boolean IS 'Storage of a boolean parameter value.';


--
-- TOC entry 5711 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.value_count; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.value_count IS 'Storage of a count parameter value.';


--
-- TOC entry 5712 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.value_quantity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.value_quantity IS 'Storage of a quantity parameter value.';


--
-- TOC entry 5713 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.value_text; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.value_text IS 'Storage of a textual parameter value.';


--
-- TOC entry 5714 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.value_xml; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.value_xml IS 'Storage of a XML encoded parameter value.';


--
-- TOC entry 5715 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.value_json; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.value_json IS 'Storage of a JSON encoded parameter value.';


--
-- TOC entry 5716 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.value_temporal_from; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.value_temporal_from IS 'Storage of a temporal from parameter value.';


--
-- TOC entry 5717 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN platform_parameter.value_temporal_to; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.platform_parameter.value_temporal_to IS 'Storage of a temporal to parameter value.';


--
-- TOC entry 297 (class 1259 OID 37083)
-- Name: platform_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.platform_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.platform_seq OWNER TO postgres;

--
-- TOC entry 343 (class 1259 OID 37341)
-- Name: procedure; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.procedure (
    procedure_id bigint NOT NULL,
    identifier character varying(255) NOT NULL,
    sta_identifier character varying(255) NOT NULL,
    fk_identifier_codespace_id bigint,
    name character varying(255),
    fk_name_codespace_id bigint,
    description text,
    description_file text,
    is_reference smallint DEFAULT 0 NOT NULL,
    fk_type_of_procedure_id bigint,
    is_aggregation smallint DEFAULT 1 NOT NULL,
    fk_format_id bigint NOT NULL,
    CONSTRAINT procedure_is_aggregation_check CHECK ((is_aggregation = ANY (ARRAY[1, 0]))),
    CONSTRAINT procedure_is_reference_check CHECK ((is_reference = ANY (ARRAY[1, 0])))
);


ALTER TABLE public.procedure OWNER TO postgres;

--
-- TOC entry 344 (class 1259 OID 37352)
-- Name: procedure_hierarchy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.procedure_hierarchy (
    fk_child_procedure_id bigint NOT NULL,
    fk_parent_procedure_id bigint NOT NULL
);


ALTER TABLE public.procedure_hierarchy OWNER TO postgres;

--
-- TOC entry 345 (class 1259 OID 37357)
-- Name: procedure_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.procedure_history (
    procedure_history_id bigint NOT NULL,
    fk_procedure_id bigint NOT NULL,
    fk_format_id bigint NOT NULL,
    valid_from timestamp without time zone NOT NULL,
    valid_to timestamp without time zone,
    xml text NOT NULL
);


ALTER TABLE public.procedure_history OWNER TO postgres;

--
-- TOC entry 5718 (class 0 OID 0)
-- Dependencies: 345
-- Name: TABLE procedure_history; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.procedure_history IS 'Storage of historical procedure descriptions as XML encoded text with period of validity.';


--
-- TOC entry 5719 (class 0 OID 0)
-- Dependencies: 345
-- Name: COLUMN procedure_history.procedure_history_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_history.procedure_history_id IS 'PK column of the table';


--
-- TOC entry 5720 (class 0 OID 0)
-- Dependencies: 345
-- Name: COLUMN procedure_history.fk_procedure_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_history.fk_procedure_id IS 'Reference to the procedure this entry belongs to.';


--
-- TOC entry 5721 (class 0 OID 0)
-- Dependencies: 345
-- Name: COLUMN procedure_history.fk_format_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_history.fk_format_id IS 'Reference to the format of the procedure description, e.g. SensorML 2.0';


--
-- TOC entry 5722 (class 0 OID 0)
-- Dependencies: 345
-- Name: COLUMN procedure_history.valid_from; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_history.valid_from IS 'The timestamp from which this procedure description is valid.';


--
-- TOC entry 5723 (class 0 OID 0)
-- Dependencies: 345
-- Name: COLUMN procedure_history.valid_to; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_history.valid_to IS 'The timestamp until this procedure description is valid. If null, this procedure description is currently valid';


--
-- TOC entry 5724 (class 0 OID 0)
-- Dependencies: 345
-- Name: COLUMN procedure_history.xml; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_history.xml IS 'XML representation of this procedure description';


--
-- TOC entry 298 (class 1259 OID 37084)
-- Name: procedure_history_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.procedure_history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.procedure_history_seq OWNER TO postgres;

--
-- TOC entry 346 (class 1259 OID 37364)
-- Name: procedure_i18n; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.procedure_i18n (
    procedure_i18n_id bigint NOT NULL,
    fk_procedure_id bigint NOT NULL,
    locale character varying(255) NOT NULL,
    name character varying(255),
    description text,
    short_name character varying(255),
    long_name character varying(255)
);


ALTER TABLE public.procedure_i18n OWNER TO postgres;

--
-- TOC entry 299 (class 1259 OID 37085)
-- Name: procedure_i18n_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.procedure_i18n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.procedure_i18n_seq OWNER TO postgres;

--
-- TOC entry 347 (class 1259 OID 37371)
-- Name: procedure_parameter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.procedure_parameter (
    parameter_id bigint NOT NULL,
    type character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    last_update timestamp without time zone,
    domain character varying(255),
    fk_procedure_id bigint NOT NULL,
    fk_parent_parameter_id bigint,
    value_boolean smallint,
    value_category character varying(255),
    fk_unit_id bigint,
    value_count integer,
    value_quantity numeric(19,2),
    value_text character varying(255),
    value_xml text,
    value_json text,
    value_temporal_from timestamp without time zone,
    value_temporal_to timestamp without time zone,
    CONSTRAINT procedure_parameter_type_check CHECK (((type)::text = ANY ((ARRAY['bool'::character varying, 'category'::character varying, 'count'::character varying, 'quantity'::character varying, 'text'::character varying, 'xml'::character varying, 'json'::character varying, 'complex'::character varying, 'temporal'::character varying])::text[])))
);


ALTER TABLE public.procedure_parameter OWNER TO postgres;

--
-- TOC entry 5725 (class 0 OID 0)
-- Dependencies: 347
-- Name: TABLE procedure_parameter; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.procedure_parameter IS 'Storage for additional information for procedures';


--
-- TOC entry 5726 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.parameter_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.parameter_id IS 'PK column of the table';


--
-- TOC entry 5727 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.type IS 'Indicator used by Hibernate to map value specific entities.';


--
-- TOC entry 5728 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.name IS 'The name of the parameter';


--
-- TOC entry 5729 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.description IS 'A short description of the parameter';


--
-- TOC entry 5730 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.last_update; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.last_update IS 'Timestamp that provides the time of the last modification of this entry';


--
-- TOC entry 5731 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.domain; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.domain IS 'The domain this parameter belongs to.';


--
-- TOC entry 5732 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.fk_procedure_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.fk_procedure_id IS 'Reference to the Procedure this Parameter describes.';


--
-- TOC entry 5733 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.fk_parent_parameter_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.fk_parent_parameter_id IS 'Reference to the Procedure this Parameter describes.';


--
-- TOC entry 5734 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.value_boolean; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.value_boolean IS 'Storage of a boolean parameter value.';


--
-- TOC entry 5735 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.value_category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.value_category IS 'Storage of a categorical parameter value.';


--
-- TOC entry 5736 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.fk_unit_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.fk_unit_id IS 'Reference to the unit of this value in the unit table';


--
-- TOC entry 5737 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.value_count; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.value_count IS 'Storage of a count parameter value.';


--
-- TOC entry 5738 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.value_quantity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.value_quantity IS 'Storage of a quantity parameter value.';


--
-- TOC entry 5739 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.value_text; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.value_text IS 'Storage of a textual parameter value.';


--
-- TOC entry 5740 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.value_xml; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.value_xml IS 'Storage of a XML encoded parameter value.';


--
-- TOC entry 5741 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.value_json; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.value_json IS 'Storage of a JSON encoded parameter value.';


--
-- TOC entry 5742 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.value_temporal_from; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.value_temporal_from IS 'Storage of a temporal from parameter value.';


--
-- TOC entry 5743 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN procedure_parameter.value_temporal_to; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.procedure_parameter.value_temporal_to IS 'Storage of a temporal to parameter value.';


--
-- TOC entry 300 (class 1259 OID 37086)
-- Name: procedure_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.procedure_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.procedure_seq OWNER TO postgres;

--
-- TOC entry 348 (class 1259 OID 37379)
-- Name: related_dataset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.related_dataset (
    fk_dataset_id bigint NOT NULL,
    fk_related_dataset_id bigint NOT NULL,
    role character varying(255),
    url character varying(255)
);


ALTER TABLE public.related_dataset OWNER TO postgres;

--
-- TOC entry 5744 (class 0 OID 0)
-- Dependencies: 348
-- Name: TABLE related_dataset; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.related_dataset IS 'Store the relation of two datasets, e.g. one dataset depends on other datasets to provide context';


--
-- TOC entry 5745 (class 0 OID 0)
-- Dependencies: 348
-- Name: COLUMN related_dataset.fk_dataset_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.related_dataset.fk_dataset_id IS 'The reference to the dataset that has a related dataset';


--
-- TOC entry 5746 (class 0 OID 0)
-- Dependencies: 348
-- Name: COLUMN related_dataset.fk_related_dataset_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.related_dataset.fk_related_dataset_id IS 'The reference to the related dataset';


--
-- TOC entry 5747 (class 0 OID 0)
-- Dependencies: 348
-- Name: COLUMN related_dataset.role; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.related_dataset.role IS 'Definition of the role of the relation';


--
-- TOC entry 5748 (class 0 OID 0)
-- Dependencies: 348
-- Name: COLUMN related_dataset.url; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.related_dataset.url IS 'URL that point to external information';


--
-- TOC entry 349 (class 1259 OID 37386)
-- Name: related_feature; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.related_feature (
    related_feature_id bigint NOT NULL,
    fk_feature_id bigint NOT NULL,
    role character varying(255) NOT NULL
);


ALTER TABLE public.related_feature OWNER TO postgres;

--
-- TOC entry 5749 (class 0 OID 0)
-- Dependencies: 349
-- Name: TABLE related_feature; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.related_feature IS 'Storage of relations between offerings and features. This table is used by the SOS to fulfill the standard.';


--
-- TOC entry 5750 (class 0 OID 0)
-- Dependencies: 349
-- Name: COLUMN related_feature.related_feature_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.related_feature.related_feature_id IS 'PK column of the table';


--
-- TOC entry 5751 (class 0 OID 0)
-- Dependencies: 349
-- Name: COLUMN related_feature.fk_feature_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.related_feature.fk_feature_id IS 'Reference to the feature that is related to the offering.';


--
-- TOC entry 5752 (class 0 OID 0)
-- Dependencies: 349
-- Name: COLUMN related_feature.role; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.related_feature.role IS 'The role of the related feature.';


--
-- TOC entry 301 (class 1259 OID 37087)
-- Name: related_feature_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.related_feature_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.related_feature_seq OWNER TO postgres;

--
-- TOC entry 350 (class 1259 OID 37391)
-- Name: related_observation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.related_observation (
    fk_observation_id bigint NOT NULL,
    fk_related_observation_id bigint NOT NULL,
    role character varying(255),
    url character varying(255)
);


ALTER TABLE public.related_observation OWNER TO postgres;

--
-- TOC entry 5753 (class 0 OID 0)
-- Dependencies: 350
-- Name: TABLE related_observation; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.related_observation IS 'Store the relation of two observation, e.g. one observation depends on other observations to provide context';


--
-- TOC entry 5754 (class 0 OID 0)
-- Dependencies: 350
-- Name: COLUMN related_observation.fk_observation_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.related_observation.fk_observation_id IS 'The reference to the dataset that has a related data/observation';


--
-- TOC entry 5755 (class 0 OID 0)
-- Dependencies: 350
-- Name: COLUMN related_observation.fk_related_observation_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.related_observation.fk_related_observation_id IS 'The reference to the related data/observation';


--
-- TOC entry 5756 (class 0 OID 0)
-- Dependencies: 350
-- Name: COLUMN related_observation.role; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.related_observation.role IS 'Definition of the role of the relation';


--
-- TOC entry 5757 (class 0 OID 0)
-- Dependencies: 350
-- Name: COLUMN related_observation.url; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.related_observation.url IS 'URL that point to external information';


--
-- TOC entry 351 (class 1259 OID 37398)
-- Name: result_template; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.result_template (
    result_template_id bigint NOT NULL,
    fk_offering_id bigint NOT NULL,
    fk_phenomenon_id bigint NOT NULL,
    fk_procedure_id bigint,
    fk_feature_id bigint,
    fk_category_id bigint NOT NULL,
    identifier character varying(255) NOT NULL,
    structure text,
    encoding text,
    observation_structure text,
    observation_encoding text
);


ALTER TABLE public.result_template OWNER TO postgres;

--
-- TOC entry 5758 (class 0 OID 0)
-- Dependencies: 351
-- Name: TABLE result_template; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.result_template IS 'Storage of templates for the result handling operations';


--
-- TOC entry 5759 (class 0 OID 0)
-- Dependencies: 351
-- Name: COLUMN result_template.result_template_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.result_template.result_template_id IS 'PK column of the table';


--
-- TOC entry 5760 (class 0 OID 0)
-- Dependencies: 351
-- Name: COLUMN result_template.fk_offering_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.result_template.fk_offering_id IS 'The offering that is associated with the result template';


--
-- TOC entry 5761 (class 0 OID 0)
-- Dependencies: 351
-- Name: COLUMN result_template.fk_phenomenon_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.result_template.fk_phenomenon_id IS 'The phenomenon that is associated with the result template';


--
-- TOC entry 5762 (class 0 OID 0)
-- Dependencies: 351
-- Name: COLUMN result_template.fk_procedure_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.result_template.fk_procedure_id IS 'The procedure that is associated with the result template. Can be null if the feature is defined in the structure.';


--
-- TOC entry 5763 (class 0 OID 0)
-- Dependencies: 351
-- Name: COLUMN result_template.fk_feature_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.result_template.fk_feature_id IS 'The feature that is associated with the result template. Can be null if the feature is defined in the structure.';


--
-- TOC entry 5764 (class 0 OID 0)
-- Dependencies: 351
-- Name: COLUMN result_template.fk_category_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.result_template.fk_category_id IS 'The category that is associated with the result template';


--
-- TOC entry 5765 (class 0 OID 0)
-- Dependencies: 351
-- Name: COLUMN result_template.identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.result_template.identifier IS 'Unique identifier of the result template used for insertion operation';


--
-- TOC entry 5766 (class 0 OID 0)
-- Dependencies: 351
-- Name: COLUMN result_template.structure; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.result_template.structure IS 'The structure of the result template, should be a XML encoded swe:DataRecord';


--
-- TOC entry 5767 (class 0 OID 0)
-- Dependencies: 351
-- Name: COLUMN result_template.encoding; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.result_template.encoding IS 'The encding of the result template, should be a XML encoded swe:TextEncoding';


--
-- TOC entry 5768 (class 0 OID 0)
-- Dependencies: 351
-- Name: COLUMN result_template.observation_structure; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.result_template.observation_structure IS 'The structure of the result template used for observations, should be a XML encoded swe:DataRecord';


--
-- TOC entry 5769 (class 0 OID 0)
-- Dependencies: 351
-- Name: COLUMN result_template.observation_encoding; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.result_template.observation_encoding IS 'The encding of the result template used for observations, should be a XML encoded swe:TextEncoding';


--
-- TOC entry 302 (class 1259 OID 37088)
-- Name: result_template_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.result_template_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.result_template_seq OWNER TO postgres;

--
-- TOC entry 352 (class 1259 OID 37405)
-- Name: tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tag (
    tag_id bigint NOT NULL,
    identifier character varying(255),
    description text
);


ALTER TABLE public.tag OWNER TO postgres;

--
-- TOC entry 5770 (class 0 OID 0)
-- Dependencies: 352
-- Name: TABLE tag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.tag IS 'Storage of the tags which should be used to tag the data.';


--
-- TOC entry 5771 (class 0 OID 0)
-- Dependencies: 352
-- Name: COLUMN tag.tag_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tag.tag_id IS 'PK column of the table';


--
-- TOC entry 5772 (class 0 OID 0)
-- Dependencies: 352
-- Name: COLUMN tag.identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tag.identifier IS 'Unique identifier/name of the tag which can be used for filtering.';


--
-- TOC entry 5773 (class 0 OID 0)
-- Dependencies: 352
-- Name: COLUMN tag.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tag.description IS 'A short description of the tag';


--
-- TOC entry 353 (class 1259 OID 37412)
-- Name: tag_dataset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tag_dataset (
    fk_dataset_id bigint NOT NULL,
    fk_tag_id bigint NOT NULL
);


ALTER TABLE public.tag_dataset OWNER TO postgres;

--
-- TOC entry 5774 (class 0 OID 0)
-- Dependencies: 353
-- Name: TABLE tag_dataset; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.tag_dataset IS 'Storage of relations between dataset and related tags';


--
-- TOC entry 5775 (class 0 OID 0)
-- Dependencies: 353
-- Name: COLUMN tag_dataset.fk_dataset_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tag_dataset.fk_dataset_id IS 'The reference to the dataset in the dataset table';


--
-- TOC entry 5776 (class 0 OID 0)
-- Dependencies: 353
-- Name: COLUMN tag_dataset.fk_tag_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tag_dataset.fk_tag_id IS 'The reference to the tags in the tag dataset table';


--
-- TOC entry 354 (class 1259 OID 37417)
-- Name: tag_i18n; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tag_i18n (
    tag_i18n_id bigint NOT NULL,
    fk_tag_id bigint NOT NULL,
    locale character varying(255) NOT NULL,
    name character varying(255),
    description text
);


ALTER TABLE public.tag_i18n OWNER TO postgres;

--
-- TOC entry 5777 (class 0 OID 0)
-- Dependencies: 354
-- Name: TABLE tag_i18n; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.tag_i18n IS 'Storage for internationalizations of tags.';


--
-- TOC entry 5778 (class 0 OID 0)
-- Dependencies: 354
-- Name: COLUMN tag_i18n.tag_i18n_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tag_i18n.tag_i18n_id IS 'PK column of the table';


--
-- TOC entry 5779 (class 0 OID 0)
-- Dependencies: 354
-- Name: COLUMN tag_i18n.fk_tag_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tag_i18n.fk_tag_id IS 'Reference to the tag table this internationalization belongs to. ISO 639 Codes (http://www.loc.gov/standards/iso639-2/php/code_list.php)';


--
-- TOC entry 5780 (class 0 OID 0)
-- Dependencies: 354
-- Name: COLUMN tag_i18n.locale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tag_i18n.locale IS 'Locale/language specification for this entry';


--
-- TOC entry 5781 (class 0 OID 0)
-- Dependencies: 354
-- Name: COLUMN tag_i18n.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tag_i18n.name IS 'Locale/language specific name of the tag';


--
-- TOC entry 5782 (class 0 OID 0)
-- Dependencies: 354
-- Name: COLUMN tag_i18n.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tag_i18n.description IS 'Locale/language specific description of the tag';


--
-- TOC entry 303 (class 1259 OID 37089)
-- Name: tag_i18n_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tag_i18n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tag_i18n_seq OWNER TO postgres;

--
-- TOC entry 304 (class 1259 OID 37090)
-- Name: tag_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tag_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tag_seq OWNER TO postgres;

--
-- TOC entry 355 (class 1259 OID 37424)
-- Name: unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unit (
    unit_id bigint NOT NULL,
    symbol character varying(255) NOT NULL,
    name character varying(255),
    link character varying(255)
);


ALTER TABLE public.unit OWNER TO postgres;

--
-- TOC entry 5783 (class 0 OID 0)
-- Dependencies: 355
-- Name: TABLE unit; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.unit IS 'Storage of the units of measurement of the observation values. These may be °C or m as the unit for depth/height information.';


--
-- TOC entry 5784 (class 0 OID 0)
-- Dependencies: 355
-- Name: COLUMN unit.unit_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.unit.unit_id IS 'PK column of the table';


--
-- TOC entry 5785 (class 0 OID 0)
-- Dependencies: 355
-- Name: COLUMN unit.symbol; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.unit.symbol IS 'The symbol of the unit, e.g. °C or m.';


--
-- TOC entry 5786 (class 0 OID 0)
-- Dependencies: 355
-- Name: COLUMN unit.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.unit.name IS 'Human readable name of the unit, e.g degree celsius or meter';


--
-- TOC entry 5787 (class 0 OID 0)
-- Dependencies: 355
-- Name: COLUMN unit.link; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.unit.link IS 'Link/reference to an external description of the unit, e.g. to a vocabulary..';


--
-- TOC entry 356 (class 1259 OID 37431)
-- Name: unit_i18n; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unit_i18n (
    unit_i18n_id bigint NOT NULL,
    fk_unit_id bigint NOT NULL,
    locale character varying(255) NOT NULL,
    name character varying(255)
);


ALTER TABLE public.unit_i18n OWNER TO postgres;

--
-- TOC entry 5788 (class 0 OID 0)
-- Dependencies: 356
-- Name: TABLE unit_i18n; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.unit_i18n IS 'Storage for internationalizations of units.';


--
-- TOC entry 5789 (class 0 OID 0)
-- Dependencies: 356
-- Name: COLUMN unit_i18n.unit_i18n_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.unit_i18n.unit_i18n_id IS 'PK column of the table';


--
-- TOC entry 5790 (class 0 OID 0)
-- Dependencies: 356
-- Name: COLUMN unit_i18n.fk_unit_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.unit_i18n.fk_unit_id IS 'Reference to the unit table this internationalization belongs to.';


--
-- TOC entry 5791 (class 0 OID 0)
-- Dependencies: 356
-- Name: COLUMN unit_i18n.locale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.unit_i18n.locale IS 'Locale/language specification for this unit. ISO 639 Codes (http://www.loc.gov/standards/iso639-2/php/code_list.php)';


--
-- TOC entry 5792 (class 0 OID 0)
-- Dependencies: 356
-- Name: COLUMN unit_i18n.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.unit_i18n.name IS 'Locale/language specific name of the unit';


--
-- TOC entry 305 (class 1259 OID 37091)
-- Name: unit_i18n_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unit_i18n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unit_i18n_seq OWNER TO postgres;

--
-- TOC entry 306 (class 1259 OID 37092)
-- Name: unit_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unit_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unit_seq OWNER TO postgres;

--
-- TOC entry 357 (class 1259 OID 37438)
-- Name: value_blob; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.value_blob (
    fk_observation_id bigint NOT NULL,
    value_blob oid
);


ALTER TABLE public.value_blob OWNER TO postgres;

--
-- TOC entry 5793 (class 0 OID 0)
-- Dependencies: 357
-- Name: COLUMN value_blob.fk_observation_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.value_blob.fk_observation_id IS 'Reference to the data/observation in the observation table';


--
-- TOC entry 5794 (class 0 OID 0)
-- Dependencies: 357
-- Name: COLUMN value_blob.value_blob; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.value_blob.value_blob IS 'The blob value of an observation';


--
-- TOC entry 358 (class 1259 OID 37443)
-- Name: value_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.value_profile (
    value_profile_id bigint NOT NULL,
    orientation smallint,
    vertical_origin_name character varying(255),
    vertical_from_name character varying(255),
    vertical_to_name character varying(255),
    fk_vertical_unit_id bigint NOT NULL
);


ALTER TABLE public.value_profile OWNER TO postgres;

--
-- TOC entry 5795 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE value_profile; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.value_profile IS 'Storage of meta-information about a profile measurement. These are the orientation (height/depth) and name of the depth/height value as they should be named in the output and the unit of the depth/height value. A value_profile must be defined for each dataset containing profile data.';


--
-- TOC entry 5796 (class 0 OID 0)
-- Dependencies: 358
-- Name: COLUMN value_profile.value_profile_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.value_profile.value_profile_id IS 'PK column of the table';


--
-- TOC entry 5797 (class 0 OID 0)
-- Dependencies: 358
-- Name: COLUMN value_profile.orientation; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.value_profile.orientation IS 'The "orientation" of the vertical values as integer. 1 => above verticalOriginName and -1 => below verticalOriginName';


--
-- TOC entry 5798 (class 0 OID 0)
-- Dependencies: 358
-- Name: COLUMN value_profile.vertical_origin_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.value_profile.vertical_origin_name IS 'The vertical origin name of the vertical values, e.g. water surface';


--
-- TOC entry 5799 (class 0 OID 0)
-- Dependencies: 358
-- Name: COLUMN value_profile.vertical_from_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.value_profile.vertical_from_name IS 'The name of the vertical from values, e.g. from or depthFrom';


--
-- TOC entry 5800 (class 0 OID 0)
-- Dependencies: 358
-- Name: COLUMN value_profile.vertical_to_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.value_profile.vertical_to_name IS 'The name of the vertical from values, e.g. to or depthTo';


--
-- TOC entry 5801 (class 0 OID 0)
-- Dependencies: 358
-- Name: COLUMN value_profile.fk_vertical_unit_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.value_profile.fk_vertical_unit_id IS 'The unit of the vertical value, e.g. m';


--
-- TOC entry 359 (class 1259 OID 37450)
-- Name: value_profile_i18n; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.value_profile_i18n (
    value_profile_i18n_id bigint NOT NULL,
    fk_value_profile_id bigint NOT NULL,
    locale character varying(255) NOT NULL,
    vertical_origin_name character varying(255),
    vertical_from_name character varying(255),
    vertical_to_name character varying(255)
);


ALTER TABLE public.value_profile_i18n OWNER TO postgres;

--
-- TOC entry 5802 (class 0 OID 0)
-- Dependencies: 359
-- Name: COLUMN value_profile_i18n.value_profile_i18n_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.value_profile_i18n.value_profile_i18n_id IS 'PK column of the table';


--
-- TOC entry 5803 (class 0 OID 0)
-- Dependencies: 359
-- Name: COLUMN value_profile_i18n.fk_value_profile_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.value_profile_i18n.fk_value_profile_id IS 'Reference to the value_profile table this internationalization belongs to.';


--
-- TOC entry 5804 (class 0 OID 0)
-- Dependencies: 359
-- Name: COLUMN value_profile_i18n.locale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.value_profile_i18n.locale IS 'Locale/language specification for this entry. ISO 639 Codes (http://www.loc.gov/standards/iso639-2/php/code_list.php)';


--
-- TOC entry 5805 (class 0 OID 0)
-- Dependencies: 359
-- Name: COLUMN value_profile_i18n.vertical_origin_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.value_profile_i18n.vertical_origin_name IS 'Locale/language specific vertical origin name of the vertical metadata entity';


--
-- TOC entry 5806 (class 0 OID 0)
-- Dependencies: 359
-- Name: COLUMN value_profile_i18n.vertical_from_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.value_profile_i18n.vertical_from_name IS 'Locale/language specific verticalTo name of the vertical metadata entity';


--
-- TOC entry 5807 (class 0 OID 0)
-- Dependencies: 359
-- Name: COLUMN value_profile_i18n.vertical_to_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.value_profile_i18n.vertical_to_name IS 'Locale/language specific verticalTo name of the vertical metadata entity';


--
-- TOC entry 307 (class 1259 OID 37093)
-- Name: value_profile_i18n_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.value_profile_i18n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.value_profile_i18n_seq OWNER TO postgres;

--
-- TOC entry 308 (class 1259 OID 37094)
-- Name: value_profile_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.value_profile_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.value_profile_seq OWNER TO postgres;

--
-- TOC entry 4878 (class 2606 OID 37108)
-- Name: category_i18n category_i18n_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_i18n
    ADD CONSTRAINT category_i18n_pkey PRIMARY KEY (category_i18n_id);


--
-- TOC entry 4873 (class 2606 OID 37101)
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (category_id);


--
-- TOC entry 4881 (class 2606 OID 37113)
-- Name: codespace codespace_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codespace
    ADD CONSTRAINT codespace_pkey PRIMARY KEY (codespace_id);


--
-- TOC entry 4885 (class 2606 OID 37118)
-- Name: composite_phenomenon composite_phenomenon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composite_phenomenon
    ADD CONSTRAINT composite_phenomenon_pkey PRIMARY KEY (fk_parent_phenomenon_id, fk_child_phenomenon_id);


--
-- TOC entry 4920 (class 2606 OID 37150)
-- Name: dataset_i18n dataset_i18n_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset_i18n
    ADD CONSTRAINT dataset_i18n_pkey PRIMARY KEY (dataset_i18n_id);


--
-- TOC entry 4923 (class 2606 OID 37158)
-- Name: dataset_parameter dataset_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset_parameter
    ADD CONSTRAINT dataset_parameter_pkey PRIMARY KEY (parameter_id);


--
-- TOC entry 4888 (class 2606 OID 37143)
-- Name: dataset dataset_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT dataset_pkey PRIMARY KEY (dataset_id);


--
-- TOC entry 4929 (class 2606 OID 37163)
-- Name: dataset_reference dataset_reference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset_reference
    ADD CONSTRAINT dataset_reference_pkey PRIMARY KEY (fk_dataset_id_from, sort_order);


--
-- TOC entry 4945 (class 2606 OID 37175)
-- Name: feature_hierarchy feature_hierarchy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_hierarchy
    ADD CONSTRAINT feature_hierarchy_pkey PRIMARY KEY (fk_parent_feature_id, fk_child_feature_id);


--
-- TOC entry 4948 (class 2606 OID 37182)
-- Name: feature_i18n feature_i18n_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_i18n
    ADD CONSTRAINT feature_i18n_pkey PRIMARY KEY (feature_i18n_id);


--
-- TOC entry 4951 (class 2606 OID 37190)
-- Name: feature_parameter feature_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_parameter
    ADD CONSTRAINT feature_parameter_pkey PRIMARY KEY (parameter_id);


--
-- TOC entry 4932 (class 2606 OID 37170)
-- Name: feature feature_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature
    ADD CONSTRAINT feature_pkey PRIMARY KEY (feature_id);


--
-- TOC entry 4957 (class 2606 OID 37195)
-- Name: format format_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.format
    ADD CONSTRAINT format_pkey PRIMARY KEY (format_id);


--
-- TOC entry 4961 (class 2606 OID 37202)
-- Name: historical_location historical_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historical_location
    ADD CONSTRAINT historical_location_pkey PRIMARY KEY (historical_location_id);


--
-- TOC entry 4980 (class 2606 OID 37214)
-- Name: location_historical_location location_historical_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_historical_location
    ADD CONSTRAINT location_historical_location_pkey PRIMARY KEY (fk_location_id, fk_historical_location_id);


--
-- TOC entry 4983 (class 2606 OID 37221)
-- Name: location_i18n location_i18n_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_i18n
    ADD CONSTRAINT location_i18n_pkey PRIMARY KEY (location_i18n_id);


--
-- TOC entry 4989 (class 2606 OID 37229)
-- Name: location_parameter location_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_parameter
    ADD CONSTRAINT location_parameter_pkey PRIMARY KEY (parameter_id);


--
-- TOC entry 4973 (class 2606 OID 37209)
-- Name: location location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (location_id);


--
-- TOC entry 5010 (class 2606 OID 37249)
-- Name: observation_i18n observation_i18n_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation_i18n
    ADD CONSTRAINT observation_i18n_pkey PRIMARY KEY (observation_i18n_id);


--
-- TOC entry 5016 (class 2606 OID 37257)
-- Name: observation_parameter observation_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation_parameter
    ADD CONSTRAINT observation_parameter_pkey PRIMARY KEY (parameter_id);


--
-- TOC entry 5001 (class 2606 OID 37242)
-- Name: observation observation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation
    ADD CONSTRAINT observation_pkey PRIMARY KEY (observation_id);


--
-- TOC entry 5026 (class 2606 OID 37269)
-- Name: offering_feature_type offering_feature_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering_feature_type
    ADD CONSTRAINT offering_feature_type_pkey PRIMARY KEY (fk_offering_id, fk_format_id);


--
-- TOC entry 5029 (class 2606 OID 37274)
-- Name: offering_hierarchy offering_hierarchy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering_hierarchy
    ADD CONSTRAINT offering_hierarchy_pkey PRIMARY KEY (fk_parent_offering_id, fk_child_offering_id);


--
-- TOC entry 5032 (class 2606 OID 37281)
-- Name: offering_i18n offering_i18n_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering_i18n
    ADD CONSTRAINT offering_i18n_pkey PRIMARY KEY (offering_i18n_id);


--
-- TOC entry 5035 (class 2606 OID 37286)
-- Name: offering_observation_type offering_observation_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering_observation_type
    ADD CONSTRAINT offering_observation_type_pkey PRIMARY KEY (fk_offering_id, fk_format_id);


--
-- TOC entry 5021 (class 2606 OID 37264)
-- Name: offering offering_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering
    ADD CONSTRAINT offering_pkey PRIMARY KEY (offering_id);


--
-- TOC entry 5038 (class 2606 OID 37291)
-- Name: offering_related_feature offering_related_feature_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering_related_feature
    ADD CONSTRAINT offering_related_feature_pkey PRIMARY KEY (fk_offering_id, fk_related_feature_id);


--
-- TOC entry 5051 (class 2606 OID 37305)
-- Name: phenomenon_i18n phenomenon_i18n_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenomenon_i18n
    ADD CONSTRAINT phenomenon_i18n_pkey PRIMARY KEY (phenomenon_i18n_id);


--
-- TOC entry 5057 (class 2606 OID 37313)
-- Name: phenomenon_parameter phenomenon_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenomenon_parameter
    ADD CONSTRAINT phenomenon_parameter_pkey PRIMARY KEY (parameter_id);


--
-- TOC entry 5044 (class 2606 OID 37298)
-- Name: phenomenon phenomenon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenomenon
    ADD CONSTRAINT phenomenon_pkey PRIMARY KEY (phenomenon_id);


--
-- TOC entry 5070 (class 2606 OID 37327)
-- Name: platform_i18n platform_i18n_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform_i18n
    ADD CONSTRAINT platform_i18n_pkey PRIMARY KEY (platform_i18n_id);


--
-- TOC entry 5074 (class 2606 OID 37332)
-- Name: platform_location platform_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform_location
    ADD CONSTRAINT platform_location_pkey PRIMARY KEY (fk_platform_id, fk_location_id);


--
-- TOC entry 5080 (class 2606 OID 37340)
-- Name: platform_parameter platform_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform_parameter
    ADD CONSTRAINT platform_parameter_pkey PRIMARY KEY (parameter_id);


--
-- TOC entry 5063 (class 2606 OID 37320)
-- Name: platform platform_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform
    ADD CONSTRAINT platform_pkey PRIMARY KEY (platform_id);


--
-- TOC entry 5096 (class 2606 OID 37356)
-- Name: procedure_hierarchy procedure_hierarchy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_hierarchy
    ADD CONSTRAINT procedure_hierarchy_pkey PRIMARY KEY (fk_parent_procedure_id, fk_child_procedure_id);


--
-- TOC entry 5102 (class 2606 OID 37363)
-- Name: procedure_history procedure_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_history
    ADD CONSTRAINT procedure_history_pkey PRIMARY KEY (procedure_history_id);


--
-- TOC entry 5105 (class 2606 OID 37370)
-- Name: procedure_i18n procedure_i18n_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_i18n
    ADD CONSTRAINT procedure_i18n_pkey PRIMARY KEY (procedure_i18n_id);


--
-- TOC entry 5111 (class 2606 OID 37378)
-- Name: procedure_parameter procedure_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_parameter
    ADD CONSTRAINT procedure_parameter_pkey PRIMARY KEY (parameter_id);


--
-- TOC entry 5089 (class 2606 OID 37351)
-- Name: procedure procedure_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure
    ADD CONSTRAINT procedure_pkey PRIMARY KEY (procedure_id);


--
-- TOC entry 5114 (class 2606 OID 37385)
-- Name: related_dataset related_dataset_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.related_dataset
    ADD CONSTRAINT related_dataset_pkey PRIMARY KEY (fk_dataset_id, fk_related_dataset_id);


--
-- TOC entry 5117 (class 2606 OID 37390)
-- Name: related_feature related_feature_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.related_feature
    ADD CONSTRAINT related_feature_pkey PRIMARY KEY (related_feature_id);


--
-- TOC entry 5121 (class 2606 OID 37397)
-- Name: related_observation related_observation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.related_observation
    ADD CONSTRAINT related_observation_pkey PRIMARY KEY (fk_observation_id, fk_related_observation_id);


--
-- TOC entry 5129 (class 2606 OID 37404)
-- Name: result_template result_template_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.result_template
    ADD CONSTRAINT result_template_pkey PRIMARY KEY (result_template_id);


--
-- TOC entry 5135 (class 2606 OID 37416)
-- Name: tag_dataset tag_dataset_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag_dataset
    ADD CONSTRAINT tag_dataset_pkey PRIMARY KEY (fk_tag_id, fk_dataset_id);


--
-- TOC entry 5138 (class 2606 OID 37423)
-- Name: tag_i18n tag_i18n_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag_i18n
    ADD CONSTRAINT tag_i18n_pkey PRIMARY KEY (tag_i18n_id);


--
-- TOC entry 5131 (class 2606 OID 37411)
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (tag_id);


--
-- TOC entry 4876 (class 2606 OID 37459)
-- Name: category un_category_identifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT un_category_identifier UNIQUE (identifier);


--
-- TOC entry 4883 (class 2606 OID 37462)
-- Name: codespace un_codespace_codespace; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codespace
    ADD CONSTRAINT un_codespace_codespace UNIQUE (name);


--
-- TOC entry 4914 (class 2606 OID 37489)
-- Name: dataset un_dataset_identifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT un_dataset_identifier UNIQUE (identifier);


--
-- TOC entry 4916 (class 2606 OID 37493)
-- Name: dataset un_dataset_identity; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT un_dataset_identity UNIQUE (fk_procedure_id, fk_phenomenon_id, fk_offering_id, fk_category_id, fk_feature_id, fk_platform_id, fk_unit_id);


--
-- TOC entry 4918 (class 2606 OID 37491)
-- Name: dataset un_dataset_staidentifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT un_dataset_staidentifier UNIQUE (sta_identifier);


--
-- TOC entry 4939 (class 2606 OID 37506)
-- Name: feature un_feature_identifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature
    ADD CONSTRAINT un_feature_identifier UNIQUE (identifier);


--
-- TOC entry 4941 (class 2606 OID 37508)
-- Name: feature un_feature_staidentifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature
    ADD CONSTRAINT un_feature_staidentifier UNIQUE (sta_identifier);


--
-- TOC entry 4943 (class 2606 OID 37510)
-- Name: feature un_feature_url; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature
    ADD CONSTRAINT un_feature_url UNIQUE (url);


--
-- TOC entry 4959 (class 2606 OID 37518)
-- Name: format un_format_definition; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.format
    ADD CONSTRAINT un_format_definition UNIQUE (definition);


--
-- TOC entry 4966 (class 2606 OID 37523)
-- Name: historical_location un_historicallocation_identifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historical_location
    ADD CONSTRAINT un_historicallocation_identifier UNIQUE (identifier);


--
-- TOC entry 4968 (class 2606 OID 37525)
-- Name: historical_location un_historicallocation_staidentifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historical_location
    ADD CONSTRAINT un_historicallocation_staidentifier UNIQUE (sta_identifier);


--
-- TOC entry 4975 (class 2606 OID 37530)
-- Name: location un_location_identifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT un_location_identifier UNIQUE (identifier);


--
-- TOC entry 4977 (class 2606 OID 37532)
-- Name: location un_location_staidentifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT un_location_staidentifier UNIQUE (sta_identifier);


--
-- TOC entry 5003 (class 2606 OID 37552)
-- Name: observation un_observation_identifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation
    ADD CONSTRAINT un_observation_identifier UNIQUE (identifier);


--
-- TOC entry 5005 (class 2606 OID 37550)
-- Name: observation un_observation_identity; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation
    ADD CONSTRAINT un_observation_identity UNIQUE (value_type, fk_dataset_id, sampling_time_start, sampling_time_end, result_time, vertical_from, vertical_to);


--
-- TOC entry 5007 (class 2606 OID 37554)
-- Name: observation un_observation_staidentifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation
    ADD CONSTRAINT un_observation_staidentifier UNIQUE (sta_identifier);


--
-- TOC entry 5023 (class 2606 OID 37564)
-- Name: offering un_offering_identifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering
    ADD CONSTRAINT un_offering_identifier UNIQUE (identifier);


--
-- TOC entry 5046 (class 2606 OID 37575)
-- Name: phenomenon un_phenomenon_identifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenomenon
    ADD CONSTRAINT un_phenomenon_identifier UNIQUE (identifier);


--
-- TOC entry 5048 (class 2606 OID 37577)
-- Name: phenomenon un_phenomenon_staidentifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenomenon
    ADD CONSTRAINT un_phenomenon_staidentifier UNIQUE (sta_identifier);


--
-- TOC entry 5065 (class 2606 OID 37588)
-- Name: platform un_platform_identifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform
    ADD CONSTRAINT un_platform_identifier UNIQUE (identifier);


--
-- TOC entry 5067 (class 2606 OID 37590)
-- Name: platform un_platform_staidentifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform
    ADD CONSTRAINT un_platform_staidentifier UNIQUE (sta_identifier);


--
-- TOC entry 5091 (class 2606 OID 37606)
-- Name: procedure un_procedure_identifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure
    ADD CONSTRAINT un_procedure_identifier UNIQUE (identifier);


--
-- TOC entry 5093 (class 2606 OID 37608)
-- Name: procedure un_procedure_staidentifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure
    ADD CONSTRAINT un_procedure_staidentifier UNIQUE (sta_identifier);


--
-- TOC entry 5140 (class 2606 OID 37633)
-- Name: unit un_unit_symbol; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit
    ADD CONSTRAINT un_unit_symbol UNIQUE (symbol);


--
-- TOC entry 5145 (class 2606 OID 37437)
-- Name: unit_i18n unit_i18n_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_i18n
    ADD CONSTRAINT unit_i18n_pkey PRIMARY KEY (unit_i18n_id);


--
-- TOC entry 5142 (class 2606 OID 37430)
-- Name: unit unit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit
    ADD CONSTRAINT unit_pkey PRIMARY KEY (unit_id);


--
-- TOC entry 5147 (class 2606 OID 37442)
-- Name: value_blob value_blob_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.value_blob
    ADD CONSTRAINT value_blob_pkey PRIMARY KEY (fk_observation_id);


--
-- TOC entry 5153 (class 2606 OID 37456)
-- Name: value_profile_i18n value_profile_i18n_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.value_profile_i18n
    ADD CONSTRAINT value_profile_i18n_pkey PRIMARY KEY (value_profile_i18n_id);


--
-- TOC entry 5150 (class 2606 OID 37449)
-- Name: value_profile value_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.value_profile
    ADD CONSTRAINT value_profile_pkey PRIMARY KEY (value_profile_id);


--
-- TOC entry 4879 (class 1259 OID 37460)
-- Name: idx_category_i18n_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_category_i18n_category ON public.category_i18n USING btree (fk_category_id);


--
-- TOC entry 4874 (class 1259 OID 37457)
-- Name: idx_category_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_category_identifier ON public.category USING btree (identifier);


--
-- TOC entry 4889 (class 1259 OID 37474)
-- Name: idx_dataset_aggregation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_aggregation ON public.dataset USING btree (fk_aggregation_id);


--
-- TOC entry 4890 (class 1259 OID 37469)
-- Name: idx_dataset_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_category ON public.dataset USING btree (fk_category_id);


--
-- TOC entry 4891 (class 1259 OID 37477)
-- Name: idx_dataset_dataset_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_dataset_type ON public.dataset USING btree (dataset_type);


--
-- TOC entry 4892 (class 1259 OID 37470)
-- Name: idx_dataset_feature; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_feature ON public.dataset USING btree (fk_feature_id);


--
-- TOC entry 4893 (class 1259 OID 37475)
-- Name: idx_dataset_first_observation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_first_observation ON public.dataset USING btree (fk_first_observation_id);


--
-- TOC entry 4921 (class 1259 OID 37494)
-- Name: idx_dataset_i18n_dataset; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_i18n_dataset ON public.dataset_i18n USING btree (fk_dataset_id);


--
-- TOC entry 4894 (class 1259 OID 37464)
-- Name: idx_dataset_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_identifier ON public.dataset USING btree (identifier);


--
-- TOC entry 4895 (class 1259 OID 37485)
-- Name: idx_dataset_identifier_codespace; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_identifier_codespace ON public.dataset USING btree (fk_identifier_codespace_id);


--
-- TOC entry 4896 (class 1259 OID 37479)
-- Name: idx_dataset_is_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_is_deleted ON public.dataset USING btree (is_deleted);


--
-- TOC entry 4897 (class 1259 OID 37480)
-- Name: idx_dataset_is_disabled; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_is_disabled ON public.dataset USING btree (is_disabled);


--
-- TOC entry 4898 (class 1259 OID 37484)
-- Name: idx_dataset_is_hidden; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_is_hidden ON public.dataset USING btree (is_hidden);


--
-- TOC entry 4899 (class 1259 OID 37483)
-- Name: idx_dataset_is_insitu; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_is_insitu ON public.dataset USING btree (is_insitu);


--
-- TOC entry 4900 (class 1259 OID 37482)
-- Name: idx_dataset_is_mobile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_is_mobile ON public.dataset USING btree (is_mobile);


--
-- TOC entry 4901 (class 1259 OID 37481)
-- Name: idx_dataset_is_published; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_is_published ON public.dataset USING btree (is_published);


--
-- TOC entry 4902 (class 1259 OID 37476)
-- Name: idx_dataset_last_observation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_last_observation ON public.dataset USING btree (fk_last_observation_id);


--
-- TOC entry 4903 (class 1259 OID 37486)
-- Name: idx_dataset_name_codespace; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_name_codespace ON public.dataset USING btree (fk_name_codespace_id);


--
-- TOC entry 4904 (class 1259 OID 37473)
-- Name: idx_dataset_observation_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_observation_type ON public.dataset USING btree (fk_format_id, observation_type);


--
-- TOC entry 4905 (class 1259 OID 37468)
-- Name: idx_dataset_offering; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_offering ON public.dataset USING btree (fk_offering_id);


--
-- TOC entry 4924 (class 1259 OID 37495)
-- Name: idx_dataset_param_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_param_name ON public.dataset_parameter USING btree (name);


--
-- TOC entry 4925 (class 1259 OID 37496)
-- Name: idx_dataset_parameter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_parameter ON public.dataset_parameter USING btree (fk_dataset_id);


--
-- TOC entry 4926 (class 1259 OID 37498)
-- Name: idx_dataset_parameter_unit; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_parameter_unit ON public.dataset_parameter USING btree (fk_unit_id);


--
-- TOC entry 4927 (class 1259 OID 37497)
-- Name: idx_dataset_parent_parameter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_parent_parameter ON public.dataset_parameter USING btree (fk_parent_parameter_id);


--
-- TOC entry 4906 (class 1259 OID 37467)
-- Name: idx_dataset_phenomenon; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_phenomenon ON public.dataset USING btree (fk_phenomenon_id);


--
-- TOC entry 4907 (class 1259 OID 37471)
-- Name: idx_dataset_platform; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_platform ON public.dataset USING btree (fk_platform_id);


--
-- TOC entry 4908 (class 1259 OID 37466)
-- Name: idx_dataset_procedure; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_procedure ON public.dataset USING btree (fk_procedure_id);


--
-- TOC entry 4930 (class 1259 OID 37499)
-- Name: idx_dataset_reference_to; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_reference_to ON public.dataset_reference USING btree (fk_dataset_id_to);


--
-- TOC entry 4909 (class 1259 OID 37465)
-- Name: idx_dataset_staidentifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_staidentifier ON public.dataset USING btree (sta_identifier);


--
-- TOC entry 4910 (class 1259 OID 37472)
-- Name: idx_dataset_unit; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_unit ON public.dataset USING btree (fk_unit_id);


--
-- TOC entry 4911 (class 1259 OID 37487)
-- Name: idx_dataset_value_profile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_value_profile ON public.dataset USING btree (fk_value_profile_id);


--
-- TOC entry 4912 (class 1259 OID 37478)
-- Name: idx_dataset_value_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_value_type ON public.dataset USING btree (value_type);


--
-- TOC entry 5097 (class 1259 OID 37613)
-- Name: idx_end_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_end_time ON public.procedure_history USING btree (valid_to);


--
-- TOC entry 4946 (class 1259 OID 37511)
-- Name: idx_feature_child; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feature_child ON public.feature_hierarchy USING btree (fk_child_feature_id);


--
-- TOC entry 4933 (class 1259 OID 37500)
-- Name: idx_feature_format; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feature_format ON public.feature USING btree (fk_format_id);


--
-- TOC entry 4949 (class 1259 OID 37512)
-- Name: idx_feature_i18n_feature; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feature_i18n_feature ON public.feature_i18n USING btree (fk_feature_id);


--
-- TOC entry 4934 (class 1259 OID 37501)
-- Name: idx_feature_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feature_identifier ON public.feature USING btree (identifier);


--
-- TOC entry 4935 (class 1259 OID 37503)
-- Name: idx_feature_identifier_codespace; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feature_identifier_codespace ON public.feature USING btree (fk_identifier_codespace_id);


--
-- TOC entry 4936 (class 1259 OID 37504)
-- Name: idx_feature_name_codespace; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feature_name_codespace ON public.feature USING btree (fk_name_codespace_id);


--
-- TOC entry 4952 (class 1259 OID 37513)
-- Name: idx_feature_param_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feature_param_name ON public.feature_parameter USING btree (name);


--
-- TOC entry 4953 (class 1259 OID 37514)
-- Name: idx_feature_parameter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feature_parameter ON public.feature_parameter USING btree (fk_feature_id);


--
-- TOC entry 4954 (class 1259 OID 37516)
-- Name: idx_feature_parameter_unit; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feature_parameter_unit ON public.feature_parameter USING btree (fk_unit_id);


--
-- TOC entry 4955 (class 1259 OID 37515)
-- Name: idx_feature_parent_parameter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feature_parent_parameter ON public.feature_parameter USING btree (fk_parent_parameter_id);


--
-- TOC entry 4937 (class 1259 OID 37502)
-- Name: idx_feature_staidentifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_feature_staidentifier ON public.feature USING btree (sta_identifier);


--
-- TOC entry 4962 (class 1259 OID 37521)
-- Name: idx_historical_location_platform; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_historical_location_platform ON public.historical_location USING btree (fk_platform_id);


--
-- TOC entry 4963 (class 1259 OID 37519)
-- Name: idx_historicallocation_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_historicallocation_identifier ON public.historical_location USING btree (identifier);


--
-- TOC entry 4964 (class 1259 OID 37520)
-- Name: idx_historicallocation_staidentifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_historicallocation_staidentifier ON public.historical_location USING btree (sta_identifier);


--
-- TOC entry 4969 (class 1259 OID 37528)
-- Name: idx_location_format; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_location_format ON public.location USING btree (fk_format_id);


--
-- TOC entry 4978 (class 1259 OID 37533)
-- Name: idx_location_historical_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_location_historical_location ON public.location_historical_location USING btree (fk_historical_location_id);


--
-- TOC entry 4981 (class 1259 OID 37534)
-- Name: idx_location_i18n_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_location_i18n_location ON public.location_i18n USING btree (fk_location_id);


--
-- TOC entry 4970 (class 1259 OID 37526)
-- Name: idx_location_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_location_identifier ON public.location USING btree (identifier);


--
-- TOC entry 4984 (class 1259 OID 37535)
-- Name: idx_location_param_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_location_param_name ON public.location_parameter USING btree (name);


--
-- TOC entry 4985 (class 1259 OID 37536)
-- Name: idx_location_parameter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_location_parameter ON public.location_parameter USING btree (fk_location_id);


--
-- TOC entry 4986 (class 1259 OID 37538)
-- Name: idx_location_parameter_unit; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_location_parameter_unit ON public.location_parameter USING btree (fk_unit_id);


--
-- TOC entry 4987 (class 1259 OID 37537)
-- Name: idx_location_parent_parameter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_location_parent_parameter ON public.location_parameter USING btree (fk_parent_parameter_id);


--
-- TOC entry 5071 (class 1259 OID 37593)
-- Name: idx_location_platform; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_location_platform ON public.platform_location USING btree (fk_location_id);


--
-- TOC entry 4971 (class 1259 OID 37527)
-- Name: idx_location_staidentifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_location_staidentifier ON public.location USING btree (sta_identifier);


--
-- TOC entry 4990 (class 1259 OID 37539)
-- Name: idx_observation_dataset; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_observation_dataset ON public.observation USING btree (fk_dataset_id);


--
-- TOC entry 5008 (class 1259 OID 37555)
-- Name: idx_observation_i18n_observation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_observation_i18n_observation ON public.observation_i18n USING btree (fk_observation_id);


--
-- TOC entry 4991 (class 1259 OID 37544)
-- Name: idx_observation_identifier_codespace; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_observation_identifier_codespace ON public.observation USING btree (fk_identifier_codespace_id);


--
-- TOC entry 4992 (class 1259 OID 37546)
-- Name: idx_observation_is_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_observation_is_deleted ON public.observation USING btree (is_deleted);


--
-- TOC entry 4993 (class 1259 OID 37545)
-- Name: idx_observation_name_codespace; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_observation_name_codespace ON public.observation USING btree (fk_name_codespace_id);


--
-- TOC entry 5011 (class 1259 OID 37556)
-- Name: idx_observation_param_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_observation_param_name ON public.observation_parameter USING btree (name);


--
-- TOC entry 5012 (class 1259 OID 37557)
-- Name: idx_observation_parameter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_observation_parameter ON public.observation_parameter USING btree (fk_observation_id);


--
-- TOC entry 5013 (class 1259 OID 37559)
-- Name: idx_observation_parameter_unit; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_observation_parameter_unit ON public.observation_parameter USING btree (fk_unit_id);


--
-- TOC entry 4994 (class 1259 OID 37547)
-- Name: idx_observation_parent; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_observation_parent ON public.observation USING btree (fk_parent_observation_id);


--
-- TOC entry 5014 (class 1259 OID 37558)
-- Name: idx_observation_parent_parameter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_observation_parent_parameter ON public.observation_parameter USING btree (fk_parent_parameter_id);


--
-- TOC entry 4995 (class 1259 OID 37548)
-- Name: idx_observation_result_template; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_observation_result_template ON public.observation USING btree (fk_result_template_id);


--
-- TOC entry 4996 (class 1259 OID 37543)
-- Name: idx_observation_staidentifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_observation_staidentifier ON public.observation USING btree (sta_identifier);


--
-- TOC entry 5027 (class 1259 OID 37566)
-- Name: idx_offering_child_offering; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_offering_child_offering ON public.offering_hierarchy USING btree (fk_child_offering_id);


--
-- TOC entry 5024 (class 1259 OID 37565)
-- Name: idx_offering_feature_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_offering_feature_type ON public.offering_feature_type USING btree (fk_format_id);


--
-- TOC entry 5030 (class 1259 OID 37567)
-- Name: idx_offering_i18n_offering; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_offering_i18n_offering ON public.offering_i18n USING btree (fk_offering_id);


--
-- TOC entry 5017 (class 1259 OID 37560)
-- Name: idx_offering_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_offering_identifier ON public.offering USING btree (identifier);


--
-- TOC entry 5018 (class 1259 OID 37561)
-- Name: idx_offering_identifier_codespace; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_offering_identifier_codespace ON public.offering USING btree (fk_identifier_codespace_id);


--
-- TOC entry 5019 (class 1259 OID 37562)
-- Name: idx_offering_name_codespace; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_offering_name_codespace ON public.offering USING btree (fk_name_codespace_id);


--
-- TOC entry 5033 (class 1259 OID 37568)
-- Name: idx_offering_observation_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_offering_observation_type ON public.offering_observation_type USING btree (fk_format_id);


--
-- TOC entry 5036 (class 1259 OID 37569)
-- Name: idx_offering_related_feature; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_offering_related_feature ON public.offering_related_feature USING btree (fk_related_feature_id);


--
-- TOC entry 4886 (class 1259 OID 37463)
-- Name: idx_phenomenon_child_phenomenon; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_phenomenon_child_phenomenon ON public.composite_phenomenon USING btree (fk_child_phenomenon_id);


--
-- TOC entry 5049 (class 1259 OID 37578)
-- Name: idx_phenomenon_i18n_phenomenon; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_phenomenon_i18n_phenomenon ON public.phenomenon_i18n USING btree (fk_phenomenon_id);


--
-- TOC entry 5039 (class 1259 OID 37570)
-- Name: idx_phenomenon_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_phenomenon_identifier ON public.phenomenon USING btree (identifier);


--
-- TOC entry 5040 (class 1259 OID 37572)
-- Name: idx_phenomenon_identifier_codespace; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_phenomenon_identifier_codespace ON public.phenomenon USING btree (fk_identifier_codespace_id);


--
-- TOC entry 5041 (class 1259 OID 37573)
-- Name: idx_phenomenon_name_codespace; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_phenomenon_name_codespace ON public.phenomenon USING btree (fk_name_codespace_id);


--
-- TOC entry 5052 (class 1259 OID 37579)
-- Name: idx_phenomenon_param_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_phenomenon_param_name ON public.phenomenon_parameter USING btree (name);


--
-- TOC entry 5053 (class 1259 OID 37580)
-- Name: idx_phenomenon_parameter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_phenomenon_parameter ON public.phenomenon_parameter USING btree (fk_phenomenon_id);


--
-- TOC entry 5054 (class 1259 OID 37582)
-- Name: idx_phenomenon_parameter_unit; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_phenomenon_parameter_unit ON public.phenomenon_parameter USING btree (fk_unit_id);


--
-- TOC entry 5055 (class 1259 OID 37581)
-- Name: idx_phenomenon_parent_parameter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_phenomenon_parent_parameter ON public.phenomenon_parameter USING btree (fk_parent_parameter_id);


--
-- TOC entry 5042 (class 1259 OID 37571)
-- Name: idx_phenomenon_staidentifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_phenomenon_staidentifier ON public.phenomenon USING btree (sta_identifier);


--
-- TOC entry 5068 (class 1259 OID 37591)
-- Name: idx_platform_i18n_platform; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_platform_i18n_platform ON public.platform_i18n USING btree (fk_platform_id);


--
-- TOC entry 5058 (class 1259 OID 37583)
-- Name: idx_platform_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_platform_identifier ON public.platform USING btree (identifier);


--
-- TOC entry 5059 (class 1259 OID 37585)
-- Name: idx_platform_identifier_codespace; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_platform_identifier_codespace ON public.platform USING btree (fk_identifier_codespace_id);


--
-- TOC entry 5072 (class 1259 OID 37592)
-- Name: idx_platform_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_platform_location ON public.platform_location USING btree (fk_platform_id);


--
-- TOC entry 5060 (class 1259 OID 37586)
-- Name: idx_platform_name_codespace; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_platform_name_codespace ON public.platform USING btree (fk_name_codespace_id);


--
-- TOC entry 5075 (class 1259 OID 37594)
-- Name: idx_platform_param_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_platform_param_name ON public.platform_parameter USING btree (name);


--
-- TOC entry 5076 (class 1259 OID 37595)
-- Name: idx_platform_parameter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_platform_parameter ON public.platform_parameter USING btree (fk_platform_id);


--
-- TOC entry 5077 (class 1259 OID 37597)
-- Name: idx_platform_parameter_unit; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_platform_parameter_unit ON public.platform_parameter USING btree (fk_unit_id);


--
-- TOC entry 5078 (class 1259 OID 37596)
-- Name: idx_platform_parent_parameter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_platform_parent_parameter ON public.platform_parameter USING btree (fk_parent_parameter_id);


--
-- TOC entry 5061 (class 1259 OID 37584)
-- Name: idx_platform_staidentifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_platform_staidentifier ON public.platform USING btree (sta_identifier);


--
-- TOC entry 5094 (class 1259 OID 37609)
-- Name: idx_procedure_child; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_procedure_child ON public.procedure_hierarchy USING btree (fk_child_procedure_id);


--
-- TOC entry 5081 (class 1259 OID 37604)
-- Name: idx_procedure_format; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_procedure_format ON public.procedure USING btree (fk_format_id);


--
-- TOC entry 5098 (class 1259 OID 37611)
-- Name: idx_procedure_history_format; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_procedure_history_format ON public.procedure_history USING btree (fk_format_id);


--
-- TOC entry 5099 (class 1259 OID 37610)
-- Name: idx_procedure_history_procedure; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_procedure_history_procedure ON public.procedure_history USING btree (fk_procedure_id);


--
-- TOC entry 5103 (class 1259 OID 37614)
-- Name: idx_procedure_i18n_procedure; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_procedure_i18n_procedure ON public.procedure_i18n USING btree (fk_procedure_id);


--
-- TOC entry 5082 (class 1259 OID 37598)
-- Name: idx_procedure_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_procedure_identifier ON public.procedure USING btree (identifier);


--
-- TOC entry 5083 (class 1259 OID 37600)
-- Name: idx_procedure_identifier_codespace; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_procedure_identifier_codespace ON public.procedure USING btree (fk_identifier_codespace_id);


--
-- TOC entry 5084 (class 1259 OID 37602)
-- Name: idx_procedure_is_reference; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_procedure_is_reference ON public.procedure USING btree (is_reference);


--
-- TOC entry 5085 (class 1259 OID 37601)
-- Name: idx_procedure_name_codespace; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_procedure_name_codespace ON public.procedure USING btree (fk_name_codespace_id);


--
-- TOC entry 5106 (class 1259 OID 37615)
-- Name: idx_procedure_param_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_procedure_param_name ON public.procedure_parameter USING btree (name);


--
-- TOC entry 5107 (class 1259 OID 37616)
-- Name: idx_procedure_parameter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_procedure_parameter ON public.procedure_parameter USING btree (fk_procedure_id);


--
-- TOC entry 5108 (class 1259 OID 37618)
-- Name: idx_procedure_parameter_unit; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_procedure_parameter_unit ON public.procedure_parameter USING btree (fk_unit_id);


--
-- TOC entry 5109 (class 1259 OID 37617)
-- Name: idx_procedure_parent_parameter; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_procedure_parent_parameter ON public.procedure_parameter USING btree (fk_parent_parameter_id);


--
-- TOC entry 5086 (class 1259 OID 37599)
-- Name: idx_procedure_staidentifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_procedure_staidentifier ON public.procedure USING btree (sta_identifier);


--
-- TOC entry 5087 (class 1259 OID 37603)
-- Name: idx_procedure_type_of; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_procedure_type_of ON public.procedure USING btree (fk_type_of_procedure_id);


--
-- TOC entry 5148 (class 1259 OID 37635)
-- Name: idx_profile_vertical_unit; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_profile_vertical_unit ON public.value_profile USING btree (fk_vertical_unit_id);


--
-- TOC entry 5112 (class 1259 OID 37619)
-- Name: idx_related_dataset_related_dataset; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_related_dataset_related_dataset ON public.related_dataset USING btree (fk_related_dataset_id);


--
-- TOC entry 5115 (class 1259 OID 37620)
-- Name: idx_related_feature_feature; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_related_feature_feature ON public.related_feature USING btree (fk_feature_id);


--
-- TOC entry 5118 (class 1259 OID 37622)
-- Name: idx_related_observation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_related_observation ON public.related_observation USING btree (fk_observation_id);


--
-- TOC entry 5119 (class 1259 OID 37621)
-- Name: idx_related_observation_related_observation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_related_observation_related_observation ON public.related_observation USING btree (fk_related_observation_id);


--
-- TOC entry 5122 (class 1259 OID 37627)
-- Name: idx_result_template_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_result_template_category ON public.result_template USING btree (fk_category_id);


--
-- TOC entry 5123 (class 1259 OID 37626)
-- Name: idx_result_template_feature; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_result_template_feature ON public.result_template USING btree (fk_feature_id);


--
-- TOC entry 5124 (class 1259 OID 37628)
-- Name: idx_result_template_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_result_template_identifier ON public.result_template USING btree (identifier);


--
-- TOC entry 5125 (class 1259 OID 37623)
-- Name: idx_result_template_offering; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_result_template_offering ON public.result_template USING btree (fk_offering_id);


--
-- TOC entry 5126 (class 1259 OID 37624)
-- Name: idx_result_template_phenomenon; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_result_template_phenomenon ON public.result_template USING btree (fk_phenomenon_id);


--
-- TOC entry 5127 (class 1259 OID 37625)
-- Name: idx_result_template_procedure; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_result_template_procedure ON public.result_template USING btree (fk_procedure_id);


--
-- TOC entry 4997 (class 1259 OID 37542)
-- Name: idx_result_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_result_time ON public.observation USING btree (result_time);


--
-- TOC entry 4998 (class 1259 OID 37541)
-- Name: idx_sampling_time_end; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sampling_time_end ON public.observation USING btree (sampling_time_end);


--
-- TOC entry 4999 (class 1259 OID 37540)
-- Name: idx_sampling_time_start; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sampling_time_start ON public.observation USING btree (sampling_time_start);


--
-- TOC entry 5100 (class 1259 OID 37612)
-- Name: idx_start_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_start_time ON public.procedure_history USING btree (valid_from);


--
-- TOC entry 5132 (class 1259 OID 37630)
-- Name: idx_tag_dataset_dataset; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tag_dataset_dataset ON public.tag_dataset USING btree (fk_dataset_id);


--
-- TOC entry 5133 (class 1259 OID 37629)
-- Name: idx_tag_dataset_fk_dataset_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tag_dataset_fk_dataset_id ON public.tag_dataset USING btree (fk_dataset_id);


--
-- TOC entry 5136 (class 1259 OID 37631)
-- Name: idx_tag_i18n_tag; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tag_i18n_tag ON public.tag_i18n USING btree (fk_tag_id);


--
-- TOC entry 5143 (class 1259 OID 37634)
-- Name: idx_unit_i18n_unit; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_unit_i18n_unit ON public.unit_i18n USING btree (fk_unit_id);


--
-- TOC entry 5151 (class 1259 OID 37636)
-- Name: idx_value_profile_i18n_value_profile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_value_profile_i18n_value_profile ON public.value_profile_i18n USING btree (fk_value_profile_id);


--
-- TOC entry 5165 (class 2606 OID 37692)
-- Name: dataset fk_aggregation_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT fk_aggregation_id FOREIGN KEY (fk_aggregation_id) REFERENCES public.dataset(dataset_id);


--
-- TOC entry 5254 (class 2606 OID 38137)
-- Name: value_blob fk_blob_value; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.value_blob
    ADD CONSTRAINT fk_blob_value FOREIGN KEY (fk_observation_id) REFERENCES public.observation(observation_id);


--
-- TOC entry 5154 (class 2606 OID 37637)
-- Name: category_i18n fk_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_i18n
    ADD CONSTRAINT fk_category FOREIGN KEY (fk_category_id) REFERENCES public.category(category_id);


--
-- TOC entry 5195 (class 2606 OID 37842)
-- Name: observation fk_data_identifier_codesp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation
    ADD CONSTRAINT fk_data_identifier_codesp FOREIGN KEY (fk_identifier_codespace_id) REFERENCES public.codespace(codespace_id);


--
-- TOC entry 5196 (class 2606 OID 37847)
-- Name: observation fk_data_name_codespace; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation
    ADD CONSTRAINT fk_data_name_codespace FOREIGN KEY (fk_name_codespace_id) REFERENCES public.codespace(codespace_id);


--
-- TOC entry 5194 (class 2606 OID 37837)
-- Name: observation fk_dataset; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation
    ADD CONSTRAINT fk_dataset FOREIGN KEY (fk_dataset_id) REFERENCES public.dataset(dataset_id);


--
-- TOC entry 5160 (class 2606 OID 37667)
-- Name: dataset fk_dataset_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT fk_dataset_category FOREIGN KEY (fk_category_id) REFERENCES public.category(category_id);


--
-- TOC entry 5161 (class 2606 OID 37672)
-- Name: dataset fk_dataset_feature; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT fk_dataset_feature FOREIGN KEY (fk_feature_id) REFERENCES public.feature(feature_id);


--
-- TOC entry 5166 (class 2606 OID 37697)
-- Name: dataset fk_dataset_first_obs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT fk_dataset_first_obs FOREIGN KEY (fk_first_observation_id) REFERENCES public.observation(observation_id);


--
-- TOC entry 5171 (class 2606 OID 37722)
-- Name: dataset_i18n fk_dataset_i18n; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset_i18n
    ADD CONSTRAINT fk_dataset_i18n FOREIGN KEY (fk_dataset_id) REFERENCES public.dataset(dataset_id);


--
-- TOC entry 5168 (class 2606 OID 37707)
-- Name: dataset fk_dataset_identifier_codesp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT fk_dataset_identifier_codesp FOREIGN KEY (fk_identifier_codespace_id) REFERENCES public.codespace(codespace_id);


--
-- TOC entry 5167 (class 2606 OID 37702)
-- Name: dataset fk_dataset_last_obs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT fk_dataset_last_obs FOREIGN KEY (fk_last_observation_id) REFERENCES public.observation(observation_id);


--
-- TOC entry 5169 (class 2606 OID 37712)
-- Name: dataset fk_dataset_name_codespace; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT fk_dataset_name_codespace FOREIGN KEY (fk_name_codespace_id) REFERENCES public.codespace(codespace_id);


--
-- TOC entry 5159 (class 2606 OID 37662)
-- Name: dataset fk_dataset_offering; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT fk_dataset_offering FOREIGN KEY (fk_offering_id) REFERENCES public.offering(offering_id);


--
-- TOC entry 5164 (class 2606 OID 37687)
-- Name: dataset fk_dataset_om_obs_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT fk_dataset_om_obs_type FOREIGN KEY (fk_format_id) REFERENCES public.format(format_id);


--
-- TOC entry 5172 (class 2606 OID 37737)
-- Name: dataset_parameter fk_dataset_param_unit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset_parameter
    ADD CONSTRAINT fk_dataset_param_unit FOREIGN KEY (fk_unit_id) REFERENCES public.unit(unit_id);


--
-- TOC entry 5158 (class 2606 OID 37657)
-- Name: dataset fk_dataset_phenomenon; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT fk_dataset_phenomenon FOREIGN KEY (fk_phenomenon_id) REFERENCES public.phenomenon(phenomenon_id);


--
-- TOC entry 5162 (class 2606 OID 37677)
-- Name: dataset fk_dataset_platform; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT fk_dataset_platform FOREIGN KEY (fk_platform_id) REFERENCES public.platform(platform_id);


--
-- TOC entry 5157 (class 2606 OID 37652)
-- Name: dataset fk_dataset_procedure; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT fk_dataset_procedure FOREIGN KEY (fk_procedure_id) REFERENCES public.procedure(procedure_id);


--
-- TOC entry 5175 (class 2606 OID 37747)
-- Name: dataset_reference fk_dataset_reference_from; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset_reference
    ADD CONSTRAINT fk_dataset_reference_from FOREIGN KEY (fk_dataset_id_from) REFERENCES public.dataset(dataset_id);


--
-- TOC entry 5176 (class 2606 OID 37742)
-- Name: dataset_reference fk_dataset_reference_to; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset_reference
    ADD CONSTRAINT fk_dataset_reference_to FOREIGN KEY (fk_dataset_id_to) REFERENCES public.dataset(dataset_id);


--
-- TOC entry 5250 (class 2606 OID 38122)
-- Name: tag_dataset fk_dataset_tag; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag_dataset
    ADD CONSTRAINT fk_dataset_tag FOREIGN KEY (fk_dataset_id) REFERENCES public.dataset(dataset_id);


--
-- TOC entry 5163 (class 2606 OID 37682)
-- Name: dataset fk_dataset_unit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT fk_dataset_unit FOREIGN KEY (fk_unit_id) REFERENCES public.unit(unit_id);


--
-- TOC entry 5182 (class 2606 OID 37777)
-- Name: feature_i18n fk_feature; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_i18n
    ADD CONSTRAINT fk_feature FOREIGN KEY (fk_feature_id) REFERENCES public.feature(feature_id);


--
-- TOC entry 5180 (class 2606 OID 37772)
-- Name: feature_hierarchy fk_feature_child; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_hierarchy
    ADD CONSTRAINT fk_feature_child FOREIGN KEY (fk_child_feature_id) REFERENCES public.feature(feature_id);


--
-- TOC entry 5177 (class 2606 OID 37752)
-- Name: feature fk_feature_format; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature
    ADD CONSTRAINT fk_feature_format FOREIGN KEY (fk_format_id) REFERENCES public.format(format_id);


--
-- TOC entry 5178 (class 2606 OID 37757)
-- Name: feature fk_feature_identifier_codesp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature
    ADD CONSTRAINT fk_feature_identifier_codesp FOREIGN KEY (fk_identifier_codespace_id) REFERENCES public.codespace(codespace_id);


--
-- TOC entry 5179 (class 2606 OID 37762)
-- Name: feature fk_feature_name_codespace; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature
    ADD CONSTRAINT fk_feature_name_codespace FOREIGN KEY (fk_name_codespace_id) REFERENCES public.codespace(codespace_id);


--
-- TOC entry 5183 (class 2606 OID 37792)
-- Name: feature_parameter fk_feature_param_unit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_parameter
    ADD CONSTRAINT fk_feature_param_unit FOREIGN KEY (fk_unit_id) REFERENCES public.unit(unit_id);


--
-- TOC entry 5181 (class 2606 OID 37767)
-- Name: feature_hierarchy fk_feature_parent; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_hierarchy
    ADD CONSTRAINT fk_feature_parent FOREIGN KEY (fk_parent_feature_id) REFERENCES public.feature(feature_id);


--
-- TOC entry 5205 (class 2606 OID 37892)
-- Name: offering_feature_type fk_feature_type_offering; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering_feature_type
    ADD CONSTRAINT fk_feature_type_offering FOREIGN KEY (fk_format_id) REFERENCES public.format(format_id);


--
-- TOC entry 5188 (class 2606 OID 37807)
-- Name: location_historical_location fk_historical_loc_location; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_historical_location
    ADD CONSTRAINT fk_historical_loc_location FOREIGN KEY (fk_historical_location_id) REFERENCES public.historical_location(historical_location_id);


--
-- TOC entry 5236 (class 2606 OID 38047)
-- Name: procedure_i18n fk_i18n_procedure; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_i18n
    ADD CONSTRAINT fk_i18n_procedure FOREIGN KEY (fk_procedure_id) REFERENCES public.procedure(procedure_id);


--
-- TOC entry 5256 (class 2606 OID 38147)
-- Name: value_profile_i18n fk_i18n_value_profile; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.value_profile_i18n
    ADD CONSTRAINT fk_i18n_value_profile FOREIGN KEY (fk_value_profile_id) REFERENCES public.value_profile(value_profile_id);


--
-- TOC entry 5190 (class 2606 OID 37817)
-- Name: location_i18n fk_location; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_i18n
    ADD CONSTRAINT fk_location FOREIGN KEY (fk_location_id) REFERENCES public.location(location_id);


--
-- TOC entry 5187 (class 2606 OID 37802)
-- Name: location fk_location_format; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT fk_location_format FOREIGN KEY (fk_format_id) REFERENCES public.format(format_id);


--
-- TOC entry 5189 (class 2606 OID 37812)
-- Name: location_historical_location fk_location_historical_loc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_historical_location
    ADD CONSTRAINT fk_location_historical_loc FOREIGN KEY (fk_location_id) REFERENCES public.location(location_id);


--
-- TOC entry 5191 (class 2606 OID 37832)
-- Name: location_parameter fk_location_param_unit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_parameter
    ADD CONSTRAINT fk_location_param_unit FOREIGN KEY (fk_unit_id) REFERENCES public.unit(unit_id);


--
-- TOC entry 5223 (class 2606 OID 37982)
-- Name: platform_location fk_location_platform; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform_location
    ADD CONSTRAINT fk_location_platform FOREIGN KEY (fk_location_id) REFERENCES public.location(location_id);


--
-- TOC entry 5199 (class 2606 OID 37862)
-- Name: observation_i18n fk_observation_i18n; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation_i18n
    ADD CONSTRAINT fk_observation_i18n FOREIGN KEY (fk_observation_id) REFERENCES public.observation(observation_id);


--
-- TOC entry 5200 (class 2606 OID 37877)
-- Name: observation_parameter fk_observation_param_unit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation_parameter
    ADD CONSTRAINT fk_observation_param_unit FOREIGN KEY (fk_unit_id) REFERENCES public.unit(unit_id);


--
-- TOC entry 5210 (class 2606 OID 37917)
-- Name: offering_observation_type fk_observation_type_offering; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering_observation_type
    ADD CONSTRAINT fk_observation_type_offering FOREIGN KEY (fk_format_id) REFERENCES public.format(format_id);


--
-- TOC entry 5209 (class 2606 OID 37912)
-- Name: offering_i18n fk_offering; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering_i18n
    ADD CONSTRAINT fk_offering FOREIGN KEY (fk_offering_id) REFERENCES public.offering(offering_id);


--
-- TOC entry 5207 (class 2606 OID 37907)
-- Name: offering_hierarchy fk_offering_child; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering_hierarchy
    ADD CONSTRAINT fk_offering_child FOREIGN KEY (fk_child_offering_id) REFERENCES public.offering(offering_id);


--
-- TOC entry 5206 (class 2606 OID 37897)
-- Name: offering_feature_type fk_offering_feature_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering_feature_type
    ADD CONSTRAINT fk_offering_feature_type FOREIGN KEY (fk_offering_id) REFERENCES public.offering(offering_id);


--
-- TOC entry 5203 (class 2606 OID 37882)
-- Name: offering fk_offering_identifier_codesp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering
    ADD CONSTRAINT fk_offering_identifier_codesp FOREIGN KEY (fk_identifier_codespace_id) REFERENCES public.codespace(codespace_id);


--
-- TOC entry 5204 (class 2606 OID 37887)
-- Name: offering fk_offering_name_codespace; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering
    ADD CONSTRAINT fk_offering_name_codespace FOREIGN KEY (fk_name_codespace_id) REFERENCES public.codespace(codespace_id);


--
-- TOC entry 5211 (class 2606 OID 37922)
-- Name: offering_observation_type fk_offering_observation_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering_observation_type
    ADD CONSTRAINT fk_offering_observation_type FOREIGN KEY (fk_offering_id) REFERENCES public.offering(offering_id);


--
-- TOC entry 5208 (class 2606 OID 37902)
-- Name: offering_hierarchy fk_offering_parent; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering_hierarchy
    ADD CONSTRAINT fk_offering_parent FOREIGN KEY (fk_parent_offering_id) REFERENCES public.offering(offering_id);


--
-- TOC entry 5212 (class 2606 OID 37927)
-- Name: offering_related_feature fk_offering_related_feature; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering_related_feature
    ADD CONSTRAINT fk_offering_related_feature FOREIGN KEY (fk_related_feature_id) REFERENCES public.related_feature(related_feature_id);


--
-- TOC entry 5173 (class 2606 OID 37727)
-- Name: dataset_parameter fk_param_dataset_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset_parameter
    ADD CONSTRAINT fk_param_dataset_id FOREIGN KEY (fk_dataset_id) REFERENCES public.dataset(dataset_id);


--
-- TOC entry 5174 (class 2606 OID 37732)
-- Name: dataset_parameter fk_param_dataset_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset_parameter
    ADD CONSTRAINT fk_param_dataset_parent_id FOREIGN KEY (fk_parent_parameter_id) REFERENCES public.dataset_parameter(parameter_id);


--
-- TOC entry 5184 (class 2606 OID 37782)
-- Name: feature_parameter fk_param_feature_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_parameter
    ADD CONSTRAINT fk_param_feature_id FOREIGN KEY (fk_feature_id) REFERENCES public.feature(feature_id);


--
-- TOC entry 5185 (class 2606 OID 37787)
-- Name: feature_parameter fk_param_feature_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_parameter
    ADD CONSTRAINT fk_param_feature_parent_id FOREIGN KEY (fk_parent_parameter_id) REFERENCES public.feature_parameter(parameter_id);


--
-- TOC entry 5192 (class 2606 OID 37822)
-- Name: location_parameter fk_param_location_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_parameter
    ADD CONSTRAINT fk_param_location_id FOREIGN KEY (fk_location_id) REFERENCES public.location(location_id);


--
-- TOC entry 5193 (class 2606 OID 37827)
-- Name: location_parameter fk_param_location_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_parameter
    ADD CONSTRAINT fk_param_location_parent_id FOREIGN KEY (fk_parent_parameter_id) REFERENCES public.location_parameter(parameter_id);


--
-- TOC entry 5201 (class 2606 OID 37867)
-- Name: observation_parameter fk_param_observation_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation_parameter
    ADD CONSTRAINT fk_param_observation_id FOREIGN KEY (fk_observation_id) REFERENCES public.observation(observation_id);


--
-- TOC entry 5202 (class 2606 OID 37872)
-- Name: observation_parameter fk_param_observation_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation_parameter
    ADD CONSTRAINT fk_param_observation_parent_id FOREIGN KEY (fk_parent_parameter_id) REFERENCES public.observation_parameter(parameter_id);


--
-- TOC entry 5217 (class 2606 OID 37952)
-- Name: phenomenon_parameter fk_param_phenomenon_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenomenon_parameter
    ADD CONSTRAINT fk_param_phenomenon_id FOREIGN KEY (fk_phenomenon_id) REFERENCES public.phenomenon(phenomenon_id);


--
-- TOC entry 5218 (class 2606 OID 37957)
-- Name: phenomenon_parameter fk_param_phenomenon_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenomenon_parameter
    ADD CONSTRAINT fk_param_phenomenon_parent_id FOREIGN KEY (fk_parent_parameter_id) REFERENCES public.phenomenon_parameter(parameter_id);


--
-- TOC entry 5225 (class 2606 OID 37992)
-- Name: platform_parameter fk_param_platform_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform_parameter
    ADD CONSTRAINT fk_param_platform_id FOREIGN KEY (fk_platform_id) REFERENCES public.platform(platform_id);


--
-- TOC entry 5226 (class 2606 OID 37997)
-- Name: platform_parameter fk_param_platform_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform_parameter
    ADD CONSTRAINT fk_param_platform_parent_id FOREIGN KEY (fk_parent_parameter_id) REFERENCES public.platform_parameter(parameter_id);


--
-- TOC entry 5237 (class 2606 OID 38052)
-- Name: procedure_parameter fk_param_procedure_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_parameter
    ADD CONSTRAINT fk_param_procedure_id FOREIGN KEY (fk_procedure_id) REFERENCES public.procedure(procedure_id);


--
-- TOC entry 5238 (class 2606 OID 38057)
-- Name: procedure_parameter fk_param_procedure_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_parameter
    ADD CONSTRAINT fk_param_procedure_parent_id FOREIGN KEY (fk_parent_parameter_id) REFERENCES public.procedure_parameter(parameter_id);


--
-- TOC entry 5198 (class 2606 OID 37857)
-- Name: observation fk_parent_observation; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation
    ADD CONSTRAINT fk_parent_observation FOREIGN KEY (fk_parent_observation_id) REFERENCES public.observation(observation_id);


--
-- TOC entry 5234 (class 2606 OID 38042)
-- Name: procedure_history fk_pdf_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_history
    ADD CONSTRAINT fk_pdf_id FOREIGN KEY (fk_format_id) REFERENCES public.format(format_id);


--
-- TOC entry 5216 (class 2606 OID 37947)
-- Name: phenomenon_i18n fk_phenomenon; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenomenon_i18n
    ADD CONSTRAINT fk_phenomenon FOREIGN KEY (fk_phenomenon_id) REFERENCES public.phenomenon(phenomenon_id);


--
-- TOC entry 5155 (class 2606 OID 37647)
-- Name: composite_phenomenon fk_phenomenon_child; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composite_phenomenon
    ADD CONSTRAINT fk_phenomenon_child FOREIGN KEY (fk_child_phenomenon_id) REFERENCES public.phenomenon(phenomenon_id);


--
-- TOC entry 5214 (class 2606 OID 37937)
-- Name: phenomenon fk_phenomenon_identifier_codesp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenomenon
    ADD CONSTRAINT fk_phenomenon_identifier_codesp FOREIGN KEY (fk_identifier_codespace_id) REFERENCES public.codespace(codespace_id);


--
-- TOC entry 5215 (class 2606 OID 37942)
-- Name: phenomenon fk_phenomenon_name_codespace; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenomenon
    ADD CONSTRAINT fk_phenomenon_name_codespace FOREIGN KEY (fk_name_codespace_id) REFERENCES public.codespace(codespace_id);


--
-- TOC entry 5219 (class 2606 OID 37962)
-- Name: phenomenon_parameter fk_phenomenon_param_unit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phenomenon_parameter
    ADD CONSTRAINT fk_phenomenon_param_unit FOREIGN KEY (fk_unit_id) REFERENCES public.unit(unit_id);


--
-- TOC entry 5156 (class 2606 OID 37642)
-- Name: composite_phenomenon fk_phenomenon_parent; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.composite_phenomenon
    ADD CONSTRAINT fk_phenomenon_parent FOREIGN KEY (fk_parent_phenomenon_id) REFERENCES public.phenomenon(phenomenon_id);


--
-- TOC entry 5222 (class 2606 OID 37977)
-- Name: platform_i18n fk_platform; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform_i18n
    ADD CONSTRAINT fk_platform FOREIGN KEY (fk_platform_id) REFERENCES public.platform(platform_id);


--
-- TOC entry 5186 (class 2606 OID 37797)
-- Name: historical_location fk_platform_historical_location; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historical_location
    ADD CONSTRAINT fk_platform_historical_location FOREIGN KEY (fk_platform_id) REFERENCES public.platform(platform_id);


--
-- TOC entry 5220 (class 2606 OID 37967)
-- Name: platform fk_platform_identifier_codesp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform
    ADD CONSTRAINT fk_platform_identifier_codesp FOREIGN KEY (fk_identifier_codespace_id) REFERENCES public.codespace(codespace_id);


--
-- TOC entry 5224 (class 2606 OID 37987)
-- Name: platform_location fk_platform_location; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform_location
    ADD CONSTRAINT fk_platform_location FOREIGN KEY (fk_platform_id) REFERENCES public.platform(platform_id);


--
-- TOC entry 5221 (class 2606 OID 37972)
-- Name: platform fk_platform_name_codespace; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform
    ADD CONSTRAINT fk_platform_name_codespace FOREIGN KEY (fk_name_codespace_id) REFERENCES public.codespace(codespace_id);


--
-- TOC entry 5227 (class 2606 OID 38002)
-- Name: platform_parameter fk_platform_param_unit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platform_parameter
    ADD CONSTRAINT fk_platform_param_unit FOREIGN KEY (fk_unit_id) REFERENCES public.unit(unit_id);


--
-- TOC entry 5232 (class 2606 OID 38032)
-- Name: procedure_hierarchy fk_procedure_child; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_hierarchy
    ADD CONSTRAINT fk_procedure_child FOREIGN KEY (fk_child_procedure_id) REFERENCES public.procedure(procedure_id);


--
-- TOC entry 5231 (class 2606 OID 38022)
-- Name: procedure fk_procedure_format; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure
    ADD CONSTRAINT fk_procedure_format FOREIGN KEY (fk_format_id) REFERENCES public.format(format_id);


--
-- TOC entry 5235 (class 2606 OID 38037)
-- Name: procedure_history fk_procedure_history; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_history
    ADD CONSTRAINT fk_procedure_history FOREIGN KEY (fk_procedure_id) REFERENCES public.procedure(procedure_id);


--
-- TOC entry 5228 (class 2606 OID 38007)
-- Name: procedure fk_procedure_identifier_codesp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure
    ADD CONSTRAINT fk_procedure_identifier_codesp FOREIGN KEY (fk_identifier_codespace_id) REFERENCES public.codespace(codespace_id);


--
-- TOC entry 5229 (class 2606 OID 38012)
-- Name: procedure fk_procedure_name_codespace; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure
    ADD CONSTRAINT fk_procedure_name_codespace FOREIGN KEY (fk_name_codespace_id) REFERENCES public.codespace(codespace_id);


--
-- TOC entry 5239 (class 2606 OID 38062)
-- Name: procedure_parameter fk_procedure_param_unit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_parameter
    ADD CONSTRAINT fk_procedure_param_unit FOREIGN KEY (fk_unit_id) REFERENCES public.unit(unit_id);


--
-- TOC entry 5233 (class 2606 OID 38027)
-- Name: procedure_hierarchy fk_procedure_parent; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure_hierarchy
    ADD CONSTRAINT fk_procedure_parent FOREIGN KEY (fk_parent_procedure_id) REFERENCES public.procedure(procedure_id);


--
-- TOC entry 5255 (class 2606 OID 38142)
-- Name: value_profile fk_profile_unit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.value_profile
    ADD CONSTRAINT fk_profile_unit FOREIGN KEY (fk_vertical_unit_id) REFERENCES public.unit(unit_id);


--
-- TOC entry 5240 (class 2606 OID 38067)
-- Name: related_dataset fk_rel_dataset_dataset; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.related_dataset
    ADD CONSTRAINT fk_rel_dataset_dataset FOREIGN KEY (fk_dataset_id) REFERENCES public.dataset(dataset_id);


--
-- TOC entry 5241 (class 2606 OID 38072)
-- Name: related_dataset fk_rel_dataset_rel_dataset; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.related_dataset
    ADD CONSTRAINT fk_rel_dataset_rel_dataset FOREIGN KEY (fk_related_dataset_id) REFERENCES public.dataset(dataset_id);


--
-- TOC entry 5243 (class 2606 OID 38087)
-- Name: related_observation fk_rel_obs_related; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.related_observation
    ADD CONSTRAINT fk_rel_obs_related FOREIGN KEY (fk_related_observation_id) REFERENCES public.observation(observation_id);


--
-- TOC entry 5242 (class 2606 OID 38077)
-- Name: related_feature fk_related_feature; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.related_feature
    ADD CONSTRAINT fk_related_feature FOREIGN KEY (fk_feature_id) REFERENCES public.feature(feature_id);


--
-- TOC entry 5213 (class 2606 OID 37932)
-- Name: offering_related_feature fk_related_feature_offering; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.offering_related_feature
    ADD CONSTRAINT fk_related_feature_offering FOREIGN KEY (fk_offering_id) REFERENCES public.offering(offering_id);


--
-- TOC entry 5244 (class 2606 OID 38082)
-- Name: related_observation fk_related_observation; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.related_observation
    ADD CONSTRAINT fk_related_observation FOREIGN KEY (fk_observation_id) REFERENCES public.observation(observation_id);


--
-- TOC entry 5197 (class 2606 OID 37852)
-- Name: observation fk_result_template; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observation
    ADD CONSTRAINT fk_result_template FOREIGN KEY (fk_result_template_id) REFERENCES public.result_template(result_template_id);


--
-- TOC entry 5245 (class 2606 OID 38112)
-- Name: result_template fk_result_template_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.result_template
    ADD CONSTRAINT fk_result_template_category FOREIGN KEY (fk_category_id) REFERENCES public.category(category_id);


--
-- TOC entry 5246 (class 2606 OID 38107)
-- Name: result_template fk_result_template_feature; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.result_template
    ADD CONSTRAINT fk_result_template_feature FOREIGN KEY (fk_feature_id) REFERENCES public.feature(feature_id);


--
-- TOC entry 5247 (class 2606 OID 38092)
-- Name: result_template fk_result_template_offering; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.result_template
    ADD CONSTRAINT fk_result_template_offering FOREIGN KEY (fk_offering_id) REFERENCES public.offering(offering_id);


--
-- TOC entry 5248 (class 2606 OID 38097)
-- Name: result_template fk_result_template_phenomenon; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.result_template
    ADD CONSTRAINT fk_result_template_phenomenon FOREIGN KEY (fk_phenomenon_id) REFERENCES public.phenomenon(phenomenon_id);


--
-- TOC entry 5249 (class 2606 OID 38102)
-- Name: result_template fk_result_template_procedure; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.result_template
    ADD CONSTRAINT fk_result_template_procedure FOREIGN KEY (fk_procedure_id) REFERENCES public.procedure(procedure_id);


--
-- TOC entry 5252 (class 2606 OID 38127)
-- Name: tag_i18n fk_tag; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag_i18n
    ADD CONSTRAINT fk_tag FOREIGN KEY (fk_tag_id) REFERENCES public.tag(tag_id);


--
-- TOC entry 5251 (class 2606 OID 38117)
-- Name: tag_dataset fk_tag_dataset; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag_dataset
    ADD CONSTRAINT fk_tag_dataset FOREIGN KEY (fk_tag_id) REFERENCES public.tag(tag_id);


--
-- TOC entry 5230 (class 2606 OID 38017)
-- Name: procedure fk_type_of; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procedure
    ADD CONSTRAINT fk_type_of FOREIGN KEY (fk_type_of_procedure_id) REFERENCES public.procedure(procedure_id);


--
-- TOC entry 5253 (class 2606 OID 38132)
-- Name: unit_i18n fk_unit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_i18n
    ADD CONSTRAINT fk_unit FOREIGN KEY (fk_unit_id) REFERENCES public.unit(unit_id);


--
-- TOC entry 5170 (class 2606 OID 37717)
-- Name: dataset fk_value_profile; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT fk_value_profile FOREIGN KEY (fk_value_profile_id) REFERENCES public.value_profile(value_profile_id);


-- Completed on 2023-05-05 14:31:02 UTC

--
-- PostgreSQL database dump complete
--

