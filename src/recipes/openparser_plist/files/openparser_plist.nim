# Apple plist via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/plist` surface is
# available (`parsePlist`, `parseXmlPlist`/`parseBPlist` plus `File`
# variants, `toXmlPlist`/`toBPlist`, `detectPlistFormat`).
# The DOM is `JsonNode`.
#
# Enabled via `supra init <project> --restapi` recipe `openparser/plist`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_plist`.
import pkg/openparser/plist
export plist
