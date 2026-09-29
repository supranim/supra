# QR code encoding via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/qr` surface is
# available (`encodeQr`, `toSvg`/`toTerminal`, `makeWifi`/`makeUrl`).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/qr`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_qr`.
import pkg/openparser/qr
export qr
