# E2EE service provider via https://github.com/openpeeps/e2ee
#
# Both the high-level API (Argon2id password hashing, AEAD
# seal/unseal, BLAKE2b hashing) and the low-level Monocypher
# API (`monocypher`, `utils`) are re-exported — the whole
# library surface is available from this provider.
#
# Enabled via `supra init <project> --restapi` recipe `e2ee`.
# Import this provider from your controllers with
# `import ../service/provider/e2ee`.
import pkg/supranim/core/services
import pkg/e2ee
export e2ee

initService E2ee[Global]:
  description = "E2EE via Monocypher (passwords, AEAD, BLAKE2b)"

  api do:
    proc hashUserPassword*(password: string): string =
      ## Argon2id password hash for storage
      password.hashPassword(password)

    proc checkUserPassword*(password, storedHash: string): bool =
      ## Verifies `password` against its stored Argon2id `storedHash`
      password.verifyPassword(password, storedHash)

    proc generateKey*(): Key32 =
      ## Fresh 32-byte symmetric key for AEAD sealing
      utils.randomBytes[32]()

    proc sealMessage*(plainText: string, key: Key32): SealedMessage =
      ## AEAD-seals `plainText` under `key` (random nonce inside)
      aead.seal(plainText, key)

    proc unsealMessage*(msg: SealedMessage, key: Key32): string =
      ## Opens a message sealed with `sealMessage`
      aead.unseal(msg, key)

    proc blakeHash*(data: string): string =
      ## Lowercase hex BLAKE2b digest of `data`
      blake2b.blakeHex(data)
