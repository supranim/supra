# SVG parsing and serialization via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/svg` surface is
# available (`parseSvg`/`parseSvgFile`, `toSvg`, `parsePathData`).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/svg`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_svg`.
import pkg/openparser/svg
export svg
