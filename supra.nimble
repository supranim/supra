# Package

version       = "0.1.0"
author        = "Supranim"
description   = "CLI tool for managing Supranim projects"
license       = "MIT"
srcDir        = "src"
bin           = @["supra"]
# binDir        = "bin"

# Dependencies

requires "nim >= 2.0.0"
requires "db_connector >= 0.1.0"
requires "openparser >= 0.1.2"
requires "kapsis >= 0.3.4"
requires "flatty >= 0.4.0"
requires "valido >= 0.1.0"
requires "ozark >= 0.1.4"