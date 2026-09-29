# Compression service provider via https://github.com/guzba/zippy
#
# Pure-Nim deflate/zlib/gzip compression. `compressData` emits
# gzip by default; `uncompress` auto-detects gzip/zlib/deflate.
#
# Enabled via `supra init <project> --restapi` recipe `zippy`.
# Import this provider from your controllers with
# `import ../service/provider/zippy`.
import pkg/supranim/core/services
import pkg/zippy
export zippy

initService Zippy[Global]:
  description = "Compression via zippy (gzip, zlib, deflate)"

  api do:
    proc compressData*(data: string): string =
      ## Gzip-compresses `data` (raises `ZippyError` on failure)
      compress(data)

    proc decompressData*(data: string): string =
      ## Decompresses gzip/zlib/deflate `data`, auto-detected
      ## (raises `ZippyError` on invalid input)
      uncompress(data)
