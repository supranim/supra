-- Example schema for the Ormin recipe.
--
-- Define your models here, then import them with
-- `importModel(DbBackend.sqlite, "../service/database/schema")`
-- (path relative to the calling module).
--
-- See https://github.com/Araq/ormin for the `query:` DSL.
CREATE TABLE IF NOT EXISTS users(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
