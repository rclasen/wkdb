-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Mon Dec 14 16:39:50 2009
-- 
BEGIN TRANSACTION;


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
