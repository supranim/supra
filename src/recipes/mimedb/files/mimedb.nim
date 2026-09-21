# MIME database provider via https://github.com/openpeeps/mimedb
#
# Enabled via `supra init <project> --restapi` recipe `mimedb`.
import pkg/mimedb
export mimedb

proc init*() =
  ## Loads the MIME database. Called once at
  ## startup from the `App.services` block.
  initDatabase()
