-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Mon Dec 14 23:08:14 2009
-- 
BEGIN TRANSACTION;


--
-- Table: diary
--
DROP TABLE diary;
CREATE TABLE diary (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  day date NOT NULL,
  hr integer,
  weight float,
  sleep integer,
  temperature float,
  bodyfat integer,
  notes text,
  t_created datetime NOT NULL DEFAULT '',
  t_updated datetime NOT NULL DEFAULT ''
);

CREATE UNIQUE INDEX diary_day_diary ON diary (day);

--
-- Table: file
--
DROP TABLE file;
CREATE TABLE file (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  pool integer NOT NULL DEFAULT '',
  path varchar NOT NULL DEFAULT '',
  mtime datetime NOT NULL DEFAULT '',
  start datetime NOT NULL DEFAULT '',
  duration integer NOT NULL DEFAULT '',
  ignore boolean NOT NULL DEFAULT '0',
  exercise integer
);

CREATE UNIQUE INDEX file_path_file ON file (path);

--
-- Table: pool
--
DROP TABLE pool;
CREATE TABLE pool (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  name varchar NOT NULL DEFAULT '',
  path varchar NOT NULL DEFAULT '',
  pattern varchar
);

CREATE UNIQUE INDEX pool_name_pool ON pool (name);

COMMIT;
