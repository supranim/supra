# HTML parsing via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/html` surface is
# available (`parseHtml`/`parseHtmlFile`, `innerText`, `getHtmlTag`).
# Parse-only; there is no HTML dump API.
#
# Enabled via `supra init <project> --restapi` recipe `openparser/html`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_html`.
import pkg/openparser/html
export html
