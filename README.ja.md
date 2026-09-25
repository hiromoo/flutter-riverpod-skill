# Flutter Riverpod Skill

Riverpod を使った Flutter アプリの設計・開発を支援する Codex Skill です。新規アプリの作成、機能追加、既存アプリの段階的なリファクタリングに利用できます。

[English](README.md) | 日本語

## 方針

- Flutter 公式の [Architecture Best Practices Skill](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md) をアーキテクチャの基準とし、Riverpod 向けのガイダンスを加えます。
- 機能単位でコードを構成し、Riverpod の `Notifier` / `AsyncNotifier`、Freezed、`flutter_hooks` を使います。
- 新規 Flutter プロジェクトでは、検証済みの Flutter SDK を FVM と `.fvmrc` で固定します。
- OpenAPI 仕様から OpenAPI Generator の `dart-dio` ジェネレーターで API クライアントを生成します。
- UI テーマを一元管理し、Flutter `gen_l10n` による多言語対応と型安全な `go_router` ルートを使います。
- 作業に合う場合は Flutter の追加 Agent Skill を参照します。その内容はこのリポジトリに複製しません。

## 利用方法

このリポジトリを Codex が Skill として利用できる場所に配置し、Flutter 開発タスクで `flutter-riverpod-skill` を呼び出してください。Skill の説明は [SKILL.md](SKILL.md)、目的別の詳しいガイドは [`references/`](references/) にあります。

## サンプルアプリ

[Reading Shelf](examples/reading_shelf/README.md) は Shelf API を備えた Flutter Web アプリです。推奨する構成、コード生成、テスト方針を確認できます。外部 API キーなしで起動できます。

## 参考資料

- [Flutter agent-plugins の Skills](https://github.com/flutter/agent-plugins/tree/main/skills)
- [Flutter アーキテクチャ Skill](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md)
- [Flutter の国際化ガイド](https://docs.flutter.dev/ui/internationalization)
- [OpenAPI Generator `dart-dio`](https://openapi-generator.tech/docs/generators/dart-dio/)

## リポジトリの構成

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

## ライセンス

このリポジトリは [MIT License](LICENSE) のもとで公開しています。
