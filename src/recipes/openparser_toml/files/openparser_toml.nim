# TOML parsing and dumping via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/toml` surface is
# available (`parseTOML`, `dumpTOML`, `fromToml`).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/toml`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_toml`.
import pkg/openparser/toml
export toml
