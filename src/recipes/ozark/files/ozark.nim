# Ozark ORM service provider via https://github.com/openpeeps/ozark
#
# Singleton handle over Ozark's internal connection-pool singleton.
# The base `db` provider owns the pool (`db.init()`); this service
# prepares tables and exposes model helpers. Run `ozark.init()`
# after `db.init()` in `App.services`.
#
# Enabled via `supra init <project> --restapi` recipe `ozark`.
# Import this provider from your controllers with
# `import ../service/provider/ozark`.
import pkg/supranim/core/[services, application]
import pkg/ozark
import pkg/ozark/driver/psql
export ozark

import ../../model/user
# Recipe models (auto-discovered by the base `db` provider too;
# `newModel` dedupes repeat imports, so this is safe)

initService Ozark[Singleton]:
  description = "Ozark ORM service (models and tables)"

  state do:
    type Ozark = ref object
      tablesReady: bool

  api do:
    proc getOzark*(): ptr Ozark =
      ## Returns the Singleton instance of the Ozark service
      getOzarkInstance(
        proc(instance: ptr Ozark) =
          {.gcsafe.}:
            new(instance[])
      )

    proc init*() =
      ## Prepares the recipe tables using the base pool.
      ## Requires `db.init()` to run first (see `App.services`).
      withDBPool do:
        Models.table(Users).prepareTable().exec()
      getOzark().tablesReady = true

    proc isReady*(): bool =
      ## Whether recipe tables were prepared by `init()`
      getOzark().tablesReady
