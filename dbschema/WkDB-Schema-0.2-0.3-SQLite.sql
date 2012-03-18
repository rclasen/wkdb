-- Convert schema 'dbschema/WkDB-Schema-0.2-SQLite.sql' to 'dbschema/WkDB-Schema-0.3-SQLite.sql':;

BEGIN;

CREATE TABLE exercise (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  athlete integer NOT NULL DEFAULT '',
  endure integer,
  ttborg integer,
  sent boolean,
  t_created integer NOT NULL DEFAULT '',
  t_updated integer NOT NULL DEFAULT ''
);

INSERT INTO exercise ( id, endure, sent, t_created, t_updated ) SELECT DISTINCT
	exercise, exercise, 1, strftime('%s', 'now' ), strftime('%s', 'now' ) FROM file;

UPDATE exercise SET athlete = ( SELECT min(id) FROM athlete);

CREATE INDEX exercise_idx_athlete ON exercise (athlete);

CREATE INDEX diary_idx_athlete02 ON diary (athlete);

CREATE TEMPORARY TABLE file_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  pool integer NOT NULL DEFAULT '',
  path varchar NOT NULL DEFAULT '',
  start integer NOT NULL DEFAULT '',
  duration integer NOT NULL DEFAULT '',
  ignore boolean NOT NULL DEFAULT '0',
  converted boolean NOT NULL DEFAULT '0',
  exercise integer,
  t_created integer NOT NULL DEFAULT '',
  t_updated integer NOT NULL DEFAULT ''
);

INSERT INTO file_temp_alter SELECT id, pool, path, start, duration, ignore, 0, exercise, t_created, t_updated FROM file;

DROP TABLE file;

CREATE TABLE file (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  pool integer NOT NULL DEFAULT '',
  path varchar NOT NULL DEFAULT '',
  start integer NOT NULL DEFAULT '',
  duration integer NOT NULL DEFAULT '',
  ignore boolean NOT NULL DEFAULT '0',
  converted boolean NOT NULL DEFAULT '0',
  exercise integer,
  t_created integer NOT NULL DEFAULT '',
  t_updated integer NOT NULL DEFAULT ''
);

CREATE INDEX file_idx_exercise03 ON file (exercise);

CREATE INDEX file_idx_pool03 ON file (pool);

CREATE UNIQUE INDEX file_pool_path03 ON file (pool, path);

INSERT INTO file SELECT id, pool, path, start, duration, ignore, converted, exercise, t_created, t_updated FROM file_temp_alter;

DROP TABLE file_temp_alter;


COMMIT;

