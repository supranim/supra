# Supra CLI - A command-line interface for managing
# your Supranim applications and projects
#
#   (c) 2026 MIT License | Made by Humans from OpenPeeps
#   https://supranim.com | https://github.com/supranim

import std/[os, tables, times]
import pkg/[nyml, ozark]
import pkg/kapsis/cli

from std/net import Port

type
  DatabaseType* = enum
    postgres = "postgres"
    # todo sqlite = "sqlite"
  
  DBCredentials* = ref object
    user*, name*, password*: string
    port*: Port

  EnvDatabase = ref object
    `type`*: DatabaseType
    local*, prod*: DBCredentials

  Env = ref object
    database*: EnvDatabase

  Config = OrderedTableRef[string, JsonNode]
  Configs = ref object
    configs: OrderedTableRef[string, Config] = newOrderedTable[string, Config]()
    lastModified: Time
  Application = ref object
    env*: Env
    config*: Configs

var App* = Application()

let
  suprapath = getCurrentDir() / "supra.yml"
  envpath = getCurrentDir() / ".env.yml"
  configpath = getCurrentDir() / "src" / "config"

proc loadDatabase* =
  ozark.initOzarkDatabase(
    address = "localhost",
    name = App.env.database.local.name,
    user = App.env.database.local.user,
    password = App.env.database.local.password,
    port = App.env.database.local.port
  )
  initOzarkPool(2)

proc loadProject* =
  ## Initializes a supranim project found at
  ## the working directory path
  if fileExists(envpath):
    # read `.env.yml` file
    try:
      App.env = fromYaml(readFile(envpath), Env)
    except YAMLException as e:
      displayError(e.msg)
      quit(1)
  else:
    displayError("Could not find `.env.yml` file")
    quit(1)
  if dirExists(configpath):
    # read `.yml` configuration files
    App.config = Configs(lastModified: configpath.getLastModificationTime)
    for y in walkPattern(configpath / "*.yml"):
      try:
        let conf: Config = fromYaml(readFile(y), Config)
        App.config.configs[y.splitFile.name] = conf
      except YAMLException as e:
        displayError(e.msg)
        quit(1)
  loadDatabase()


template withCurrentProject*(body): untyped =
  ## Ensures that the current working directory is a valid Supranim project
  body

const
  supranimBaseDir* = getHomeDir() / ".supranim"
  supranimTemplateDir* = supranimBaseDir / "starters"

template withSupranimEnv*(body): untyped =
  ## Creates the Supranim home directory at ~/.supranim
  ## It is used to store global configuration and other files.
  discard existsOrCreateDir(supranimBaseDir)
  discard existsOrCreateDir(supranimTemplateDir)
  body