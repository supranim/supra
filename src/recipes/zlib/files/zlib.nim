# Compression service provider via https://github.com/status-im/nim-zlib
#
# gzip compression on top of the system zlib. Errors surface
# as `CatchableError` with the underlying zlib message.
#
# Enabled via `supra init <project> --restapi` recipe `zlib`.
# Import this provider from your controllers with
# `import ../service/provider/zlib`.
import pkg/supranim/core/services
import results
import pkg/zlib
export zlib

initService Zlib[Global]:
  description = "Compression via zlib (gzip format)"

  api do:
    proc compressData*(data: string): string =
      ## Gzip-compresses `data`
      let res = gzip(string, data)
      if res.isErr:
        raise newException(CatchableError, "zlib compress failed: " & res.error)
      res.value

    proc decompressData*(data: string): string =
      ## Decompresses gzip `data`
      if data.len <= 18:
        raise newException(CatchableError, "zlib decompress failed: not gzip data")
      let res = ungzip(string, data)
      if res.isErr:
        raise newException(CatchableError, "zlib decompress failed: " & res.error)
      res.value
