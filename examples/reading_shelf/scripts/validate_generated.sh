#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if command -v fvm >/dev/null 2>&1; then
  dart_cmd=(fvm dart)
  flutter_cmd=(fvm flutter)
else
  dart_cmd=(dart)
  flutter_cmd=(flutter)
fi
bash ./scripts/generate_api.sh
if ! git diff --quiet -- \
  api/openapi.yaml \
  packages/api_client/lib \
  packages/api_client/.gitignore \
  packages/api_client/README.md \
  packages/api_client/pubspec.yaml \
  packages/api_client/.openapi-generator; then
  echo "Generated API client is stale. Run ./scripts/generate_api.sh and commit the generated changes." >&2
  exit 1
fi
untracked="$(git ls-files --others --exclude-standard -- api/openapi.yaml packages/api_client)"
if [[ -n "$untracked" ]]; then
  echo "Generated API files are not tracked yet; inspect and add them before using this check in CI:" >&2
  printf '%s\n' "$untracked" >&2
fi
cd packages/api_client
"${dart_cmd[@]}" pub get
"${dart_cmd[@]}" run build_runner clean
"${dart_cmd[@]}" run build_runner build
"${dart_cmd[@]}" test
"${dart_cmd[@]}" analyze
cd ../..
"${flutter_cmd[@]}" analyze lib test
"${dart_cmd[@]}" run build_runner clean
"${dart_cmd[@]}" run build_runner build
"${flutter_cmd[@]}" gen-l10n
