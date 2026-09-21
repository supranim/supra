# Input validation provider via https://github.com/openpeeps/bag
#
# Validate JSON and multipart payloads with `withBag`:
#
#   withBag(body, {"email".required().isEmail()}):
#     discard
#
# Enabled via `supra init <project> --restapi` recipe `bag`.
import pkg/bag
export bag

proc init*() =
  ## Validation provider (stateless, nothing to configure)
  discard
