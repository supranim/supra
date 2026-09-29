# Atom feed parsing via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/feed` surface is
# available (`parseAtom`, `readAtom`, `fetchAtom`, `toAtomXml`).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/feed`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_feed`.
import pkg/openparser/feed
export feed
