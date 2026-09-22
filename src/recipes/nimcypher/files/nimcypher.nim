# Crypto service provider via https://github.com/nimbas/nimcypher
#
# A pure-Nim port of Monocypher: hashing, authenticated encryption,
# key exchange, signatures and password hashing.
#
# Enabled via `supra init <project> --restapi` recipe `nimcypher`.
# Import this provider from your controllers with
# `import ../service/provider/nimcypher`.
import pkg/supranim/core/services
import pkg/nimcypher
export nimcypher

initService Nimcypher[Global]:
  description = "Crypto service (hashing, AEAD, signatures)"

  api do:
    proc init*() =
      ## Crypto service (stateless, nothing to configure)
      discard

    proc hashUserPassword*(password: string): string =
      ## Argon2 password hash for storage
      hashPassword(password)

    proc checkUserPassword*(password, storedHash: string): bool =
      ## Verifies `password` against its stored Argon2 `storedHash`
      verifyPassword(password, storedHash)
