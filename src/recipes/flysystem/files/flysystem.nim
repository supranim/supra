# Filesystem service provider via https://github.com/openpeeps/flysystem
#
# Multi-disk file storage over a global `Filesystem` registry
# (Laravel-style `Storage` facade). The default `local` disk is
# built from `config/flysystem.yml`; add more disks at runtime
# with `addLocalDisk`. Writes are atomic, paths are jailed to
# the disk root. The whole flysystem API is re-exported, so
# `getDisk()` gives you the raw driver (move, copy, streams,
# checksum, mimeType, policies and more).
#
# Enabled via `supra init <project> --restapi` recipe `flysystem`.
# Configure via `config/flysystem.yml`.
# Import this provider from your controllers with
# `import ../service/provider/flysystem`.
import pkg/supranim/core/[services, application]
import pkg/flysystem
export flysystem

initService Flysystem[Global]:
  description = "Multi-disk filesystem service (local driver)"

  state do:
    var store* {.global.}: Filesystem

  api do:
    proc init*() =
      ## Builds the filesystem registry from `config/flysystem.yml`.
      ## The default disk root is created on demand; paths in the
      ## config are resolved against the process working directory.
      let defaultDisk = App.config("flysystem.default").getStr
      let root = App.config("flysystem.local_root").getStr
      store = newFilesystem(defaultDisk)
      store.addDisk(defaultDisk, newLocalDriver(root))

    proc getFilesystem*(): Filesystem =
      ## Returns the global filesystem registry
      store

    proc addLocalDisk*(name, root: string) =
      ## Adds a `local` disk rooted at `root` (created on demand)
      store.addDisk(name, newLocalDriver(root))

    proc getDisk*(name = ""): StorageDriver =
      ## Returns the driver for `name` (default disk when empty)
      store.disk(name)

    proc putFile*(path, content: string, diskName = "",
        visibility = visPrivate) =
      ## Atomically writes `content` to `path` on `diskName`
      store.disk(diskName).write(path, content, visibility)

    proc getFile*(path: string, diskName = ""): string =
      ## Reads the file at `path` from `diskName`
      store.disk(diskName).read(path)

    proc hasFile*(path: string, diskName = ""): bool =
      ## Checks that `path` exists on `diskName`
      store.disk(diskName).exists(path)

    proc deleteFile*(path: string, diskName = "") =
      ## Deletes the file at `path` from `diskName`
      store.disk(diskName).delete(path)

    proc listFiles*(path: string, diskName = "",
        recursive = false): seq[FileMetadata] =
      ## Lists entries under `path` on `diskName`
      store.disk(diskName).list(path, recursive)
