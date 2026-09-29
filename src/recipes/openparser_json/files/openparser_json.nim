# JSON parsing and serialization via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/json` surface is
# available (`fromJson`/`fromJsonFile`, `toJson`/`toJsonNode`).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/json`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_json`.
import pkg/openparser/json
export json
