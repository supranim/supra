# Input validation provider via https://github.com/openpeeps/bag
#
# Validate JSON and multipart payloads with `withBag`
# (see https://github.com/openpeeps/bag for the rules DSL).
# Pairs with the `multipart` recipe via `validateMultipart`.
#
# Enabled via `supra init <project> --restapi` recipe `bag`.
# Import this provider from your controllers with
# `import ../service/provider/bag`.
import pkg/supranim/core/services
import pkg/bag
export bag

initService Bag[Global]:
  description = "Input bag validation service"

  api do:
    proc init*() =
      ## Validation provider (stateless, nothing to configure)
      discard
