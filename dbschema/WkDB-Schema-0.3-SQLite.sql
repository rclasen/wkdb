-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sat Mar 17 13:49:22 2012
-- 

BEGIN TRANSACTION;

--
-- Table: athlete
--
DROP TABLE athlete;

CREATE TABLE athlete (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  name varchar NOT NULL DEFAULT '',
  t_created integer NOT NULL DEFAULT '',
  t_updated integer NOT NULL DEFAULT ''
);

CREATE UNIQUE INDEX athlete_name ON athlete (name);

--
-- Table: pool
--
DROP TABLE pool;

CREATE TABLE pool (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  name varchar NOT NULL DEFAULT '',
  path varchar NOT NULL DEFAULT '',
  pattern varchar,
  wktype varchar,
  t_created integer NOT NULL DEFAULT '',
  t_updated integer NOT NULL DEFAULT ''
);

CREATE UNIQUE INDEX pool_name ON pool (name);

--
-- Table: diary
--
DROP TABLE diary;

CREATE TABLE diary (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  athlete integer NOT NULL DEFAULT '',
  day date NOT NULL,
  hr integer,
  weight float,
  sleep integer,
  temperature float,
  bodyfat integer,
  notes text,
  t_created integer NOT NULL DEFAULT '',
  t_updated integer NOT NULL DEFAULT ''
);

CREATE INDEX diary_idx_athlete ON diary (athlete);

CREATE UNIQUE INDEX diary_athlete_day ON diary (athlete, day);

--
-- Table: exercise
--
DROP TABLE exercise;

CREATE TABLE exercise (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  athlete integer NOT NULL DEFAULT '',
  endure integer,
  ttborg integer,
  sent boolean,
  t_created integer NOT NULL DEFAULT '',
  t_updated integer NOT NULL DEFAULT ''
);

CREATE INDEX exercise_idx_athlete ON exercise (athlete);

--
-- Table: file
--
DROP TABLE file;

CREATE TABLE file (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  pool integer NOT NULL DEFAULT '',
  path varchar NOT NULL DEFAULT '',
  start integer NOT NULL DEFAULT '',
  duration integer NOT NULL DEFAULT '',
  ignore boolean NOT NULL DEFAULT '0',
  exercise integer,
  t_created integer NOT NULL DEFAULT '',
  t_updated integer NOT NULL DEFAULT ''
);

CREATE INDEX file_idx_exercise ON file (exercise);

CREATE INDEX file_idx_pool ON file (pool);

CREATE UNIQUE INDEX file_pool_path ON file (pool, path);

COMMIT;
