# Dotenv loading via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/dotenv` surface is
# available (`loadDotenv`, `parseEnv`, `get`/`set`/`has`/`del`,
# `expandValue`). A missing file is a no-op.
#
# Enabled via `supra init <project> --restapi` recipe `openparser/dotenv`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_dotenv`.
import pkg/openparser/dotenv
export dotenv
