# Package

version       = "0.1.0"
author        = "Supranim"
description   = "CLI tool for bootstrapping Supranim applications"
license       = "MIT"
srcDir        = "src"
bin           = @["supra"]
binDir        = "bin"

# Dependencies

requires "nim >= 2.0.2"
requires "kapsis"
requires "libsodium"
requires "flatty", "jsony", "nyml"
requires "db_connector"
requires "supranim"
requires "valido"
requires "ozark"

task dev, "Development build":
  exec "nimble build"

task prod, "Production build":
  exec "nimble build -d:release"