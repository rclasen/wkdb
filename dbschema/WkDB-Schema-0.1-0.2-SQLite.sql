-- Convert schema 'dbschema/WkDB-Schema-0.1-SQLite.sql' to 'dbschema/WkDB-Schema-0.2-SQLite.sql':

BEGIN;

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

CREATE UNIQUE INDEX diary_day_diary_diary ON diary (day);





COMMIT;
