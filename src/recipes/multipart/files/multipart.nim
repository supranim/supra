# Multipart provider via https://github.com/openpeeps/multipart
#
# Enabled via `supra init <project> --restapi` recipe `multipart`.
# Pairs with the `bag` recipe (`validateMultipart`).
# Import this provider from your controllers with
# `import ../service/provider/multipart`.
import pkg/supranim/core/services
import pkg/multipart
export multipart

initService Multipart[Global]:
  description = "Multipart upload parsing service"

  api do:
    proc init*() =
      ## Multipart provider (stateless, nothing to configure)
      discard

    proc parseUpload*(contentType, body: string, tmpDir = ""): Multipart =
      ## Parses a multipart `body` (uploads stream to `tmpDir`
      ## when given). Iterate the result for text fields and files.
      var mp = initMultipart(contentType)
      mp.parse(body, tmpDir)
      mp
