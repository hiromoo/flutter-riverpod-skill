# Riverpod State and Models

Use Riverpod for state shared across widgets, business/application state, asynchronous data, and state that must outlive a widget. Use Freezed for immutable domain models and app-owned state models. The OpenAPI generator owns its generated transport DTOs; do not edit or wrap those DTO declarations in Freezed.

## Provider and notifier choices

- Prefer `Notifier` for synchronous state with user-driven mutations and `AsyncNotifier` for state whose initial value or refresh is asynchronous.
- Use `Provider`, `FutureProvider`, or `StreamProvider` for derived, read-only, or naturally asynchronous values that do not need command methods.
- Use `riverpod_annotation` and `riverpod_generator` for provider declarations in new code. Follow the project's pinned Riverpod API version and generated part-file conventions.
- Treat `StateNotifier` and `ChangeNotifier` as compatibility choices for existing integrations, not defaults for new feature state.
- A separate ViewModel is not required. Introduce a distinct coordinator only when it improves reuse, testability, or separation of responsibilities beyond the notifier.

## State ownership

- Keep temporary widget concerns such as `TextEditingController`, `FocusNode`, `AnimationController`, `TabController`, and ephemeral presentation selections in `flutter_hooks`. Do not use a hand-written `StatefulWidget`/`State` field as the default for local mutable state.
- When a widget needs both Riverpod and hooks, use `hooks_riverpod` and `HookConsumerWidget`; otherwise use `HookWidget`. Keep each hook's lifetime aligned with the widget that owns the UI concern.
- Keep shared, domain-relevant, persisted, or asynchronous feature state in Riverpod.
- Do not mirror the same mutable state in a hook and a provider. Keep one source of truth and derive other values.
- Widget code should use `ref.watch` for values rendered by the widget and `ref.read` to dispatch a command from callbacks. Use `select` or smaller widgets when a broad state dependency causes unnecessary rebuilds.
- Use provider families for parameterized resources and choose auto-dispose/lifetime behavior deliberately. Long-lived providers should represent intentionally shared app state, not be the accidental default for screen-scoped data.
- Register cleanup for subscriptions, timers, controllers, and other resources with the relevant provider or hook lifecycle. Guard asynchronous work against stale parameters or disposed state where applicable.

## Async and error state

- Represent loading, data, and failure with `AsyncValue` unless the UI has a concrete need for a richer Freezed state machine.
- Render loading, empty, success, and error/retry states explicitly. Do not silently convert failures to empty data.
- Keep exceptions and domain error values independent from localized UI strings. Map failures to safe presentation messages in the UI layer using `context.l`.
- Do not store `BuildContext`, widgets, or localized strings in providers, repositories, or domain objects.
- Keep command methods small and named by user intent. Ensure concurrent refreshes or submissions cannot produce stale state when that matters to the feature.

## Freezed models

- Use Freezed for immutable domain entities, value objects, and complex app state where equality, copy/update semantics, or unions help.
- Prefer explicit fields and domain-oriented names. Keep JSON/API naming and nullability quirks out of domain types.
- Generated Freezed files are never edited by hand. Regenerate after changing annotations or part declarations.
- Avoid creating duplicate data classes where a simple value can be represented safely by a Dart record or small immutable class and does not cross a meaningful boundary.
