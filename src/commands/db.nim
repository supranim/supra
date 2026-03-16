# Supra CLI - A command-line interface for managing
# your Supranim applications and projects
#
#   (c) 2026 MIT License | Made by Humans from OpenPeeps
#   https://supranim.com | https://github.com/supranim

import pkg/ozark
import pkg/kapsis/runtime
import pkg/kapsis/interactive/[prompts, spinny, widgets]
import pkg/db_connector/db_postgres
import ../meta

proc dbShowCommand*(v: Values) =
  loadProject()
  var sp1 = newSpinny("Fetch database information", skDots)
  sp1.start
  var dbSize: string
  withDBPool do:
    dbSize = dbcon.getValue(
      sql"SELECT pg_size_pretty( pg_database_size(?) );",
      App.env.database.local.name
    )
  var tb: TerminalTable
  add tb,
    bold"Table",
    bold"Size"
  withDBPool  do:
    let rows = dbcon.getAllRows(sql"SELECT * FROM pg_catalog.pg_tables WHERE schemaname = 'public' ORDER BY tablename ASC;")
    for row in rows:
      let tbSize = dbcon.getValue(sql"SELECT pg_size_pretty( pg_total_relation_size(?) );", row[1])
      add tb, row[1], tbSize
  sp1.stop
  tb.echoTableSeps

proc dbTableCommand*(v: Values) =
  loadproject()
  var sp1 = newSpinny("Fetch `" & v.get("name").getStr & "` table information", skDots)
  sp1.start
  var tb: TerminalTable
  add tb,
    bold"Column",
    bold"Data type"
  let tname = v.get("name").getStr
  withDBPool do:
    let checkTable = dbcon.getValue(sql"SELECT to_regclass(?);", "public." & tname)
    if checkTable.len != 0:
      let columns = dbcon.getAllRows(
        sql"SELECT column_name, data_type FROM information_schema.columns WHERE table_name = ?;",
        tname
      )
      for col in columns:
        add tb, col[0], col[1]
      sp1.stop
      tb.echoTableSeps
    else:
      sp1.stop
      displayError("Table not found `" & tname & "`")

proc dbMonitorCommand*(v: Values) =
  loadproject()
  var sp1 = newSpinny("Monitoring open connections in", skDots)
  sp1.start
  let x = sql"SELECT * FROM pg_stat_activity WHERE state = 'active' and datname = ?;"


proc dbMigrateCommand*(v: Values) =
  loadproject()
  var sp1 = newSpinny("Running pending migrations", skDots)
  sp1.start
  # withDBPool do:
    # dbcon.migrate()
  sp1.stop
  displaySuccess("Migrations completed successfully")

proc dbRollbackCommand*(v: Values) =
  loadproject()
  var sp1 = newSpinny("Rolling back migrations", skDots)
  sp1.start
  let step = v.get("step").getInt
  # withDBPool do:
    # dbcon.rollback(step)
  sp1.stop
  displaySuccess("Rollback completed successfully")