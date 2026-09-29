# Example Users model for the Ozark recipe.
#
# Models in `src/model/` are auto-discovered by the base `db`
# provider (`loadModels`). Define yours with `newModel`:
import pkg/ozark/model

newModel Users:
  id {.pk.}: Serial
  name: Varchar(100)
  email {.notnull, unique.}: Varchar(100)
  password {.notnull.}: Varchar(255)
  created_at {.notnull.}: TimestampTz
