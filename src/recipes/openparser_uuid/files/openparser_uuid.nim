# UUID v1-v8 via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/uuid` surface is
# available (`newUuidV4`/`newUuidV7`, `parseUuid`, `isValidUuid`).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/uuid`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_uuid`.
import pkg/openparser/uuid
export uuid
