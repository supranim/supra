# Example Account model for the Norm recipe.
#
# Norm models are `ref object of Model` subtypes (`id` comes from
# the base type). The table is created with `db.createTables`:
#
#   withNormDb:
#     var accounts = @[Account(name: "alice", email: "a@x.io")]
#     db.createTables(accounts)
#
# See https://github.com/moigagoo/norm for relations, selects
# and transactions.
import norm/model

type
  Account* = ref object of Model
    name*: string
    email*: string
