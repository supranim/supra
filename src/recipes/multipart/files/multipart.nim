# Multipart provider via https://github.com/openpeeps/multipart
#
# Enabled via `supra init <project> --restapi` recipe `multipart`.
# Pairs well with the `bag` recipe (`validateMultipart`).
import pkg/multipart
export multipart

proc init*() =
  ## Multipart provider (stateless, nothing to configure)
  discard
