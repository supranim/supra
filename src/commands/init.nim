# Supra CLI - A command-line interface for managing
# your Supranim applications and projects
#
#   (c) 2026 MIT License | Made by Humans from OpenPeeps
#   https://supranim.com | https://github.com/supranim

import std/[httpclient, os, osproc, strformat, terminal, strutils]
import pkg/kapsis/runtime
import pkg/kapsis/interactive/prompts
import pkg/kapsis/interactive/[spinny, widgets]

import ../meta

const
  NimblePkgVersion {.strdefine.} = ""
  supranimStarterUrl* = "https://github.com/supranim/app/archive/refs/heads/main.zip"
  splashMessage = """
\x1b[36m _______ _______ ______ ______ _______ _______ _______ _______ 
|     __|   |   |   __ \   __ \   _   |    |  |_     _|   |   |
|__     |   |   |    __/      <       |       |_|   |_|       |
|_______|_______|___|  |___|__|___|___|__|____|_______|__|_|__|\x1b[0m
                                                        \x1b[90mv{NimblePkgVersion}\x1b[0m
                ⚡️ \x1b[36mThanks for trying Supranim!\x1b[0m
          Your new project is ready for development

\x1b[1;97mTo get started:\x1b[0m
1. Navigate to your project directory:
  cd {projectName}
2. Build the project:
  nimble build
3. Start the web server:
  cd build && ./app start .
  """

  # A list of common open source licenses for user selection during project creation.
  # This list can be expanded or modified as needed. The selected license will be used
  # to populate the license field in the generated project files.
  knownLicenses = @[
    "MIT",
    "Apache-2.0",
    "GPL-3.0",
    "GPL-2.0",
    "BSD-3-Clause",
    "BSD-2-Clause",
    "LGPL-3.0",
    "LGPL-2.1",
    "MPL-2.0",
    "AGPL-3.0",
    "EPL-2.0",
    "CC0-1.0",
    "Zlib",
    "Unlicense",
  ]
proc getSupranimDir*(x: string = ""): string =
  ## Returns the Supranim home directory path
  var supranimDir = supranimBaseDir
  if x.len > 0:
    supranimDir = joinPath(supranimDir, x)
  supranimDir

proc initCommand*(v: Values) =
  ## CLI command for creating a new Supranim project from a starter template.
  ## Usage: supra new project <projectName>
  withSupranimEnv do:
    let
      currDir = getCurrentDir()
      projectName = v.get("project").getStr
      projectPath = currDir / projectName

    if not projectName.validIdentifier:
      displayError("Project name must be a valid Nim identifier (alphanumeric and underscores, cannot start with a number).", true)

    if dirExists(projectPath) or fileExists(projectPath):
      displayError("A file or directory with the name '" & projectName & "' already exists in the current directory.", true)

    let gitUsername = execProcess("git config --get user.name").strip()
    let authorName = prompt("Author name", default = gitUsername)
    var licenseIndex = promptInteractive("Project license (MIT):", knownLicenses)
    let supraBinName = projectName # default binary name is the same as the project name

    if licenseIndex == -1:
      licenseIndex = 0 # default to MIT if no selection is made

    # Download the starter template zip (if not cached)
    # and extract it to the new project directory
    let
      client = newHttpClient()
      localZipPath = supranimTemplateDir / "app.zip"
    
    if not fileExists(localZipPath) or v.has("--nocache"):
      var loader = newSpinny("Downloading from remote source", skDots)
      loader.start()
      client.downloadFile(supranimStarterUrl, localZipPath)
      loader.success()

    # create the root project directory
    createDir(projectPath)
    
    # show a loading spinner while we set up the project
    var loader = newSpinny("Unzipping the starter template", skDots)
    loader.start()
    let unzipCmd =
      if findExe("unzip") != "":
        "unzip " & localZipPath & " -d " & projectPath
      elif findExe("7z") != "":
        "7z x " & localZipPath & " -o" & projectPath
      else:
        displayError("No suitable unzip utility found (requires 'unzip' or '7z').", true)
        quit(1)
    discard execProcess(unzipCmd)
    loader.success()

    # Move extracted files from the nested directory to the project root
    let extractedDir = projectPath / "app-main"
    if dirExists(extractedDir):
      for item in walkDir(extractedDir):
        var dest = projectPath / item.path.extractFileName
        if item.kind == pcFile:
          # if the file is app.nimble weill be renamed to projectName.nimble
          let filename = item.path.extractFileName
          if filename == "app.nimble":
            dest = projectPath / (projectName & ".nimble")
            moveFile(item.path, dest)
            let nimbleContent = readFile(dest) % [
              "supraAuthorNimble", authorName,
              "supraAuthorLicense", knownLicenses[licenseIndex],
              "supraBinName", supraBinName,
            ]
            writeFile(dest, readFile(dest))
          elif filename == ".env.sample.yml":
            copyFile(item.path, projectPath / ".env.yml")
          else:
            moveFile(item.path, dest)
        elif item.kind == pcDir:
          moveDir(item.path, dest)
      removeDir(extractedDir)

    # Once, done we can display a splash screen
    # with a few next steps to get started with the new project.
    terminal.eraseScreen()
    echo replace(fmt(splashMessage), "\\x1b", "\x1b")