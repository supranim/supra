# Supra CLI - YAML recipe system for REST API projects
#
#   (c) 2026 MIT License | Made by Humans from OpenPeeps
#   https://supranim.com | https://github.com/supranim
#
# Recipes are well-known YAML documents embedded in the supra binary.
# Each recipe declares `.nimble` dependencies plus files that get
# added to the generated application (usually a service provider),
# and a single `init` line wired into the `App.services` block.

import std/[os, strutils, sequtils]
import pkg/openparser/yaml
import pkg/kapsis/interactive/prompts

type
  RecipeFile* = ref object
    dest*: string
    source*: string

  Recipe* = ref object
    name*: string
    label*: string
    description*: string
    url*: string
    requires*: seq[string]
    files*: seq[RecipeFile]
    init*: string

const
  recipeNames* = ["jose", "nimcypher", "brotli", "mimedb", "bag",
                   "blackpaper", "multipart", "ozark", "ormin", "norm",
                   "nimcrypto", "e2ee", "nimsodium", "zippy", "zlib",
                   "openparser/json", "openparser/yaml", "openparser/toml",
                   "openparser/xml", "openparser/csv", "openparser/bson",
                   "openparser/fbe", "openparser/html", "openparser/feed",
                   "openparser/rss", "openparser/ical", "openparser/dotenv",
                   "openparser/fuzzy", "openparser/path", "openparser/plist",
                   "openparser/uuid", "openparser/vcard", "openparser/css",
                   "openparser/colors", "openparser/qr", "openparser/regex",
                   "openparser/svg"]

  joseYml = staticRead("../recipes/jose/recipe.yml")
  nimcypherYml = staticRead("../recipes/nimcypher/recipe.yml")
  brotliYml = staticRead("../recipes/brotli/recipe.yml")
  mimedbYml = staticRead("../recipes/mimedb/recipe.yml")
  bagYml = staticRead("../recipes/bag/recipe.yml")
  blackpaperYml = staticRead("../recipes/blackpaper/recipe.yml")
  multipartYml = staticRead("../recipes/multipart/recipe.yml")
  ozarkYml = staticRead("../recipes/ozark/recipe.yml")
  orminYml = staticRead("../recipes/ormin/recipe.yml")
  normYml = staticRead("../recipes/norm/recipe.yml")
  nimcryptoYml = staticRead("../recipes/nimcrypto/recipe.yml")
  e2eeYml = staticRead("../recipes/e2ee/recipe.yml")
  nimsodiumYml = staticRead("../recipes/nimsodium/recipe.yml")
  zippyYml = staticRead("../recipes/zippy/recipe.yml")
  zlibYml = staticRead("../recipes/zlib/recipe.yml")
  openparserJsonYml = staticRead("../recipes/openparser_json/recipe.yml")
  openparserYamlYml = staticRead("../recipes/openparser_yaml/recipe.yml")
  openparserTomlYml = staticRead("../recipes/openparser_toml/recipe.yml")
  openparserXmlYml = staticRead("../recipes/openparser_xml/recipe.yml")
  openparserCsvYml = staticRead("../recipes/openparser_csv/recipe.yml")
  openparserBsonYml = staticRead("../recipes/openparser_bson/recipe.yml")
  openparserFbeYml = staticRead("../recipes/openparser_fbe/recipe.yml")
  openparserHtmlYml = staticRead("../recipes/openparser_html/recipe.yml")
  openparserFeedYml = staticRead("../recipes/openparser_feed/recipe.yml")
  openparserRssYml = staticRead("../recipes/openparser_rss/recipe.yml")
  openparserIcalYml = staticRead("../recipes/openparser_ical/recipe.yml")
  openparserDotenvYml = staticRead("../recipes/openparser_dotenv/recipe.yml")
  openparserFuzzyYml = staticRead("../recipes/openparser_fuzzy/recipe.yml")
  openparserPathYml = staticRead("../recipes/openparser_path/recipe.yml")
  openparserPlistYml = staticRead("../recipes/openparser_plist/recipe.yml")
  openparserUuidYml = staticRead("../recipes/openparser_uuid/recipe.yml")
  openparserVcardYml = staticRead("../recipes/openparser_vcard/recipe.yml")
  openparserCssYml = staticRead("../recipes/openparser_css/recipe.yml")
  openparserColorsYml = staticRead("../recipes/openparser_colors/recipe.yml")
  openparserQrYml = staticRead("../recipes/openparser_qr/recipe.yml")
  openparserRegexYml = staticRead("../recipes/openparser_regex/recipe.yml")
  openparserSvgYml = staticRead("../recipes/openparser_svg/recipe.yml")

  joseProvider = staticRead("../recipes/jose/files/jose.nim")
  nimcypherProvider = staticRead("../recipes/nimcypher/files/nimcypher.nim")
  brotliProvider = staticRead("../recipes/brotli/files/brotli.nim")
  mimedbProvider = staticRead("../recipes/mimedb/files/mimedb.nim")
  bagProvider = staticRead("../recipes/bag/files/bag.nim")
  blackpaperProvider = staticRead("../recipes/blackpaper/files/blackpaper.nim")
  multipartProvider = staticRead("../recipes/multipart/files/multipart.nim")
  ozarkProvider = staticRead("../recipes/ozark/files/ozark.nim")
  ozarkUserModel = staticRead("../recipes/ozark/files/user.nim")
  orminProvider = staticRead("../recipes/ormin/files/ormin.nim")
  normProvider = staticRead("../recipes/norm/files/norm.nim")
  orminSchema = staticRead("../recipes/ormin/files/schema.sql")
  normAccountModel = staticRead("../recipes/norm/files/account.nim")
  nimcryptoProvider = staticRead("../recipes/nimcrypto/files/nimcrypto.nim")
  e2eeProvider = staticRead("../recipes/e2ee/files/e2ee.nim")
  nimsodiumProvider = staticRead("../recipes/nimsodium/files/nimsodium.nim")
  zippyProvider = staticRead("../recipes/zippy/files/zippy.nim")
  zlibProvider = staticRead("../recipes/zlib/files/zlib.nim")
  openparserJsonProvider = staticRead("../recipes/openparser_json/files/openparser_json.nim")
  openparserYamlProvider = staticRead("../recipes/openparser_yaml/files/openparser_yaml.nim")
  openparserTomlProvider = staticRead("../recipes/openparser_toml/files/openparser_toml.nim")
  openparserXmlProvider = staticRead("../recipes/openparser_xml/files/openparser_xml.nim")
  openparserCsvProvider = staticRead("../recipes/openparser_csv/files/openparser_csv.nim")
  openparserBsonProvider = staticRead("../recipes/openparser_bson/files/openparser_bson.nim")
  openparserFbeProvider = staticRead("../recipes/openparser_fbe/files/openparser_fbe.nim")
  openparserHtmlProvider = staticRead("../recipes/openparser_html/files/openparser_html.nim")
  openparserFeedProvider = staticRead("../recipes/openparser_feed/files/openparser_feed.nim")
  openparserRssProvider = staticRead("../recipes/openparser_rss/files/openparser_rss.nim")
  openparserIcalProvider = staticRead("../recipes/openparser_ical/files/openparser_ical.nim")
  openparserDotenvProvider = staticRead("../recipes/openparser_dotenv/files/openparser_dotenv.nim")
  openparserFuzzyProvider = staticRead("../recipes/openparser_fuzzy/files/openparser_fuzzy.nim")
  openparserPathProvider = staticRead("../recipes/openparser_path/files/openparser_path.nim")
  openparserPlistProvider = staticRead("../recipes/openparser_plist/files/openparser_plist.nim")
  openparserUuidProvider = staticRead("../recipes/openparser_uuid/files/openparser_uuid.nim")
  openparserVcardProvider = staticRead("../recipes/openparser_vcard/files/openparser_vcard.nim")
  openparserCssProvider = staticRead("../recipes/openparser_css/files/openparser_css.nim")
  openparserColorsProvider = staticRead("../recipes/openparser_colors/files/openparser_colors.nim")
  openparserQrProvider = staticRead("../recipes/openparser_qr/files/openparser_qr.nim")
  openparserRegexProvider = staticRead("../recipes/openparser_regex/files/openparser_regex.nim")
  openparserSvgProvider = staticRead("../recipes/openparser_svg/files/openparser_svg.nim")

  joseConfig = staticRead("../recipes/jose/files/jose.yml")
  blackpaperConfig = staticRead("../recipes/blackpaper/files/blackpaper.yml")

proc recipeContent*(name, source: string): string =
  ## Returns the embedded content of a recipe file
  case source
  of "jose.nim": result = joseProvider
  of "nimcypher.nim": result = nimcypherProvider
  of "brotli.nim": result = brotliProvider
  of "mimedb.nim": result = mimedbProvider
  of "bag.nim": result = bagProvider
  of "blackpaper.nim": result = blackpaperProvider
  of "multipart.nim": result = multipartProvider
  of "jose.yml": result = joseConfig
  of "blackpaper.yml": result = blackpaperConfig
  of "ozark.nim": result = ozarkProvider
  of "user.nim": result = ozarkUserModel
  of "ormin.nim": result = orminProvider
  of "norm.nim": result = normProvider
  of "schema.sql": result = orminSchema
  of "account.nim": result = normAccountModel
  of "nimcrypto.nim": result = nimcryptoProvider
  of "e2ee.nim": result = e2eeProvider
  of "nimsodium.nim": result = nimsodiumProvider
  of "zippy.nim": result = zippyProvider
  of "zlib.nim": result = zlibProvider
  of "openparser_json.nim": result = openparserJsonProvider
  of "openparser_yaml.nim": result = openparserYamlProvider
  of "openparser_toml.nim": result = openparserTomlProvider
  of "openparser_xml.nim": result = openparserXmlProvider
  of "openparser_csv.nim": result = openparserCsvProvider
  of "openparser_bson.nim": result = openparserBsonProvider
  of "openparser_fbe.nim": result = openparserFbeProvider
  of "openparser_html.nim": result = openparserHtmlProvider
  of "openparser_feed.nim": result = openparserFeedProvider
  of "openparser_rss.nim": result = openparserRssProvider
  of "openparser_ical.nim": result = openparserIcalProvider
  of "openparser_dotenv.nim": result = openparserDotenvProvider
  of "openparser_fuzzy.nim": result = openparserFuzzyProvider
  of "openparser_path.nim": result = openparserPathProvider
  of "openparser_plist.nim": result = openparserPlistProvider
  of "openparser_uuid.nim": result = openparserUuidProvider
  of "openparser_vcard.nim": result = openparserVcardProvider
  of "openparser_css.nim": result = openparserCssProvider
  of "openparser_colors.nim": result = openparserColorsProvider
  of "openparser_qr.nim": result = openparserQrProvider
  of "openparser_regex.nim": result = openparserRegexProvider
  of "openparser_svg.nim": result = openparserSvgProvider
  else:
    displayError("Unknown recipe file `" & name & "/" & source & "`", true)

proc loadRecipes*(): seq[Recipe] =
  ## Parses the embedded YAML recipes directly to Nim objects via openparser
  for raw in [joseYml, nimcypherYml, brotliYml, mimedbYml,
               bagYml, blackpaperYml, multipartYml,
               ozarkYml, orminYml, normYml,
               nimcryptoYml, e2eeYml, nimsodiumYml,
               zippyYml, zlibYml,
               openparserJsonYml, openparserYamlYml, openparserTomlYml,
               openparserXmlYml, openparserCsvYml, openparserBsonYml,
               openparserFbeYml, openparserHtmlYml, openparserFeedYml,
               openparserRssYml, openparserIcalYml, openparserDotenvYml,
               openparserFuzzyYml, openparserPathYml, openparserPlistYml,
               openparserUuidYml, openparserVcardYml, openparserCssYml,
               openparserColorsYml, openparserQrYml, openparserRegexYml,
               openparserSvgYml]:
    try:
      result.add(parseYaml(raw, Recipe))
    except OpenParserYamlError as e:
      displayError("Invalid embedded recipe: " & e.msg, true)

proc depName(dep: string): string =
  ## Returns the package name from a `requires` spec
  ## e.g. `jose >= 0.1.0` -> `jose`
  result = dep.strip().split({' ', '\t', '[', '@'})[0]

proc hasDep(lines: seq[string], name: string): bool =
  for line in lines:
    let t = line.strip()
    if t.startsWith("requires"):
      let first = t.find('"')
      let last = t.rfind('"')
      if first >= 0 and last > first:
        if depName(t[first + 1 ..< last]) == name:
          return true
  false

proc findNimbleFile(projectPath: string): string =
  for kind, path in walkDir(projectPath):
    if kind == pcFile and path.endsWith(".nimble"):
      return path
  displayError("Could not find a `.nimble` file in `" & projectPath & "`", true)
  ""

proc findServicesFile(projectPath: string): string =
  ## Finds the generated app file holding the `App.services` block
  let srcDir = projectPath / "src"
  if dirExists(srcDir):
    for kind, path in walkDir(srcDir):
      if kind == pcFile and path.endsWith(".nim"):
        if "App.services" in readFile(path):
          return path
  displayError("Could not find the `App.services` file in `" & projectPath & "`", true)
  ""

proc applyRecipe*(projectPath: string, recipe: Recipe) =
  ## Applies a recipe: appends `.nimble` deps, writes files,
  ## and wires the `init` line into the `App.services` block
  let nimblePath = findNimbleFile(projectPath)
  var nimbleLines = readFile(nimblePath).splitLines()
  for dep in recipe.requires:
    if not hasDep(nimbleLines, depName(dep)):
      nimbleLines.add("requires \"" & dep.strip() & "\"")
  writeFile(nimblePath, nimbleLines.join("\n"))

  for f in recipe.files:
    let dest = projectPath / f.dest
    createDir(parentDir(dest))
    writeFile(dest, recipeContent(recipe.name, f.source))

  if recipe.init.len > 0:
    let servicesPath = findServicesFile(projectPath)
    var srcLines = readFile(servicesPath).splitLines()
    if ("  " & recipe.init.strip()) notin srcLines.mapIt(it.strip()):
      var injected = false
      for i, line in srcLines:
        if "initialize your service providers here" in line:
          srcLines.insert("  " & recipe.init.strip(), i)
          injected = true
          break
      if not injected:
        displayError("Could not wire `" & recipe.name & "` into `App.services`", true)
      writeFile(servicesPath, srcLines.join("\n"))

proc filterRecipes*(all: seq[Recipe], withFlag: string): seq[Recipe] =
  ## Resolves the `--with` comma-separated recipe names
  let wanted = withFlag.split(',').mapIt(it.strip().toLowerAscii()).filterIt(it.len > 0)
  for name in wanted:
    let hit = all.filterIt(it.name == name)
    if hit.len == 0:
      displayError("Unknown recipe `" & name & "`. Available: " &
        all.mapIt(it.name).join(", "), true)
    result.add(hit[0])
