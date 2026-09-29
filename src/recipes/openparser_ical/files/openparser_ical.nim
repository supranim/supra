# iCalendar RFC 5545 via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/ical` surface is
# available (`parseIcal`/`parseIcalFile`, `toIcal`,
# `parseIcalDateTime`/`formatIcalDateTime`).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/ical`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_ical`.
import pkg/openparser/ical
export ical
