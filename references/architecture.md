# Architecture and Project Structure

Use Flutter's [architecture best practices skill](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md) as the baseline for separation of concerns, repositories, and optional domain use cases. This reference adapts it to Riverpod and a feature-first layout.

## Layers and dependency direction

- Presentation contains routes, screens, widgets, and view-specific composition. Widgets render state and forward user intents; they do not fetch data or implement business rules.
- Application contains feature orchestration and state controllers, usually Riverpod notifiers. It may depend on domain contracts and models.
- Domain contains business concepts, invariants, and reusable use cases. Keep it independent from Flutter, Dio, generated clients, and storage SDKs where practical.
- Data contains repository implementations, API adapters, local data sources, and mappings between external DTOs and domain models.
- Dependencies point inward: presentation → application → domain; data implements contracts consumed inward. Avoid importing data implementations from widgets or domain code.
- Repositories provide a coherent source of truth for a domain resource and coordinate remote/local sources, caching, and synchronization where required. Avoid adding interfaces solely to mirror every implementation class when no boundary or substitution benefit exists.
- When a boundary is useful, define the repository contract in `domain` (or a clearly named feature contract module) and its implementation in `data`. Application and presentation code depend on the contract, never the implementation.
- Compose concrete dependencies in the app's composition root: app-level Riverpod providers may import data implementations and generated clients, construct repository implementations, and expose them through contract-typed providers. Feature notifiers consume only those contract providers. Keep this composition wiring in `app`/`core` or a clearly designated DI module, not in feature presentation code.
- Add a use case only when a business operation is complex, reused, or coordinates multiple repositories. Simple operations can be expressed by a notifier through a repository.

## Feature-first layout

Adapt names to an established project when that preserves clarity. A new application can use:

```text
lib/
  app/                         # ProviderScope, MaterialApp.router, router, app theme
  core/                        # Cross-feature primitives and infrastructure
    l10n/                      # BuildContext localization extension
    theme/
  features/
    profile/
      presentation/            # Screens and feature widgets
      application/             # Notifiers and provider declarations
      domain/                  # Freezed models and business contracts
      data/                    # Repository implementations and adapters
```

Keep a feature's implementation together. Put code in `core` only when it is genuinely shared or application-wide. Do not create every layer for a trivial feature if doing so adds empty files without clarifying a boundary.

## New feature workflow

1. Identify user-visible behavior, domain concepts, data sources, loading/error/empty states, and navigation entry points.
2. Define immutable domain state and repository contracts where they create useful boundaries.
3. Implement or adapt data sources and repository behavior; keep transport and persistence types behind the data layer.
4. Expose feature behavior through Riverpod providers and notifiers.
5. Build focused widgets that watch only the state they render, localize all user-facing text, and use shared theme tokens.
6. Add tests at the repository, notifier, widget, or route boundary appropriate to the behavior.

For existing apps, preserve working boundaries and migrate one feature at a time. Do not perform a broad restructuring as an incidental part of unrelated feature work.
