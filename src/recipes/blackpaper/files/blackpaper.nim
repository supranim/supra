# Password strength provider via https://github.com/openpeeps/blackpaper
#
# Enabled via `supra init <project> --restapi` recipe `blackpaper`.
import pkg/blackpaper
export blackpaper

proc init*() =
  ## Strength validation provider (stateless, nothing to configure)
  discard

proc isStrongPassword*(password: string): bool =
  ## Returns true when `password` rates `Strong`
  passwordStrength(password).strength == Strong
