# Crypto service provider via https://github.com/cheatfate/nimcrypto
#
# Hashing (SHA-1, SHA-2, RIPEMD, SHA-3, BLAKE2), HMAC authentication,
# CSPRNG random bytes, plus high-level helpers nimcrypto itself
# does not ship: PBKDF2/scrypt password hashing (`hashUserPassword`,
# `hashUserPasswordScrypt`, `checkUserPassword`), key derivation
# (`deriveKey`), AES-256-GCM and AES-256-CBC authenticated
# encryption (`generateKey`, `encryptData`/`decryptData`,
# `encryptDataCbc`/`decryptDataCbc`), and constant-time comparison.
#
# Enabled via `supra init <project> --restapi` recipe `nimcrypto`.
# Import this provider from your controllers with
# `import ../service/provider/nimcrypto`.
import std/[strutils, base64]
import pkg/supranim/core/services
import pkg/nimcrypto
import pkg/nimcrypto/pbkdf2
import pkg/nimcrypto/scrypt
export nimcrypto

const
  pbkdf2Iterations = 600_000
  scryptN = 32768
  scryptR = 8
  scryptP = 1
  aesBlockLen = 16

func strToBytes(s: string): seq[byte] =
  result = newSeq[byte](s.len)
  for i in 0 ..< s.len:
    result[i] = byte(s[i])

func bytesToStr(b: openArray[byte]): string =
  result = newString(b.len)
  for i in 0 ..< b.len:
    result[i] = char(b[i])

func pkcs7Pad(data: seq[byte], blockLen: int): seq[byte] =
  let padLen = blockLen - (data.len mod blockLen)
  result = data
  result.setLen(data.len + padLen)
  for i in data.len ..< result.len:
    result[i] = byte(padLen)

func pkcs7Unpad(data: seq[byte]): seq[byte] =
  if data.len == 0 or data.len mod aesBlockLen != 0:
    raise newException(CatchableError, "nimcrypto: invalid padding")
  let padLen = int(data[^1])
  if padLen <= 0 or padLen > aesBlockLen:
    raise newException(CatchableError, "nimcrypto: invalid padding")
  for i in data.len - padLen ..< data.len:
    if int(data[i]) != padLen:
      raise newException(CatchableError, "nimcrypto: invalid padding")
  result = data[0 ..< data.len - padLen]

initService Nimcrypto[Global]:
  description = "Crypto primitives (hashing, HMAC, CSPRNG, PBKDF2, scrypt, AES-GCM/CBC)"

  api do:
    proc sha1Hex*(data: string): string =
      ## Lowercase hex SHA-1 digest of `data` (legacy, prefer SHA-2)
      utils.toHex(sha1.digest(data).data, true)

    proc sha224Hex*(data: string): string =
      ## Lowercase hex SHA-224 digest of `data`
      utils.toHex(sha224.digest(data).data, true)

    proc sha256Hex*(data: string): string =
      ## Lowercase hex SHA-256 digest of `data`
      utils.toHex(sha256.digest(data).data, true)

    proc sha384Hex*(data: string): string =
      ## Lowercase hex SHA-384 digest of `data`
      utils.toHex(sha384.digest(data).data, true)

    proc sha512Hex*(data: string): string =
      ## Lowercase hex SHA-512 digest of `data`
      utils.toHex(sha512.digest(data).data, true)

    proc ripemd160Hex*(data: string): string =
      ## Lowercase hex RIPEMD-160 digest of `data` (legacy)
      utils.toHex(ripemd160.digest(data).data, true)

    proc sha3_256Hex*(data: string): string =
      ## Lowercase hex SHA3-256 digest of `data`
      utils.toHex(sha3_256.digest(data).data, true)

    proc sha3_512Hex*(data: string): string =
      ## Lowercase hex SHA3-512 digest of `data`
      utils.toHex(sha3_512.digest(data).data, true)

    proc blake2_256Hex*(data: string): string =
      ## Lowercase hex BLAKE2s-256 digest of `data`
      utils.toHex(blake2_256.digest(data).data, true)

    proc blake2_512Hex*(data: string): string =
      ## Lowercase hex BLAKE2b-512 digest of `data`
      utils.toHex(blake2_512.digest(data).data, true)

    proc hmacSha256Hex*(key, data: string): string =
      ## Lowercase hex HMAC-SHA-256 of `data` under `key`
      utils.toHex(sha256.hmac(key, data).data, true)

    proc hmacSha512Hex*(key, data: string): string =
      ## Lowercase hex HMAC-SHA-512 of `data` under `key`
      utils.toHex(sha512.hmac(key, data).data, true)

    proc hmacHex*(hashName, key, data: string): string =
      ## Lowercase hex HMAC of `data` under `key` with a named hash:
      ## `sha1`, `sha224`, `sha256`, `sha384`, `sha512`,
      ## `ripemd160`, `sha3_256`, `sha3_512`, `blake2_256`, `blake2_512`
      ## (hyphenated spellings like `SHA-256` also work)
      case hashName.toLowerAscii()
      of "sha1", "sha-1": utils.toHex(sha1.hmac(key, data).data, true)
      of "sha224", "sha-224": utils.toHex(sha224.hmac(key, data).data, true)
      of "sha256", "sha-256": utils.toHex(sha256.hmac(key, data).data, true)
      of "sha384", "sha-384": utils.toHex(sha384.hmac(key, data).data, true)
      of "sha512", "sha-512": utils.toHex(sha512.hmac(key, data).data, true)
      of "ripemd160", "ripemd-160":
        utils.toHex(ripemd160.hmac(key, data).data, true)
      of "sha3_256", "sha3-256":
        utils.toHex(sha3_256.hmac(key, data).data, true)
      of "sha3_512", "sha3-512":
        utils.toHex(sha3_512.hmac(key, data).data, true)
      of "blake2_256", "blake2-256":
        utils.toHex(blake2_256.hmac(key, data).data, true)
      of "blake2_512", "blake2-512":
        utils.toHex(blake2_512.hmac(key, data).data, true)
      else:
        raise newException(CatchableError,
          "nimcrypto: unknown hash `" & hashName & "`")

    proc randomBytesSeq*(nbytes: int): seq[byte] =
      ## `nbytes` of cryptographically secure random bytes
      result = newSeq[byte](nbytes)
      if randomBytes(result) != nbytes:
        raise newException(CatchableError, "nimcrypto: CSPRNG failure")

    proc randomHex*(nbytes: int): string =
      ## Lowercase hex string from `nbytes` of CSPRNG output
      utils.toHex(randomBytesSeq(nbytes), true)

    proc randomToken*(nbytes = 32): string =
      ## URL-safe base64 token (no padding) from `nbytes` of CSPRNG output
      encode(bytesToStr(randomBytesSeq(nbytes)))
        .replace("+", "-").replace("/", "_").strip(chars = {'='})

    proc constantTimeEqual*(a, b: string): bool =
      ## Constant-time string comparison for tokens and hashes
      utils.equalMemFull(strToBytes(a), strToBytes(b))

    proc hashUserPassword*(password: string): string =
      ## PBKDF2-HMAC-SHA256 password hash for storage, formatted as
      ## `pbkdf2-sha256$<iterations>$<saltHex>$<dkHex>`
      var salt = newSeq[byte](16)
      if randomBytes(salt) != salt.len:
        raise newException(CatchableError, "nimcrypto: CSPRNG failure")
      let dk = pbkdf2(sha256, password, salt, pbkdf2Iterations, 32)
      "pbkdf2-sha256$" & $pbkdf2Iterations & "$" &
        utils.toHex(salt, true) & "$" & utils.toHex(dk, true)

    proc hashUserPasswordScrypt*(password: string): string =
      ## scrypt password hash for storage (N=32768, r=8, p=1),
      ## formatted as `scrypt$<N>$<r>$<p>$<saltHex>$<dkHex>`
      var salt = newSeq[byte](16)
      if randomBytes(salt) != salt.len:
        raise newException(CatchableError, "nimcrypto: CSPRNG failure")
      let (xyvLen, bLen) = scryptCalc(scryptN, scryptR, scryptP)
      var xyv = newSeq[uint32](xyvLen)
      var b = newSeq[byte](bLen)
      var dk = newSeq[byte](32)
      if scrypt(password, salt, scryptN, scryptR, scryptP,
          xyv, b, dk) == 0:
        raise newException(CatchableError, "nimcrypto: scrypt failure")
      "scrypt$" & $scryptN & "$" & $scryptR & "$" & $scryptP & "$" &
        utils.toHex(salt, true) & "$" & utils.toHex(dk, true)

    proc checkUserPassword*(password, storedHash: string): bool =
      ## Verifies `password` against a `hashUserPassword` (PBKDF2)
      ## or `hashUserPasswordScrypt` hash (constant-time comparison,
      ## `false` on malformed input)
      try:
        let parts = storedHash.split('$')
        if parts[0] == "pbkdf2-sha256" and parts.len == 4:
          let iters = parseInt(parts[1])
          let salt = utils.fromHex(parts[2])
          let expected = utils.fromHex(parts[3])
          if salt.len == 0 or expected.len == 0 or iters <= 0:
            return false
          let dk = pbkdf2(sha256, password, salt, iters, expected.len)
          return utils.equalMemFull(dk, expected)
        if parts[0] == "scrypt" and parts.len == 6:
          let n = parseInt(parts[1])
          let r = parseInt(parts[2])
          let p = parseInt(parts[3])
          let salt = utils.fromHex(parts[4])
          let expected = utils.fromHex(parts[5])
          if salt.len == 0 or expected.len == 0 or
              n <= 1 or r <= 0 or p <= 0:
            return false
          let (xyvLen, bLen) = scryptCalc(n, r, p)
          var xyv = newSeq[uint32](xyvLen)
          var b = newSeq[byte](bLen)
          var dk = newSeq[byte](expected.len)
          if scrypt(password, salt, n, r, p, xyv, b, dk) == 0:
            return false
          return utils.equalMemFull(dk, expected)
        false
      except CatchableError:
        false

    proc deriveKey*(password, saltHex: string, iters, outLen: int): string =
      ## PBKDF2-HMAC-SHA256 key derivation, returns lowercase hex.
      ## Use for tokens or sub-keys (not for password storage —
      ## see `hashUserPassword`).
      let salt = utils.fromHex(saltHex)
      if salt.len == 0 or iters <= 0 or outLen <= 0 or outLen > 1024:
        raise newException(CatchableError,
          "nimcrypto: invalid deriveKey parameters")
      utils.toHex(pbkdf2(sha256, password, salt, iters, outLen), true)

    proc generateKey*(): array[32, byte] =
      ## Fresh 256-bit key for `encryptData`/`decryptData`
      ## and `encryptDataCbc`/`decryptDataCbc`
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

    proc encryptDataCbc*(plainText: string, key: array[32, byte]): string =
      ## AES-256-CBC encryption under `key` with PKCS#7 padding.
      ## Returns raw bytes as a string laid out as `iv(16) & ciphertext`
      ## with a fresh random IV per call. Prefer `encryptData` (GCM)
      ## for new code; CBC fits DB/blob fields.
      var iv: array[16, byte]
      if randomBytes(iv) != iv.len:
        raise newException(CatchableError, "nimcrypto: CSPRNG failure")
      let input = pkcs7Pad(strToBytes(plainText), aesBlockLen)
      var output = newSeq[byte](input.len)
      var ctx: CBC[aes256]
      ctx.init(key, iv)
      ctx.encrypt(input, output)
      ctx.clear()
      bytesToStr(iv) & bytesToStr(output)

    proc decryptDataCbc*(cipherText: string, key: array[32, byte]): string =
      ## Decrypts an `encryptDataCbc` payload. Raises `CatchableError`
      ## on truncated/misaligned input or invalid padding (no padding
      ## oracle detail is leaked).
      if cipherText.len < 2 * aesBlockLen or
          cipherText.len mod aesBlockLen != 0:
        raise newException(CatchableError,
          "nimcrypto: ciphertext too short")
      let iv = strToBytes(cipherText[0 ..< aesBlockLen])
      let input = strToBytes(cipherText[aesBlockLen .. ^1])
      var output = newSeq[byte](input.len)
      var ctx: CBC[aes256]
      ctx.init(key, iv)
      ctx.decrypt(input, output)
      ctx.clear()
      bytesToStr(pkcs7Unpad(output))
