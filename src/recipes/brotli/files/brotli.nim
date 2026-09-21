# Brotli compression provider via https://github.com/nimbase/nbrotli
#
# Pure-Nim Brotli compressor/decompressor (RFC 7932).
# Enabled via `supra init <project> --restapi` recipe `brotli`.
import pkg/nbrotli
export nbrotli

proc init*() =
  ## Init the compression service (stateless, nothing to configure)
  discard
