# Public API contract

Keep the public `ReadingClient(Dio dio)`, `get(id)`, `save(id, {required note})`,
and `ReadingRecord(id:, note:)` signatures from `lib/reading_client.dart`.
They are used by existing consumers. Internal files and implementation may change.
Use the injected Dio, including its baseUrl and HttpClientAdapter, so consumers
can configure transport. Generate the client into `packages/reading_api`.
GET missing/null note maps to domain null; strings are preserved.
PUT null explicitly sends `"note": null` to clear it; PUT strings sends the string.
Errors must propagate as failures, never fabricated successful records.
Do not change the supplied OpenAPI contract to work around a generator issue.
