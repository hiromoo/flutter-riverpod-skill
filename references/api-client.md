# OpenAPI Client Generation with Dio

For an external HTTP API with an OpenAPI contract, use OpenAPI Generator's stable `dart-dio` client generator. See the [official generator documentation](https://openapi-generator.tech/docs/generators/dart-dio/) and [CLI usage](https://openapi-generator.tech/docs/usage/).

## Contract and reproducibility

- Treat the OpenAPI document as the source of truth for paths, operations, wire schemas, and API DTOs. Do not manually create a parallel Dio endpoint layer or duplicate request/response DTOs.
- Keep the OpenAPI document (or a versioned source reference), generator version, config, ignore rules, and generation command under project control. Prefer a pinned CLI/container version so local and CI output agree.
- Validate the specification before generation. Review schema nullability, required fields, enums, polymorphism/discriminators, authentication, and error responses against the actual API contract; do not conceal a contract mismatch with handwritten generated-file edits.
- Probe generator nullability semantics instead of inferring them from OpenAPI alone. In particular, with `built_value`, a nullable response field can deserialize to an absent generated `Optional<T>` when the JSON key is omitted; check presence before reading `.value`. Add focused serializer and repository-mapping tests for omitted, explicit `null`, and populated values where the contract permits them. For nullable optional request fields, verify the generated client can express the intended absent-versus-null behavior.
- Use stable `dart-dio` defaults, including `built_value` serialization. Choose another serializer only when a written project requirement demands it. The generator documentation listing `json_serializable` is not such a requirement. Pin any non-default generator options in config.
- Do not patch generator output, including the generated `pubspec.yaml`, by hand or with a script step such as `sed` or an inline Python rewrite. If the generated package does not resolve or build with the pinned SDK, change generator options or the generator version, or report the incompatibility. Do not pin old build tools to work around it.
- Plain `dart analyze` in the generated package must exit 0. Generator output can trigger diagnostics; for example, 7.25.0 emits an unused `package:built_value/json_object.dart` import in `default_api.dart`. Suppress only the specific rule in a package-local `analysis_options.yaml` (for example `analyzer: errors: unused_import: ignore`) with a comment naming the generator cause. List that file in `.openapi-generator-ignore` so that regeneration keeps it. Do not document a weakened command such as `dart analyze --no-fatal-warnings` as validation.
- The generated package must build non-interactively. In a clean copy, plain `dart pub get` followed by `dart run build_runner build` must succeed without extra flags or prompts, including when generated outputs are already committed.
- Generated source must be clearly isolated and must not be manually edited. Regenerate it when the specification or generation settings change.
- Keep hand-maintained package files outside generator-owned cleanup. Check whether the generator deletes the output directory before writing; use its ignore rules or a separate generated subdirectory so package-local analysis settings, tests, lockfiles, scripts, and documentation survive repeated generation. Run generation twice and verify the second run is stable. After staging or committing the first output, rerun the generator and any serializer build, then run `git diff --exit-code` on the generated paths (or compare the directories). Record the commands and the result in the package README and the final summary. An undocumented stability check cannot be verified by reviewers.
- Make regeneration reproducible from a clean checkout. `dart format` chooses its style from the package's language version, which it reads from `.dart_tool/package_config.json`. Without that file it assumes the latest version. A script that formats before `dart pub get`, including one using `DART_POST_PROCESS_FILE` during generation, therefore produces different output on a fresh clone than in a working tree. Resolve the package's dependencies first, then format, or skip generator post-processing. Verify stability by copying the project without `.dart_tool` and `build`, running the script there, and diffing the generated package against the committed one.
- `dart-dio` writes TODO test stubs into the package's `test/` directory. Those stubs are not tests. Disable them with `--global-property apiTests=false,modelTests=false`, or add `test/**` to `.openapi-generator-ignore` before the first generation. If stubs were already written, delete them. Keep hand-written serializer and contract tests in that directory, where the package's own `dart test` runs them. App-root tests do not validate the generated package.
- For new applications, commit generated source and verify in CI that regeneration produces no diff. Respect an existing repository's established generated-source policy when adding a feature.

## Package boundary and data flow

For a new app or a substantial API integration, keep generated output in `packages/api_client`. In an existing app where a separate package adds needless overhead, use an explicitly generated-only folder such as `lib/core/api/generated`.

```text
OpenAPI document
       │ generate
       ▼
Generated Dio client + transport DTOs
       │ called by
       ▼
Data API adapter / data source
       │ maps into
       ▼
Repository implementation → domain models
       │ consumed by
       ▼
Riverpod notifier → UI
```

- Construct and configure the generated client outside generated files. Supply base URL, shared Dio instance, timeouts, headers, authentication, interceptors, and safe logging through supported client configuration.
- Keep Dio and generated client types in the API package/data layer. A data adapter translates generated operations and transport failures into data-layer results; a repository implementation maps generated DTOs into Freezed domain models.
- Do not expose generated DTOs, Dio `Response`, or raw Dio exceptions to notifiers, widgets, or domain contracts.
- Avoid logging tokens, credentials, personal data, or full response bodies by default. Convert service failures into domain-relevant error values without leaking sensitive backend details to UI.
- Keep retries and token refresh in a deliberate transport/repository policy. Retry only operations that are safe to repeat or have an explicit idempotency guarantee.

## When no OpenAPI contract exists

Do not invent an inaccurate schema to satisfy code generation. Ask for the API contract where it is required to implement the integration. If the contract cannot be obtained, proceed with a hand-written Dio adapter only when the user or an existing project requirement explicitly authorizes that exception. Keep the adapter narrowly scoped, document the missing contract and assumptions, and replace it with generated code when the authoritative specification becomes available. Do not treat documenting the gap by itself as authorization.

## Generator options and compatibility

The `dart-dio` generator exposes options for enum fallbacks, optional-field semantics, serialization, and other language behavior. Choose options based on the service contract and app compatibility; do not enable permissive behavior without understanding its runtime effect. Pin the OpenAPI Generator version for reproducibility, but select a version compatible with the project's OpenAPI document and Dart/Flutter toolchain rather than baking a global version into this skill.
