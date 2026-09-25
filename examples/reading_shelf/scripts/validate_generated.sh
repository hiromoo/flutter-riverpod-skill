#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
bash ./scripts/generate_api.sh
if ! git diff --quiet -- api/openapi.yaml packages/api_client; then
  echo "Generated API client is stale. Run ./scripts/generate_api.sh and commit the generated changes." >&2
  exit 1
fi
untracked="$(git ls-files --others --exclude-standard -- api/openapi.yaml packages/api_client)"
if [[ -n "$untracked" ]]; then
  echo "Generated API files are not tracked yet; inspect and add them before using this check in CI:" >&2
  printf '%s\n' "$untracked" >&2
fi
cd packages/api_client
dart pub get
dart run build_runner build --delete-conflicting-outputs
dart test
dart analyze
cd ../..
flutter analyze
dart run build_runner build
flutter gen-l10n
