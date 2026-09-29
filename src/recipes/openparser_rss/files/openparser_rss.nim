# RSS parsing via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/rss` surface is
# available (`parseRss`, `readRss`, `fetchRss`, `toRssXml`).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/rss`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_rss`.
import pkg/openparser/rss
export rss
