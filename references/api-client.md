# OpenAPI Client Generation with Dio

For an external HTTP API with an OpenAPI contract, use OpenAPI Generator's stable `dart-dio` client generator. See the [official generator documentation](https://openapi-generator.tech/docs/generators/dart-dio/) and [CLI usage](https://openapi-generator.tech/docs/usage/).

## Contract and reproducibility

- Treat the OpenAPI document as the source of truth for paths, operations, wire schemas, and API DTOs. Do not manually create a parallel Dio endpoint layer or duplicate request/response DTOs.
- Keep the OpenAPI document (or a versioned source reference), generator version, config, ignore rules, and generation command under project control. Prefer a pinned CLI/container version so local and CI output agree.
- Validate the specification before generation. Review schema nullability, required fields, enums, polymorphism/discriminators, authentication, and error responses against the actual API contract; do not conceal a contract mismatch with handwritten generated-file edits.
- Use stable `dart-dio` defaults; `built_value` serialization is the default unless a documented project compatibility requirement needs another generator-supported option. Pin any non-default generator options in config.
- Generated source must be clearly isolated and must not be manually edited. Regenerate it when the specification or generation settings change.
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
