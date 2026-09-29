# Crypto service provider via https://github.com/puffball1567/nimsodium
#
# Password hashing, secretbox encryption and generic hashing
# on top of libsodium. Requires the libsodium system library
# (`brew install libsodium`, `apt install libsodium-dev`).
#
# Enabled via `supra init <project> --restapi` recipe `nimsodium`.
# Import this provider from your controllers with
# `import ../service/provider/nimsodium`.
import pkg/supranim/core/services
import pkg/nimsodium
export nimsodium

initService Nimsodium[Global]:
  description = "Crypto via libsodium (passwords, secretbox, hashing)"

  api do:
    proc hashUserPassword*(password: string): string =
      ## libsodium password hash for storage
      hashPassword(password)

    proc checkUserPassword*(password, storedHash: string): bool =
      ## Verifies `password` against its stored `storedHash`
      verifyPassword(storedHash, password)

    proc generateKey*(): SecretBoxKey =
      ## Fresh secretbox key for symmetric encryption
      generateSecretBoxKey()

    proc sealMessage*(plainText: string, key: SecretBoxKey): string =
      ## Encrypts `plainText` under `key` (random nonce inside)
      encryptSecretBox(plainText, key)

    proc unsealMessage*(cipherText: string, key: SecretBoxKey): string =
      ## Decrypts a message sealed with `sealMessage`
      decryptSecretBox(cipherText, key)

    proc hashData*(data: string): string =
      ## Lowercase hex BLAKE2b-based generic hash of `data`
      genericHashHex(data)
