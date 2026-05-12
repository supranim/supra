# Package

version       = "0.1.0"
author        = "Supranim"
description   = "CLI tool for managing Supranim projects"
license       = "MIT"
srcDir        = "src"
bin           = @["supra"]
binDir        = "bin"

# Dependencies

requires "nim >= 2.0.0"
requires "db_connector"
requires "openparser"
requires "supranim"
requires "kapsis"
requires "flatty"
requires "valido"
requires "ozark"