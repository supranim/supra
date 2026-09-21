# Crypto service provider via https://github.com/nimbas/nimcypher
#
# A pure-Nim port of Monocypher: hashing, authenticated encryption,
# key exchange, signatures and password hashing.
# Enabled via `supra init <project> --restapi` recipe `nimcypher`.
import pkg/nimcypher
export nimcypher

proc init*() =
  ## Init the crypto service (stateless, nothing to configure)
  discard
