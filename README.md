# Flutter Riverpod Skill

A Codex skill for designing and building Flutter applications with Riverpod. Use it when starting a new app, adding features, or incrementally refactoring an existing application.

[English](README.md) | [日本語](README.ja.md)

## Principles

- Use Flutter's official [Architecture Best Practices skill](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md) as the architectural baseline, with additional guidance for Riverpod.
- Organize code by feature and use Riverpod `Notifier` / `AsyncNotifier`, Freezed, and `flutter_hooks`.
- Pin the verified Flutter SDK with FVM and `.fvmrc` for new Flutter projects.
- Generate API clients from OpenAPI specifications with OpenAPI Generator's `dart-dio` generator.
- Use a centralized UI theme, Flutter `gen_l10n` for localization, and type-safe `go_router` routes.
- Consult additional Flutter agent skills when they fit the task; do not duplicate their contents here.

## Usage

Place this repository where Codex can use it as a skill, then invoke the `flutter-riverpod-skill` skill for Flutter development tasks. The skill instructions are in [SKILL.md](SKILL.md); focused guidance is available in [`references/`](references/).

## Sample app

[Reading Shelf](examples/reading_shelf/README.md) is a Flutter web app with a Shelf API. Use it to explore the recommended structure, code generation, and testing approach. It runs without an external API key.

## References

- [Flutter agent-plugins skills](https://github.com/flutter/agent-plugins/tree/main/skills)
- [Flutter architecture skill](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md)
- [Flutter internationalization guide](https://docs.flutter.dev/ui/internationalization)
- [OpenAPI Generator `dart-dio`](https://openapi-generator.tech/docs/generators/dart-dio/)

## Repository structure

```text
SKILL.md
agents/openai.yaml
references/
  architecture.md
  riverpod-and-models.md
  api-client.md
  ui-localization-and-navigation.md
  testing-and-generation.md
```

## License

This repository is released under the [MIT License](LICENSE).
