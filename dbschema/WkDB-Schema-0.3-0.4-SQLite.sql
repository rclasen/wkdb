-- Convert schema 'dbschema/WkDB-Schema-0.3-SQLite.sql' to 'dbschema/WkDB-Schema-0.4-SQLite.sql':

BEGIN;

CREATE TEMPORARY TABLE athlete_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  name varchar NOT NULL DEFAULT '',
  t_created integer NOT NULL DEFAULT '',
  t_updated integer NOT NULL DEFAULT ''
);
INSERT INTO athlete_temp_alter SELECT id, name, t_created, t_updated FROM athlete;
DROP TABLE athlete;
CREATE TABLE athlete (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  name varchar NOT NULL DEFAULT '',
  t_created integer NOT NULL DEFAULT '',
  t_updated integer NOT NULL DEFAULT ''
);
CREATE UNIQUE INDEX athlete_name_athlete_athlete ON athlete (name);
INSERT INTO athlete SELECT id, name, t_created, t_updated FROM athlete_temp_alter;
DROP TABLE athlete_temp_alter;

CREATE TEMPORARY TABLE diary_temp_alter (
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
INSERT INTO diary_temp_alter SELECT id, athlete, day, hr, weight, sleep, temperature, bodyfat, notes, t_created, t_updated FROM diary;
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
CREATE UNIQUE INDEX diary_athlete_day_diary_diary ON diary (athlete, day);
INSERT INTO diary SELECT id, athlete, day, hr, weight, sleep, temperature, bodyfat, notes, t_created, t_updated FROM diary_temp_alter;
DROP TABLE diary_temp_alter;




COMMIT;
