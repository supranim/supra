# vCard contacts via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/vcard` surface is
# available (`parseVCard`/`parseVCards` plus `File` variants,
# `toVCard`/`toVCards`, `toQrPayload`).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/vcard`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_vcard`.
import pkg/openparser/vcard
export vcard
