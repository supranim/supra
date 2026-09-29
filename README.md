<p align="center">
  Supra is the CLI tool for creating new Supranim projects and managing them!<br>
</p>

<p align="center">
  <code>nimble install supra</code>
</p>

<p align="center">
  <a href="https://github.com/">API reference</a><br>
  <img src="https://github.com/supranim/supra/workflows/test/badge.svg" alt="Github Actions">  <img src="https://github.com/supranim/supra/workflows/docs/badge.svg" alt="Github Actions">
</p>

## 😍 Key Features
- [x] Bootstrap new Supranim projects with a single command
- [x] Download and extract starter template from GitHub
- [ ] Interactive prompts for project configuration (name, author, license)
- [ ] Start customizable project templates
- [ ] Start versioned project templates (e.g. with specific versions of dependencies)
- [x] Written in Nim language

### Create a new project

Initialize a new Supranim project from a starter template hosted on GitHub, the default
template is the official [Starter Kit](https://github.com/supranim/app) available on the `main` branch.
```bash
supra init my-new-app
```

### Create a new REST API project

Use the `--restapi` flag to bootstrap from the
[REST API Starter Kit](https://github.com/supranim/starterkit-api).
You'll get an interactive checkbox prompt to pick YAML-based recipes
(`Space` to toggle, `Enter` to confirm). Each recipe adds its
`.nimble` dependencies, drops a service provider into
`src/service/provider/`, and — for stateful providers only — wires
an `init` line into `App.services`. Stateless `Global` providers
(`nimcypher`, `brotli`, `bag`, `multipart`, `nimcrypto`, `e2ee`,
`nimsodium`, `zippy`, `zlib`) need no `init` call.
```bash
supra init my-new-api --restapi
```

Available recipes: `jose`, `nimcypher`, `brotli`, `mimedb`, `bag`,
`blackpaper`, `multipart`, `ozark`, `ormin`, `norm`,
`nimcrypto`, `e2ee`, `nimsodium`, `zippy`, `zlib`, `flysystem`.

Providers are real Supranim services: most use `initService X[Global]`
with a high-level `api` (`jose.issueToken/verifyToken`,
`nimcypher.hashUserPassword/checkUserPassword`, `brotli.compressText`,
`mimedb.mimeTypeFor`, `multipart.parseUpload`,
`nimcrypto.hashUserPassword/checkUserPassword` (PBKDF2 + scrypt) and
`nimcrypto.encryptData/decryptData` (AES-256-GCM) plus
`encryptDataCbc/decryptDataCbc`, full `*Hex` hash coverage
(SHA-1/2, RIPEMD-160, SHA-3, BLAKE2), `hmacHex`, `deriveKey`,
`randomHex/randomToken` and `constantTimeEqual`,
`e2ee` (Argon2id passwords, AEAD seal/unseal, BLAKE2b over Monocypher),
`nimsodium` (libsodium passwords, secretbox, hashing),
`zippy.compressData/decompressData`, `zlib.compressData/decompressData`,
`norm` validates `DB_*` env and offers `withNormDb`,
`ormin` owns a global sqlite `db` for `query:` blocks).
`flysystem` is a `Flysystem[Global]` owning a multi-disk file
registry (`putFile/getFile/hasFile/deleteFile/listFiles`,
plus `addLocalDisk`/`getDisk` for extra disks; run
`flysystem.init()` after the base providers).
`blackpaper` is a `Blackpaper[Singleton]` holding a prepared
dictionary (`checkPassword/isStrongPassword`), and `ozark` is an
`Ozark[Singleton]` over Ozark's internal pool singleton that prepares
tables (it also scaffolds `src/model/user.nim`; run `ozark.init()`
after the base `db.init()`). Like ozark, the other two database
recipes ship a model example: `ormin` adds
`src/service/database/schema.sql` (import it with `importModel`),
`norm` adds `src/model/account.nim`.
`jose` and `blackpaper` also ship `config/jose.yml`
(`secret` supports `${env.JWT_SECRET}` refs) and
`config/blackpaper.yml` (wordlist `dictionary` path) respectively.
`flysystem` ships `config/flysystem.yml` (`default` disk name plus
the `local_root` storage path).

For non-interactive use (CI), select recipes with the flag instead:
```bash
supra init my-new-api --restapi --skipconfig --with=jose,bag,blackpaper
```

### ❤ Contributions & Support
- 🐛 Found a bug? [Create a new Issue](https://github.com/supranim/supra/issues)
- 👋 Wanna help? [Fork it!](https://github.com/supranim/supra/fork)

### 🎩 License
Supranim | MIT license. [Made by Humans from OpenPeeps](https://github.com/openpeeps).<br>
Copyright &copy; 2025 OpenPeeps & Contributors &mdash; All rights reserved.
