# This is Supra a cool CLI application for managing
# web apps made with Supranim
#   (c) 2024 MIT License | Made by Humans from OpenPeeps
#   https://supranim.com | https://github.com/supranim

import kapsis/app
import ./commands/init

commands:
  -- "Development"
  init string(project), ?bool(--nocache):
    ## Create a new Supranim application
    ? app   "Create a new web app"
    ? rest  "Create a new REST API microservice"
    
