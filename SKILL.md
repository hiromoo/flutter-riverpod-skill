---
name: riverpod-flutter-architecture
description: Build and evolve Flutter applications with Riverpod, Freezed, Dio clients generated from OpenAPI, Flutter localization, consistent Material theming, and type-safe go_router navigation. Use for new apps, feature work, and incremental architecture refactors.
---

# Riverpod Flutter Application Engineering

Apply this skill when creating a Flutter application, adding a feature, or incrementally improving an existing application that uses Riverpod.

## Core rules

- Follow Flutter's [architecture best practices skill](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md) as the architectural baseline. Add Riverpod-specific guidance from this skill; do not copy the external skill into the project.
- Use feature-first organization, with clear presentation, application, domain, and data responsibilities. Keep dependencies pointing inward; UI and domain code must not depend on Dio or generated API classes.
- Use Riverpod `Notifier`/`AsyncNotifier` for application and presentation state. A separate ViewModel is optional. Use `flutter_hooks` for widget-local, disposable state; use `hooks_riverpod` where a widget needs both hooks and Riverpod.
- Use Freezed for domain models, app state, and value objects. Generated OpenAPI DTOs are exempt and must remain generator-owned.
- For APIs described by OpenAPI, generate the client with OpenAPI Generator's stable `dart-dio` generator. Keep generated code behind data adapters and repositories.
- Use Flutter `gen_l10n` with ARB files for all user-facing text. The app's supported locales start with English and Japanese. Expose generated localizations as `context.l.*` through a `BuildContext` extension.
- Centralize Material theme configuration in `MaterialApp.router`; use `go_router` and `go_router_builder` typed routes for navigation.
- Inspect the target repository before editing. Preserve established conventions where they do not conflict with these requirements, and migrate existing applications incrementally by feature.

## Workflow

1. Inspect the app structure, SDK constraints, dependencies, code generation, API specifications, localization resources, theme, routes, and test setup.
2. Identify feature boundaries, state ownership, data contracts, user-visible states, locale requirements, and relevant responsive/accessibility needs.
3. Implement or adapt domain models, repositories, API adapters, providers/notifiers, typed routes, localization resources, and UI with the boundaries above.
4. Run the applicable generation, analysis, and tests. Summarize generated artifacts and validation results.

Before introducing or upgrading generators, verify that the pinned SDK, runtime packages, and generator packages are mutually compatible. Resolve dependencies and run a minimal clean code-generation build before implementing multiple features; do not assume a generated provider API from examples for another Riverpod major version. If the compatible generator has a defect or migration gap, keep affected providers hand-written with the project's supported `Provider`/`NotifierProvider` APIs rather than committing broken output, and record the exception and upgrade path.

## Read focused guidance

- For architecture or project structure decisions, read [references/architecture.md](references/architecture.md).
- For providers, state lifecycles, and Freezed models, read [references/riverpod-and-models.md](references/riverpod-and-models.md).
- When integrating an HTTP API, read [references/api-client.md](references/api-client.md).
- For themes, localization, accessibility, responsive UI, or navigation, read [references/ui-localization-and-navigation.md](references/ui-localization-and-navigation.md).
- For code generation, CI checks, or tests, read [references/testing-and-generation.md](references/testing-and-generation.md).
- Use [examples/reading_shelf/README.md](examples/reading_shelf/README.md) as a runnable reference when useful; it demonstrates the conventions without replacing project-specific requirements.

## Use Flutter's other agent skills when relevant

Consult the [Flutter agent-plugins skills catalog](https://github.com/flutter/agent-plugins/tree/main/skills) and use a matching skill if it is available in the current environment. Do not copy its contents into this skill. Common matches include:

| Work | Flutter skill |
| --- | --- |
| Architecture baseline | `flutter-apply-architecture-best-practices` |
| Localization setup | `flutter-setup-localization` |
| Declarative routing | `flutter-setup-declarative-routing` |
| Responsive layouts | `flutter-build-responsive-layout` |
| Layout debugging | `flutter-fix-layout-issues` |
| Widget tests | `flutter-add-widget-test` |
| Integration tests | `flutter-add-integration-test` |
| Static analysis | `dart-run-static-analysis` |
| Test mock generation | `dart-generate-test-mocks` |

Do not use `flutter-use-http-package` for API work covered by the Dio requirement. Use `flutter-implement-json-serialization` only where hand-authored serialization is needed; it does not replace Freezed models or OpenAPI-generated DTOs. If an external skill cannot be loaded, proceed with this skill and official Flutter documentation.

When instructions conflict, follow explicit project requirements first, then the mandatory conventions in this skill, then supplemental external skills.
