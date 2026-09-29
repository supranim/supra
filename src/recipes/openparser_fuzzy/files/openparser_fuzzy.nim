# Fuzzy string matching via https://github.com/openpeeps/openparser
#
# Stateless re-export — the whole `openparser/fuzzy` surface is
# available (`fuzzyScore`, `fuzzySearch`, `FuzzyOptions`).
# SIMD-accelerated where supported.
#
# Enabled via `supra init <project> --restapi` recipe `openparser/fuzzy`.
# Import this provider from your controllers with
# `import ../service/provider/openparser_fuzzy`.
import pkg/openparser/fuzzy
export fuzzy
