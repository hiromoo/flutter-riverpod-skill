# Code Generation, Validation, and Tests

Use relevant Flutter agent skills when available: `dart-run-static-analysis`, `dart-generate-test-mocks`, `flutter-add-widget-test`, and `flutter-add-integration-test`. Read only guidance needed for the current change. Follow the target repository's existing scripts and CI conventions.

## Generated code

- Never edit generated files by hand. Edit source annotations, ARB files, OpenAPI documents, or generator configuration, then run the owning generator.
- Keep generation commands and tool versions reproducible. Avoid unrelated generated diffs; review generated output whenever a schema or route change affects public app behavior.
- Typical generators include Riverpod/Freezed and `go_router_builder` via `build_runner`, OpenAPI Generator for Dio clients, and Flutter `gen-l10n` for ARB resources. Use the commands already defined by the app where present.
- Validate OpenAPI specifications before client generation. For new apps, commit generated API code and make CI detect changes after regeneration.
- When generated code lives in `packages/api_client`, run generation with that package as the output target, then run its own dependency resolution, any serializer generation required by its generated sources (including `built_value` serializers when present), and Dart analysis. Validate both the package and the consuming app; app-root checks alone do not establish that the generated package builds.
- Keep the API package's generation and validation commands in its own README or package scripts so contributors and CI invoke the same sequence. Avoid rerunning unrelated application generators from inside the API package.
- Ensure all supported ARB files contain compatible keys and placeholder definitions. Run `flutter gen-l10n` and treat generation failures as localization contract failures.

## Proportionate validation

After implementation, choose checks based on the changed surface. Common checks are:

1. Format the changed Dart sources using the repository's formatter command.
2. Run applicable code generation and localization generation.
3. Run `flutter analyze` or the repository's static analysis script.
4. Run targeted tests, then broader relevant tests when the change crosses feature boundaries.
5. For API changes, validate the OpenAPI document and verify generated output is reproducible.

Do not claim a check passed unless it was run. If a required check cannot run, report the concrete blocker and checks that did run.

## Test boundaries

- Repository and data adapter tests cover mapping, caching or persistence behavior, transport failures, and observable contracts. Fake services or mock generated clients at the adapter seam where practical.
- Notifier tests cover initial, loading, success, error, refresh/retry, user commands, and provider lifecycle behavior. Use provider overrides for dependencies rather than global mutable test state.
- Widget tests cover rendering, interactions, accessibility-relevant semantics, localized content, and theme behavior. Prefer focused tests that assert observable behavior.
- Router tests cover typed path/query parameters, redirects, error routes, deep links, and shell navigation where used.
- Integration tests cover only high-value end-to-end flows that cross real app boundaries; keep unit and widget tests as the faster default feedback loop.
- For localized UI, exercise English and Japanese, parameterized messages, pluralization where present, long strings, and locale changes. Include RTL only when a supported locale requires it.
- For themed UI, verify light and dark schemes and ensure components read from the active theme.
- API tests should cover success and representative failures such as authentication, validation, timeout, offline transport, malformed payload, and unknown enum values when relevant to the contract.
