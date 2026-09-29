# YAML parsing and dumping via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/yaml` surface is
# available (`parseYAML`/`parseYAMLNode`, `parseYAMLStream`, `dump`).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/yaml`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_yaml`.
import pkg/openparser/yaml
export yaml
