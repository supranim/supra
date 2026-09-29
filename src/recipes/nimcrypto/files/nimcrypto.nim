# Crypto service provider via https://github.com/cheatfate/nimcrypto
#
# Hashing (SHA-2), HMAC authentication, CSPRNG random bytes,
# plus high-level helpers nimcrypto itself does not ship:
# PBKDF2 password hashing (`hashUserPassword`/`checkUserPassword`)
# and AES-256-GCM authenticated encryption (`generateKey`,
# `encryptData`/`decryptData`).
#
# Enabled via `supra init <project> --restapi` recipe `nimcrypto`.
# Import this provider from your controllers with
# `import ../service/provider/nimcrypto`.
import std/strutils
import pkg/supranim/core/services
import pkg/nimcrypto
import nimcrypto/pbkdf2
export nimcrypto

const pbkdf2Iterations = 600_000

func strToBytes(s: string): seq[byte] =
  result = newSeq[byte](s.len)
  for i in 0 ..< s.len:
    result[i] = byte(s[i])

func bytesToStr(b: openArray[byte]): string =
  result = newString(b.len)
  for i in 0 ..< b.len:
    result[i] = char(b[i])

initService Nimcrypto[Global]:
  description = "Crypto primitives (SHA-2, HMAC, CSPRNG, PBKDF2, AES-GCM)"

  api do:
    proc sha256Hex*(data: string): string =
      ## Lowercase hex SHA-256 digest of `data`
      utils.toHex(sha256.digest(data).data, true)

    proc sha512Hex*(data: string): string =
      ## Lowercase hex SHA-512 digest of `data`
      utils.toHex(sha512.digest(data).data, true)

    proc hmacSha256Hex*(key, data: string): string =
      ## Lowercase hex HMAC-SHA-256 of `data` under `key`
      utils.toHex(sha256.hmac(key, data).data, true)

    proc randomBytesSeq*(nbytes: int): seq[byte] =
      ## `nbytes` of cryptographically secure random bytes
      result = newSeq[byte](nbytes)
      if randomBytes(result) != nbytes:
        raise newException(CatchableError, "nimcrypto: CSPRNG failure")

    proc hashUserPassword*(password: string): string =
      ## PBKDF2-HMAC-SHA256 password hash for storage, formatted as
      ## `pbkdf2-sha256$<iterations>$<saltHex>$<dkHex>`
      var salt = newSeq[byte](16)
      if randomBytes(salt) != salt.len:
        raise newException(CatchableError, "nimcrypto: CSPRNG failure")
      let dk = pbkdf2(sha256, password, salt, pbkdf2Iterations, 32)
      "pbkdf2-sha256$" & $pbkdf2Iterations & "$" &
        utils.toHex(salt, true) & "$" & utils.toHex(dk, true)

    proc checkUserPassword*(password, storedHash: string): bool =
      ## Verifies `password` against a `hashUserPassword` hash
      ## (constant-time comparison, `false` on malformed input)
      try:
        let parts = storedHash.split('$')
        if parts.len != 4 or parts[0] != "pbkdf2-sha256":
          return false
        let iters = parseInt(parts[1])
        let salt = utils.fromHex(parts[2])
        let expected = utils.fromHex(parts[3])
        if salt.len == 0 or expected.len == 0 or iters <= 0:
          return false
        let dk = pbkdf2(sha256, password, salt, iters, expected.len)
        utils.equalMemFull(dk, expected)
      except CatchableError:
        false

    proc generateKey*(): array[32, byte] =
      ## Fresh 256-bit key for `encryptData`/`decryptData`
      if randomBytes(result) != result.len:
        raise newException(CatchableError, "nimcrypto: CSPRNG failure")

    proc encryptData*(plainText: string, key: array[32, byte]): string =
      ## AES-256-GCM encryption under `key`. Returns raw bytes as a
      ## string laid out as `nonce(12) & ciphertext & tag(16)`
      ## with a fresh random nonce per call.
      var nonce: array[12, byte]
      if randomBytes(nonce) != nonce.len:
        raise newException(CatchableError, "nimcrypto: CSPRNG failure")
      let input = strToBytes(plainText)
      var output = newSeq[byte](input.len)
      var tag: array[16, byte]
      let noAad: seq[byte] = @[]
      var ctx: GCM[aes256]
      ctx.init(key, nonce, noAad)
      ctx.encrypt(input, output, tag)
      ctx.clear()
      bytesToStr(nonce) & bytesToStr(output) & bytesToStr(tag)

    proc decryptData*(cipherText: string, key: array[32, byte]): string =
      ## Decrypts an `encryptData` payload. Raises `CatchableError`
      ## on truncated input or authentication failure.
      if cipherText.len < 12 + 16:
        raise newException(CatchableError,
          "nimcrypto: ciphertext too short")
      let nonce = strToBytes(cipherText[0 ..< 12])
      let tag = strToBytes(cipherText[^16 .. ^1])
      let input = strToBytes(cipherText[12 ..< cipherText.len - 16])
      var output = newSeq[byte](input.len)
      let noAad: seq[byte] = @[]
      var ctx: GCM[aes256]
      ctx.init(key, nonce, noAad)
      let ok = ctx.decrypt(input, output, tag)
      ctx.clear()
      if not ok:
        raise newException(CatchableError,
          "nimcrypto: authentication failed")
      bytesToStr(output)
