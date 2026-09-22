# Password strength provider via https://github.com/openpeeps/blackpaper
#
# Singleton service holding a prepared common-password dictionary
# for fuzzy matching. Configure via `config/blackpaper.yml`.
#
# Enabled via `supra init <project> --restapi` recipe `blackpaper`.
# Import this provider from your controllers with
# `import ../service/provider/blackpaper`.
import std/[os, strutils]
import pkg/supranim/core/[services, application]
import pkg/blackpaper
export blackpaper

initService Blackpaper[Singleton]:
  description = "Password strength validation service"

  state do:
    type Blackpaper = ref object
      dict: PasswordStrengthDictionary

  api do:
    proc getBlackpaper*(): ptr Blackpaper =
      ## Returns the Singleton instance of the Blackpaper service
      getBlackpaperInstance(
        proc(instance: ptr Blackpaper) =
          {.gcsafe.}:
            new(instance[])
            instance[].dict = preparePasswordStrengthDictionary(@[])
      )

    proc init*(dictPath = "") =
      ## Inits the service from `config/blackpaper.yml`. `dictionary`
      ## points to a wordlist file (one password per line); empty means
      ## complexity-only checks without fuzzy matching. An explicit
      ## `dictPath` argument wins over the configuration file.
      var path = if dictPath.len > 0: dictPath
                 else: App.config("blackpaper.dictionary").getStr
      path = path.strip()
      if path.len == 0:
        return
      if not fileExists(path):
        raise newException(IOError,
          "Blackpaper: dictionary file not found `" & path & "` " &
          "(see config/blackpaper.yml)")
      let minLen = App.config("blackpaper.minTokenLen").getInt
      let maxDelta = App.config("blackpaper.maxLenDelta").getInt
      getBlackpaper().dict = preparePasswordStrengthDictionary(
        readFile(path).splitLines(),
        minTokenLen = if minLen > 0: minLen.int else: 3,
        maxLenDelta = maxDelta.int)

    proc checkPassword*(password: string): PasswordStrengthResult =
      ## Strength check using the Singleton dictionary when loaded,
      ## otherwise complexity-only scoring
      let dict = getBlackpaper().dict
      if dict.isNil or dict.entries.len == 0:
        passwordStrength(password)
      else:
        passwordStrength(password, dict)

    proc isStrongPassword*(password: string): bool =
      ## Returns true when `password` rates `Strong`
      checkPassword(password).strength == Strong
