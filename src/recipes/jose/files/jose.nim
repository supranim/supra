# JOSE service provider (JWT/JWS/JWE) via https://github.com/nimbase/jose
#
# Enabled via `supra init <project> --restapi` recipe `jose`.
# Import this provider from your controllers with
# `import ../service/provider/jose`.
import std/os
import pkg/jose
export jose

var jwtSecret* = getEnv("JWT_SECRET", "change-me-in-production")

proc init*() =
  ## Init the JOSE service. Set the `JWT_SECRET`
  ## env var in production.
  jwtSecret = getEnv("JWT_SECRET", "change-me-in-production")
