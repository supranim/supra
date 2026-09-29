# Regex matching via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/regex` surface is
# available (`re`/`compile`, `match`/`find`/`findAll`, `groupStr`).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/regex`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_regex`.
import pkg/openparser/regex
export regex
