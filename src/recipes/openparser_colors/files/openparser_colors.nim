# Color parsing and manipulation via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/colors` surface is
# available (`parseColor`, `toHex`/`toRgbString`, `lighten`/`darken`,
# `mix`, `contrastRatio`, `deltaE00`).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/colors`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_colors`.
import pkg/openparser/colors
export colors
