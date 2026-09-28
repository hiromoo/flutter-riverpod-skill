# Flutter Riverpod Skill

Riverpod を使った Flutter アプリの設計・開発を支援する、Codex と Claude Code 向けの Agent Skill です。新規アプリの作成、機能追加、既存アプリの段階的なリファクタリングに利用できます。

[English](README.md) | 日本語

## 方針

- Flutter 公式の [Architecture Best Practices Skill](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md) をアーキテクチャの基準とし、Riverpod 向けのガイダンスを加えます。
- 機能単位でコードを構成し、Riverpod の `Notifier` / `AsyncNotifier`、Freezed、`flutter_hooks` を使います。
- 新規 Flutter プロジェクトでは、検証済みの Flutter SDK を FVM と `.fvmrc` で固定します。
- OpenAPI 仕様から OpenAPI Generator の `dart-dio` ジェネレーターで API クライアントを生成します。
- UI テーマを一元管理し、Flutter `gen_l10n` による多言語対応と型安全な `go_router` ルートを使います。
- 作業に合う場合は Flutter の追加 Agent Skill を参照します。その内容はこのリポジトリに複製しません。

## 利用方法

Skill の説明は [SKILL.md](SKILL.md)、目的別の詳しいガイドは [`references/`](references/) にあります。同じファイルを Codex と Claude Code の両方で利用できます。

### Codex

このリポジトリを Codex が Skill として利用できる場所に配置し、Flutter 開発タスクで `flutter-riverpod-skill` を呼び出してください。

### Claude Code

ディレクトリ名を `flutter-riverpod-skill` のまま、Claude Code の skills ディレクトリにクローンしてください。

```sh
# すべてのプロジェクトで利用する場合
git clone https://github.com/hiromoo/riverpod_ai_docs.git ~/.claude/skills/flutter-riverpod-skill

# 特定のプロジェクトだけで利用する場合（プロジェクトのルートで実行）
git clone https://github.com/hiromoo/riverpod_ai_docs.git .claude/skills/flutter-riverpod-skill
```

既存のクローンがある場合は、`ln -s "$PWD" ~/.claude/skills/flutter-riverpod-skill` のようにシンボリックリンクを作成しても構いません。該当する Flutter タスクでは Claude Code が自動的に Skill を読み込みます。`/flutter-riverpod-skill` で明示的に呼び出すこともできます。

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
agents/openai.yaml   # Codex の UI 用メタデータ（Claude Code では使用しません）
references/
  architecture.md
  riverpod-and-models.md
  api-client.md
  ui-localization-and-navigation.md
  testing-and-generation.md
```

## ライセンス

このリポジトリは [MIT License](LICENSE) のもとで公開しています。

## スキルの評価

GPT-6 Lunaによるスキルあり／なしの実装を、GPT-6 Astraの採点と独立したFlutter/Dartの解析・テストで比較します。評価ケース、実行方法、結果の読み方は[評価ガイド](EVALUATION.md)を参照してください。

[初回の評価結果](benchmarks/iteration-1.md)では、スキルありで機能・規約の合格率が向上しました。一方で、実行時間とトークン使用量の増加や、Lunaが一貫して適用できなかった規約も確認されています。規約チェックリストを追加した[iteration 2](benchmarks/iteration-2.md)では、スキルありの規約合格率が27.3%から81.8%に上がり、機能の合格率は変わりませんでした。ただし、Refactorケースではdispose後の安全性チェックで後退がありました。
