# MIME database provider via https://github.com/openpeeps/mimedb
#
# Enabled via `supra init <project> --restapi` recipe `mimedb`.
# Import this provider from your controllers with
# `import ../service/provider/mimedb`.
import std/options
import pkg/supranim/core/services
import pkg/mimedb
export mimedb

initService Mimedb[Global]:
  description = "MIME type database service"

  api do:
    proc init*() =
      ## Loads the MIME database. Called once at
      ## startup from the `App.services` block.
      initDatabase()

    proc mimeTypeFor*(ext: string): string =
      ## Returns the MIME type for `ext` (`"html"` → `"text/html"`),
      ## or `""` when the extension is unknown
      let m = getMimeType(ext)
      if m.isSome: m.get else: ""

    proc mimeIsCompressible*(mimeType: string): bool =
      ## Whether `mimeType` is marked compressible in the database
      isCompressible(getMimeInfo(mimeType))
