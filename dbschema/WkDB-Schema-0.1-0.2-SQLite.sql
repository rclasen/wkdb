-- Convert schema 'dbschema/WkDB-Schema-0.1-SQLite.sql' to 'dbschema/WkDB-Schema-0.2-SQLite.sql':

BEGIN;

CREATE TABLE athlete (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  name varchar NOT NULL DEFAULT '',
  t_created integer NOT NULL DEFAULT '',
  t_updated integer NOT NULL DEFAULT ''
);

CREATE UNIQUE INDEX athlete_name_athlete_athlete ON athlete (name);

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

CREATE UNIQUE INDEX diary_athlete_day_diary_diary ON diary (athlete, day);



CREATE TEMPORARY TABLE file_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  pool integer NOT NULL DEFAULT '',
  path varchar NOT NULL DEFAULT '',
  mtime integer NOT NULL DEFAULT '',
  start integer NOT NULL DEFAULT '',
  duration integer NOT NULL DEFAULT '',
  ignore boolean NOT NULL DEFAULT '0',
  exercise integer,
  t_created integer NOT NULL DEFAULT '',
  t_updated integer NOT NULL DEFAULT ''
);
INSERT INTO file_temp_alter SELECT
	id, pool, path,
	strftime('%s',mtime), -- convert
	strftime('%s',start), -- convert
	duration, ignore, exercise,
	strftime('%s','now'), -- default
	strftime('%s','now') -- default
FROM file;
DROP TABLE file;
CREATE TABLE file (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  pool integer NOT NULL DEFAULT '',
  path varchar NOT NULL DEFAULT '',
  mtime integer NOT NULL DEFAULT '',
  start integer NOT NULL DEFAULT '',
  duration integer NOT NULL DEFAULT '',
  ignore boolean NOT NULL DEFAULT '0',
  exercise integer,
  t_created integer NOT NULL DEFAULT '',
  t_updated integer NOT NULL DEFAULT ''
);
CREATE UNIQUE INDEX file_pool_path_file_file ON file (pool, path);
INSERT INTO file SELECT id, pool, path, mtime, start, duration, ignore, exercise, t_created, t_updated FROM file_temp_alter;
DROP TABLE file_temp_alter;

ALTER TABLE pool ADD COLUMN wktype varchar;
ALTER TABLE pool ADD COLUMN t_created integer NOT NULL DEFAULT '';
ALTER TABLE pool ADD COLUMN t_updated integer NOT NULL DEFAULT '';

COMMIT;
