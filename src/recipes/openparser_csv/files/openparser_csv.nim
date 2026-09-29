# Zero-copy CSV parsing via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/csv` surface is
# available (`parseCsv`/`parseFile` with row callbacks, `toString`).
# Parse-only; there is no CSV dump API.
#
# Enabled via `supra init <project> --restapi` recipe `openparser/csv`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_csv`.
import pkg/openparser/csv
export csv
