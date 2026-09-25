#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ -z "${JAVA_HOME:-}" ]]; then
  JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null || true)"
  if [[ -z "$JAVA_HOME" && -x /opt/homebrew/opt/openjdk/bin/java ]]; then
    JAVA_HOME=/opt/homebrew/opt/openjdk
  fi
  export JAVA_HOME
fi
if [[ -n "$JAVA_HOME" ]]; then export PATH="$JAVA_HOME/bin:$PATH"; fi
npx --yes @openapitools/openapi-generator-cli@2.27.0 validate -i api/openapi.yaml
npx --yes @openapitools/openapi-generator-cli@2.27.0 generate \
  -g dart-dio \
  -i api/openapi.yaml \
  -o packages/api_client \
  --config packages/api_client/openapi-generator-config.yaml \
  --global-property apiTests=false,modelTests=false,apiDocs=false,modelDocs=false
