# BSON documents via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/bson` surface is
# available (`encodeBson`/`decodeBson`, `toBson`/`fromBson`,
# `writeBSONDocument`/`openBSONDocument`). The DOM is `JsonNode`
# with Extended JSON (`$oid`, `$date`, `$binary`).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/bson`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_bson`.
import pkg/openparser/bson
export bson
