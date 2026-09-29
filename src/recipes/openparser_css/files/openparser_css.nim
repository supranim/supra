# CSS parsing and validation via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/css` surface is
# available (`parseCss`, `validate`, `toString`, `loadCssData`).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/css`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_css`.
import pkg/openparser/css
export css
