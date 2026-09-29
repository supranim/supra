# Norm ORM service provider via https://github.com/moigagoo/norm
#
# Object-driven ORM for PostgreSQL (and SQLite via `norm/sqlite`).
# Connections come from `DB_HOST`, `DB_USER`, `DB_PASS`, `DB_NAME`
# env vars (`getDb`); run queries inside `withNormDb` and define
# your models as `Model` subtypes, e.g.
#
#   type Account* = ref object of Model
#     name*: string
#
#   withNormDb:
#     var accounts = @[Account(name: "alice")]
#     db.createTables(accounts)
#     db.insert(accounts)
#
# Enabled via `supra init <project> --restapi` recipe `norm`.
# Import this provider from your controllers with
# `import ../service/provider/norm`.
import std/[os, strutils]
import pkg/supranim/core/services
import pkg/norm/postgres
export postgres

initService Norm[Global]:
  description = "Norm ORM service (PostgreSQL)"

  api do:
    proc init*() =
      ## Validates the `DB_*` env vars norm connects with.
      ## Set them in `.env.yml`/environment before starting.
      var missing: seq[string]
      for k in ["DB_HOST", "DB_USER", "DB_PASS", "DB_NAME"]:
        if getEnv(k).len == 0:
          missing.add(k)
      if missing.len > 0:
        raise newException(ValueError,
          "Norm: missing env vars: " & missing.join(", "))

    template withNormDb*(body: untyped): untyped =
      ## Opens a norm connection for `body` (as `db`), closing it after
      withDb(body)
