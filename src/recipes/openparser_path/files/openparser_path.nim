# Path and URL parsing via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/path` surface is
# available (`parsePath`, `detectKind`, `PathKind` for local, web,
# SSH, git, FTP/SFTP and mail paths).
#
# Enabled via `supra init <project> --restapi` recipe `openparser/path`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_path`.
import pkg/openparser/path
export path
