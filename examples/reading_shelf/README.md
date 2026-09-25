# Reading Shelf

このサンプルは、リポジトリの Riverpod Flutter Architecture Skill を使った Flutter Web の読書記録アプリです。架空の書籍カタログを検索し、本棚への登録、読書記録の編集、言語・テーマ切替を試せます。認証や外部 API キーは不要です。

## 必要なもの

- Flutter stable / Dart 3.12 以降
- Java 17 以降と Node.js/npm（OpenAPI クライアントを再生成する場合）

## 起動

ターミナル 1:

```sh
cd examples/reading_shelf/server
dart pub get
dart run bin/server.dart
```

ターミナル 2:

```sh
cd examples/reading_shelf
flutter pub get
dart run build_runner build
flutter gen-l10n
flutter run -d chrome --web-port 3000 --dart-define=API_BASE_URL=http://localhost:8080
```

ブラウザーで `http://localhost:3000` を開きます。URL は hash routing を使うため、詳細画面などへの直接アクセスと再読み込みができます。サーバーの読書記録は `server/data/reading_entries.json` に保存されます。

VS Code ではリポジトリルートを開き、Run and Debug から `Reading Shelf (Web + API)` を選ぶと API と Chrome アプリを起動できます。初回だけ、API の依存関係を `server` ディレクトリで `dart pub get` してください。

API の接続先は `API_BASE_URL` で変更できます。サーバーの `PORT`、`READING_SHELF_DATA_FILE` でもポートと保存先を変更できます。

## API クライアント生成

OpenAPI 仕様は `api/openapi.yaml`、generator CLI wrapper は `openapitools.json`、generator バージョンは同ファイル内で固定しています。Java と npm が利用可能な状態で:

```sh
./scripts/generate_api.sh
cd packages/api_client
dart pub get
dart run build_runner build
dart test
```

OpenAPI Generator が出力したコードは手編集せず、生成 serializer もコミットします。`scripts/validate_generated.sh` は再生成差分と package の解析を検証します。

このサンプルでは generator の削除対象から手管理の `analysis_options.yaml` を `.openapi-generator-ignore` で除外しています。再生成後も設定・テスト・README が残ることを確認してください。`built_value` の null 許容値は `Optional<T>.isPresent` を確認してから `.value` を読む必要があります。Riverpod runtime/generator の API は major version 間で異なるため、依存を選んだ直後に最小 provider の生成・解析を通してから feature 実装に進んでください。

## 検証

```sh
cd server && dart test && dart analyze
cd ..
flutter gen-l10n
dart run build_runner build
flutter analyze
flutter test
flutter build web --dart-define=API_BASE_URL=http://localhost:8080
```

サーバーテストは検索・ページ送り、入力検証、保存後の再起動復元、削除、CORS preflight を確認します。API package test は null 許容記録の built_value serializer を、Widget test は repository override でローカライズされた検索結果を確認します。

## Skill との対応

| Skill 方針 | サンプルでの例 |
| --- | --- |
| feature-first / Repository 境界 | `lib/features/{catalog,reading,settings}` |
| Riverpod provider / Notifier と composition root override | `application/` と `lib/app/composition_root.dart` |
| OpenAPI Generator dart-dio + built_value | `api/openapi.yaml`, `packages/api_client/` |
| Shelf API + JSON 永続化 | `server/lib/reading_shelf_server.dart` |
| `flutter_hooks` のローカル状態 | 検索・記録編集の `HookConsumerWidget` |
| Freezed domain model | feature の `domain/` |
| typed go_router routes | `lib/app/router.dart` |
| `gen_l10n`, `context.l.*`, Material 3 | `lib/l10n/`, `lib/core/l10n/`, `lib/app/` |

詳細な規約はリポジトリルートの [SKILL.md](../../SKILL.md) と `references/` を参照してください。
