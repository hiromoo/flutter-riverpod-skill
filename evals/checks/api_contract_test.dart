import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_eval_app/reading_client.dart';

class Adapter implements HttpClientAdapter {
  Map<String, dynamic> payload = {'id': 'entry'};
  int status = 200;
  String? method;
  String? path;
  dynamic requestBody;
  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? stream, Future<void>? cancelFuture) async {
    method = options.method;
    path = options.path;
    if (stream != null) {
      final bytes = <int>[];
      await for (final chunk in stream) { bytes.addAll(chunk); }
      if (bytes.isNotEmpty) requestBody = jsonDecode(utf8.decode(bytes));
    } else { requestBody = options.data; }
    return ResponseBody.fromString(jsonEncode(payload), status, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
  }
  @override
  void close({bool force = false}) {}
}
void main() {
  late Adapter adapter;
  late Dio dio;
  late ReadingClient client;
  setUp(() {
    adapter = Adapter();
    dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'))..httpClientAdapter = adapter;
    client = ReadingClient(dio);
  });
  tearDown(() => dio.close(force: true));
  for (final variant in ['omitted', 'null', 'string']) {
    test('GET note $variant', () async {
      adapter.payload = {'id': 'entry', if (variant != 'omitted') 'note': variant == 'null' ? null : 'memo'};
      final result = await client.get('entry');
      expect(result.id, 'entry');
      expect(result.note, variant == 'string' ? 'memo' : null);
      expect(adapter.method, 'GET');
      expect(adapter.path, endsWith('/entries/entry'));
    });
  }
  for (final note in <String?>[null, 'updated']) {
    test('PUT preserves explicit $note', () async {
      adapter.payload = {'id': 'entry', 'note': note};
      final result = await client.save('entry', note: note);
      expect(adapter.method, 'PUT');
      expect(adapter.path, endsWith('/entries/entry'));
      expect(adapter.requestBody, containsPair('note', note));
      expect(result.id, 'entry');
      expect(result.note, note);
    });
  }
  test('transport failure is not a successful record', () async {
    adapter.status = 500;
    await expectLater(client.get('entry'), throwsA(anything));
  });
}
