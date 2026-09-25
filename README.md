# Flutter Riverpod Skill

Riverpod を使う Flutter アプリの設計・実装を支援する Codex Skill です。新規アプリ、既存機能の追加、段階的なリファクタリングで利用できます。

## 方針

- Flutter 公式の [Architecture Best Practices Skill](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md) をアーキテクチャの基準として参照し、Riverpod 向けのルールを追加します。
- 機能単位の構成、Riverpod の `Notifier` / `AsyncNotifier`、Freezed、`flutter_hooks` を使います。
- 新規 Flutter プロジェクトでは FVM と `.fvmrc` で検証済み SDK を固定します。
- API クライアントは OpenAPI Generator の `dart-dio` で生成します。
- UI テーマ、多言語対応 (Flutter `gen_l10n`) と型安全な `go_router` を標準にします。
- Flutter 公式 agent-plugins の追加 Skill は、作業に合う場合だけ参照します。内容は複製しません。

## 利用方法

このリポジトリを Codex Skill として利用可能な場所に配置し、`flutter-riverpod-skill` Skill をアプリ開発タスクで呼び出してください。Skill 本文は [SKILL.md](SKILL.md)、必要に応じて参照する詳細ガイドは [`references/`](references/) にあります。

## サンプルアプリ

[Reading Shelf](examples/reading_shelf/README.md) は、この Skill の構成・コード生成・テスト方針を試せる Flutter Web アプリと Shelf API です。外部 API キーなしで起動できます。

## 参照元

- [Flutter agent-plugins Skills](https://github.com/flutter/agent-plugins/tree/main/skills)
- [Flutter アプリのアーキテクチャ Skill](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md)
- [Flutter の国際化ガイド](https://docs.flutter.dev/ui/internationalization)
- [OpenAPI Generator dart-dio](https://openapi-generator.tech/docs/generators/dart-dio/)

## 構成

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
