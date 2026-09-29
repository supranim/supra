import std/[json, times, os]
import pkg/kapsis/runtime
import pkg/kapsis/interactive/prompts
import pkg/supranim/support/nanoid
import pkg/[enimsql, valido/email]
import pkg/libsodium/[sodium, sodium_sizes]

import ../meta

proc userCommand*(v: Values) =
  ## Create a new user account. Use `--invite` flag
  ## to send the credentials to the given email address.
  ## This works only if your Supranim application has
  ## already a SMTP service setup. See `config/smtp.yml`
  loadProject()
  displayInfo("Create a new user account")
  # ask for email
  var email = askEmail("Type email address", "test@example.com")
  # generate random password
  var sp1 = newSpinny("Generating password hash...", skDots)
  sp1.start
  let pass = nanoid.generate(size = 16)
  let hash = crypto_pwhash_str(pass)
  sp1.stop
  # connect to default database
  # and insert the new user account
  var sp2 = newSpinny("Connecting to database...", skDots)
  sp2.start
  try:
    withDB:
      let x =
        Models.table("users")
              .insert(
                ("name", "George Lemon"),
                ("email", email),
                ("password", pass),
                ("hash", hash),
                ("created_at", $now())
              )
      echo x
  except DbError as e:
    sp2.stop()
    displayError(e.msg)
    quit(1)
  # display($user)