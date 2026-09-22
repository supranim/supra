# JOSE service provider (JWT/JWS) via https://github.com/nimbase/jose
#
# Enabled via `supra init <project> --restapi` recipe `jose`.
# Configure via `config/jose.yml` (`secret` supports `${env.NAME}` refs).
# Import this provider from your controllers with
# `import ../service/provider/jose`.
import std/[os, strutils, times, json]
import pkg/supranim/core/[services, application]
import pkg/jose
export jose

initService Jose[Global]:
  description = "JOSE JWT/JWS auth service"

  state do:
    var jwtKey: Jwk
    var jwtIssuer: string

  api do:
    proc resolveEnvRef(raw: string): string =
      ## Resolves `${env.NAME}` refs, otherwise returns `raw` unchanged
      let v = raw.strip()
      if v.startsWith("${env.") and v.endsWith("}"):
        return getEnv(v[6 .. ^2])
      v

    proc init*() =
      ## Inits the JOSE service from `config/jose.yml`.
      ## Set the `JWT_SECRET` env var in production.
      let secret = resolveEnvRef(App.config("jose.secret").getStr)
      if secret.len == 0:
        raise newException(ValueError,
          "JOSE: missing `jose.secret` (see config/jose.yml)")
      jwtKey = jwkOctKey(toOpenArrayByte(secret, 0, secret.high))
      jwtIssuer = App.config("jose.issuer").getStr

    proc issueToken*(subject: string, expiresIn = 3600'i64): string =
      ## Issues a signed HS256 JWT for `subject`
      var b = initJwtBuilder()
      b.sub(subject)
      b.iat(getTime().toUnix())
      b.exp(getTime().toUnix() + expiresIn)
      if jwtIssuer.len > 0:
        b.iss(jwtIssuer)
      jwtSign(b, HS256, jwtKey)

    proc verifyToken*(token: string): JsonNode =
      ## Verifies `token` signature and claims, returning the claims.
      ## Raises on invalid signature or failed claim checks.
      jwtVerify(token, jwtKey, initJwtChecker(issuer = jwtIssuer))
