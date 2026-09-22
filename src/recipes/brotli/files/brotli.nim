# Brotli compression provider via https://github.com/nimbase/nbrotli
#
# Pure-Nim Brotli compressor/decompressor (RFC 7932).
#
# Enabled via `supra init <project> --restapi` recipe `brotli`.
# Import this provider from your controllers with
# `import ../service/provider/brotli`.
import pkg/supranim/core/services
import pkg/nbrotli
export nbrotli

initService Brotli[Global]:
  description = "Brotli compression service"

  api do:
    proc init*() =
      ## Compression service (stateless, nothing to configure)
      discard

    proc compressText*(s: string, wbits = 16): string =
      ## Brotli-compresses `s`, returning raw bytes as a string
      compress(s, wbits)

    proc decompressText*(data: string): string =
      ## Decompresses raw Brotli `data` back to text
      decompress(data)
