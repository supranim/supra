# Ormin service provider via https://github.com/Araq/ormin
#
# Prepared SQL statement generator with compile-time checked
# `query:` blocks. Owns a global sqlite connection; point `init`
# at a file (or keep `:memory:`). Models live in
# `src/service/database/schema.sql` (a `users` example ships with
# this recipe) — import them with `importModel`, using a path
# relative to the calling module:
#
#   import ../service/provider/ormin
#   importModel(DbBackend.sqlite, "../service/database/schema")
#
# Note: `importModel` shells out to `ormin_importer` at compile
# time; make it available on your PATH with
# `nimble install ormin#head` (or build `tools/ormin_importer`
# from the ormin package).
#
# Enabled via `supra init <project> --restapi` recipe `ormin`.
import pkg/supranim/core/services
import pkg/ormin
import pkg/ormin/ormin_sqlite
export ormin

initService Ormin[Global]:
  description = "Ormin prepared-statement ORM service"

  state do:
    var db* {.global.}: DbConn

  api do:
    proc init*(filename = ":memory:") =
      ## Opens the global sqlite connection used by `query:` blocks.
      ## Pass a file path to persist, e.g. `ormin.init("app.db")`.
      ## For PostgreSQL, open your own `db` via `db_connector/db_postgres`
      ## and `importModel(DbBackend.postgre, "schema")` instead.
      db = open(filename, "", "", "")

    proc closeDb*() =
      ## Closes the global connection
      close(db)
