--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: votemaster
--

CREATE TABLE alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE alembic_version OWNER TO votemaster;

--
-- Name: county; Type: TABLE; Schema: public; Owner: votemaster
--

CREATE TABLE county (
    code smallint NOT NULL,
    name character varying(15)
);


ALTER TABLE county OWNER TO votemaster;

--
-- Name: county_code_seq; Type: SEQUENCE; Schema: public; Owner: votemaster
--

CREATE SEQUENCE county_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE county_code_seq OWNER TO votemaster;

--
-- Name: county_code_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: votemaster
--

ALTER SEQUENCE county_code_seq OWNED BY county.code;


--
-- Name: rawvoter; Type: TABLE; Schema: public; Owner: votemaster
--

CREATE TABLE rawvoter (
    id integer NOT NULL,
    lastname character varying(50),
    firstname character varying(50),
    middlename character varying(50),
    namesuffix character varying(10),
    raddnumber character varying(10),
    rhalfcode character varying(10),
    rapartment character varying(15),
    rpredirection character varying(10),
    rstreetname character varying(70),
    rpostdirection character varying(10),
    rcity character varying(50),
    rzip5 character varying(5),
    rzip4 character varying(4),
    mailadd1 character varying(100),
    mailadd2 character varying(100),
    mailadd3 character varying(100),
    mailadd4 character varying(100),
    dob date,
    gender character varying(1),
    enrollment character varying(3),
    otherparty character varying(30),
    countycode smallint,
    ed_number smallint,
    ld_number smallint,
    towncity character varying(30),
    ward character varying(3),
    cd smallint,
    sd smallint,
    ad smallint,
    lastvoteddate date,
    prevyearvoted smallint,
    prevcounty character varying(2),
    prevaddress character varying(100),
    prevname character varying(150),
    countyvrnumber character varying(50),
    regdate date,
    vrsource character varying(10),
    idrequired boolean,
    idmet boolean,
    status character varying(10),
    reasoncode character varying(15),
    inact_date date,
    purge_date date,
    sboeid character varying(50),
    voterhistory character varying(1200),
    district smallint,
    lat double precision,
    lng double precision,
    geocode_rating double precision,
    e2001_09_primary boolean,
    e2001_11_general boolean,
    e2005_09_primary boolean,
    e2005_11_general boolean,
    e2006_11_general boolean,
    e2008_02_primary boolean,
    e2008_11_general boolean,
    e2009_09_primary boolean,
    e2009_11_general boolean,
    e2010_09_primary boolean,
    e2010_11_general boolean,
    e2012_06_primary boolean,
    e2012_09_primary boolean,
    e2012_11_general boolean,
    e2013_09_primary boolean,
    e2013_11_general boolean,
    e2014_06_primary boolean,
    e2014_11_general boolean,
    processed boolean
);


ALTER TABLE rawvoter OWNER TO votemaster;

--
-- Name: rawvoter_id_seq; Type: SEQUENCE; Schema: public; Owner: votemaster
--

CREATE SEQUENCE rawvoter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rawvoter_id_seq OWNER TO votemaster;

--
-- Name: rawvoter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: votemaster
--

ALTER SEQUENCE rawvoter_id_seq OWNED BY rawvoter.id;


--
-- Name: voter_grades; Type: TABLE; Schema: public; Owner: votemaster
--

CREATE TABLE voter_grades (
    id integer NOT NULL,
    raw_voter_id integer,
    local_primary numeric,
    local_general numeric,
    national_midterm numeric,
    national_presidential numeric
);


ALTER TABLE voter_grades OWNER TO votemaster;

--
-- Name: voter_grades_id_seq; Type: SEQUENCE; Schema: public; Owner: votemaster
--

CREATE SEQUENCE voter_grades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE voter_grades_id_seq OWNER TO votemaster;

--
-- Name: voter_grades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: votemaster
--

ALTER SEQUENCE voter_grades_id_seq OWNED BY voter_grades.id;


--
-- Name: county code; Type: DEFAULT; Schema: public; Owner: votemaster
--

ALTER TABLE ONLY county ALTER COLUMN code SET DEFAULT nextval('county_code_seq'::regclass);


--
-- Name: rawvoter id; Type: DEFAULT; Schema: public; Owner: votemaster
--

ALTER TABLE ONLY rawvoter ALTER COLUMN id SET DEFAULT nextval('rawvoter_id_seq'::regclass);


--
-- Name: voter_grades id; Type: DEFAULT; Schema: public; Owner: votemaster
--

ALTER TABLE ONLY voter_grades ALTER COLUMN id SET DEFAULT nextval('voter_grades_id_seq'::regclass);


--
-- Name: county county_pkey; Type: CONSTRAINT; Schema: public; Owner: votemaster
--

ALTER TABLE ONLY county
    ADD CONSTRAINT county_pkey PRIMARY KEY (code);


--
-- Name: rawvoter rawvoter_pkey; Type: CONSTRAINT; Schema: public; Owner: votemaster
--

ALTER TABLE ONLY rawvoter
    ADD CONSTRAINT rawvoter_pkey PRIMARY KEY (id);


--
-- Name: voter_grades voter_grades_pkey; Type: CONSTRAINT; Schema: public; Owner: votemaster
--

ALTER TABLE ONLY voter_grades
    ADD CONSTRAINT voter_grades_pkey PRIMARY KEY (id);


--
-- Name: ix_rawvoter_district; Type: INDEX; Schema: public; Owner: votemaster
--

CREATE INDEX ix_rawvoter_district ON rawvoter USING btree (district);


--
-- Name: ix_rawvoter_processed; Type: INDEX; Schema: public; Owner: votemaster
--

CREATE INDEX ix_rawvoter_processed ON rawvoter USING btree (processed);


--
-- Name: ix_rawvoter_purge_date; Type: INDEX; Schema: public; Owner: votemaster
--

CREATE INDEX ix_rawvoter_purge_date ON rawvoter USING btree (purge_date);


--
-- Name: ix_rawvoter_raddnumber; Type: INDEX; Schema: public; Owner: votemaster
--

CREATE INDEX ix_rawvoter_raddnumber ON rawvoter USING btree (raddnumber);


--
-- Name: ix_rawvoter_regdate; Type: INDEX; Schema: public; Owner: votemaster
--

CREATE INDEX ix_rawvoter_regdate ON rawvoter USING btree (regdate);


--
-- Name: ix_rawvoter_rzip5; Type: INDEX; Schema: public; Owner: votemaster
--

CREATE INDEX ix_rawvoter_rzip5 ON rawvoter USING btree (rzip5);


--
-- Name: ix_rawvoter_sboeid; Type: INDEX; Schema: public; Owner: votemaster
--

CREATE INDEX ix_rawvoter_sboeid ON rawvoter USING btree (sboeid);


--
-- Name: ix_rawvoter_status; Type: INDEX; Schema: public; Owner: votemaster
--

CREATE INDEX ix_rawvoter_status ON rawvoter USING btree (status);


--
-- Name: public; Type: ACL; Schema: -; Owner: derekkaknes
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM derekkaknes;
GRANT ALL ON SCHEMA public TO derekkaknes;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

