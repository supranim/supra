# Fast Binary Encoding via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/fbe` surface is
# available (`encode`/`encodeFinal`, `decode`/`decodeFinal`,
# `initBuffer`). Buffer-centric binary codec, no string/file API.
#
# Enabled via `supra init <project> --restapi` recipe `openparser/fbe`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_fbe`.
import pkg/openparser/fbe
export fbe
