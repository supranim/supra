# Supra CLI - A command-line interface for managing
# your Supranim applications and projects
#
#   (c) 2026 MIT License | Made by Humans from OpenPeeps
#   https://supranim.com | https://github.com/supranim

import kapsis/framework
import ./commands/[init, db, bundle]

initKapsis do:
  commands:
    -- "Development"
    init string(project), ?bool("--nocache"):
      ## Create a new Supranim application
      
    db:
      ## Database management commands
      show:
        ## Show database information and table sizes
      table string(name):
        ## Show column information for a specific table
      monitor:
        ## Monitor active database connections in real-time
      migrate:
        ## Run pending migrations
      rollback int("--step"):
        ## Rollback to the previous migration batch
      
    bundle:
      assets string(dir), string(output):
        ## Bundle static assets into the application 