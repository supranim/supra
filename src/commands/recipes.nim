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
                  "blackpaper", "multipart"]

  joseYml = staticRead("../recipes/jose/recipe.yml")
  nimcypherYml = staticRead("../recipes/nimcypher/recipe.yml")
  brotliYml = staticRead("../recipes/brotli/recipe.yml")
  mimedbYml = staticRead("../recipes/mimedb/recipe.yml")
  bagYml = staticRead("../recipes/bag/recipe.yml")
  blackpaperYml = staticRead("../recipes/blackpaper/recipe.yml")
  multipartYml = staticRead("../recipes/multipart/recipe.yml")

  joseProvider = staticRead("../recipes/jose/files/jose.nim")
  nimcypherProvider = staticRead("../recipes/nimcypher/files/nimcypher.nim")
  brotliProvider = staticRead("../recipes/brotli/files/brotli.nim")
  mimedbProvider = staticRead("../recipes/mimedb/files/mimedb.nim")
  bagProvider = staticRead("../recipes/bag/files/bag.nim")
  blackpaperProvider = staticRead("../recipes/blackpaper/files/blackpaper.nim")
  multipartProvider = staticRead("../recipes/multipart/files/multipart.nim")

proc recipeContent*(name, source: string): string =
  ## Returns the embedded content of a recipe file
  case name
  of "jose": result = joseProvider
  of "nimcypher": result = nimcypherProvider
  of "brotli": result = brotliProvider
  of "mimedb": result = mimedbProvider
  of "bag": result = bagProvider
  of "blackpaper": result = blackpaperProvider
  of "multipart": result = multipartProvider
  else:
    displayError("Unknown recipe `" & name & "`", true)
  assert result.len > 0 and source.len > 0

proc loadRecipes*(): seq[Recipe] =
  ## Parses the embedded YAML recipes directly to Nim objects via openparser
  for raw in [joseYml, nimcypherYml, brotliYml, mimedbYml,
              bagYml, blackpaperYml, multipartYml]:
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

proc filterRecipes*(all: seq[Recipe], withFlag, withoutFlag: string): seq[Recipe] =
  ## Resolves `--with`/`--without` comma-separated recipe names
  var wanted = withFlag.split(',').mapIt(it.strip().toLowerAscii()).filterIt(it.len > 0)
  let excluded = withoutFlag.split(',').mapIt(it.strip().toLowerAscii()).filterIt(it.len > 0)
  if wanted.len == 0:
    wanted = all.mapIt(it.name)
  for name in wanted:
    if name notin excluded:
      let hit = all.filterIt(it.name == name)
      if hit.len == 0:
        displayError("Unknown recipe `" & name & "`. Available: " &
          all.mapIt(it.name).join(", "), true)
      result.add(hit[0])
