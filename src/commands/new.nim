# Supra CLI - A command-line interface for managing
# your Supranim applications and projects
#
#   (c) 2026 MIT License | Made by Humans from OpenPeeps
#   https://supranim.com | https://github.com/supranim

import std/os
import kapsis/[runtime, cli]
import supranim/core/paths

import ../meta

export newproject

proc newCommand*(v: Values) =
  echo "a root command"

proc controllerCommand*(v: Values) =
  ## Command to create a new controller in the current project

proc databaseCommand*(v: Values) =
  echo "a sub command"

proc modelCommand*(v: Values) =
  ## Command to create a new model in the current project
  withCurrentProject:
    let modelName = prompt("Model name")
    if modelName.len == 0:
      displayError("Model name cannot be empty.", true)
    let modelFilePath = getCurrentDir() / "src" / "models" / modelName & ".nim"
    if fileExists(modelFilePath):
      displayError("A model with the name '" & modelName & "' already exists.", true)
    let modelTemplate = "import supranim/model"

proc middlewareCommand*(v: Values) =
  echo "a sub command"

proc restCommand*(v: Values) =
  echo "a sub command"

proc serviceCommand*(v: Values) =
  echo "service command"