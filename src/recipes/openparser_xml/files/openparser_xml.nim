# XML parsing and serialization via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/xml` surface is
# available (`fromXml`/`fromXmlFile`, `toXml`/`toXmlNode`).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/xml`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_xml`.
import pkg/openparser/xml
export xml
