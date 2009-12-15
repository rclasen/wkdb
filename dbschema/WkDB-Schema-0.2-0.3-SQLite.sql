-- Convert schema 'dbschema/WkDB-Schema-0.2-SQLite.sql' to 'dbschema/WkDB-Schema-0.3-SQLite.sql':

BEGIN;

CREATE TABLE athlete (
  id INTEGER PRIMARY KEY NOT NULL DEFAULT '',
  name varchar NOT NULL DEFAULT '',
  t_created datetime NOT NULL DEFAULT '',
  t_updated datetime NOT NULL DEFAULT ''
);

CREATE UNIQUE INDEX athlete_name_athlete_athlete ON athlete (name);


DROP INDEX diary_day_diary;
ALTER TABLE diary ADD COLUMN athlete integer NOT NULL DEFAULT '';
CREATE UNIQUE INDEX diary_athlete_day_diary_diary ON diary (athlete, day);
DROP INDEX file_path_file;
CREATE UNIQUE INDEX file_pool_path_file_file ON file (pool, path);


COMMIT;
