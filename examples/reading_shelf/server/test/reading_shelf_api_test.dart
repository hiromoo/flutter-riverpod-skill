import 'dart:convert';
import 'dart:io';

import 'package:reading_shelf_server/reading_shelf_server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  late Directory temporaryDirectory;
  late File dataFile;
  late ReadingShelfApi api;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp('reading-shelf-');
    dataFile = File('${temporaryDirectory.path}/entries.json');
    api = ReadingShelfApi(dataFile: dataFile);
    await api.load();
  });

  tearDown(() async {
    await temporaryDirectory.delete(recursive: true);
  });

  Future<Response> request(String method, String path, {String? body}) async =>
      await api.handler(Request(method, Uri.parse('http://localhost$path'), body: body));

  test('search filters books and paginates results', () async {
    final firstPage = await request('GET', '/books?query=the&page=1&pageSize=2');
    final decoded = jsonDecode(await firstPage.readAsString()) as Map<String, dynamic>;

    expect(firstPage.statusCode, 200);
    expect(decoded['page'], 1);
    expect(decoded['pageSize'], 2);
    expect(decoded['total'], greaterThan(2));
    expect((decoded['items'] as List).length, 2);
  });

  test('invalid pagination returns a structured client error', () async {
    final response = await request('GET', '/books?page=0');
    final decoded = jsonDecode(await response.readAsString()) as Map<String, dynamic>;

    expect(response.statusCode, 400);
    expect(decoded['code'], 'invalid_pagination');
  });

  test('entry writes are validated, persisted, and loaded after restart', () async {
    final invalid = await request(
      'PUT',
      '/reading-entries/quiet-atlas',
      body: jsonEncode({'status': 'reading', 'pagesRead': 285, 'note': ''}),
    );
    expect(invalid.statusCode, 400);

    final saved = await request(
      'PUT',
      '/reading-entries/quiet-atlas',
      body: jsonEncode({
        'status': 'reading',
        'pagesRead': 42,
        'rating': 5,
        'note': 'A good start',
      }),
    );
    expect(saved.statusCode, 200);
    expect(await dataFile.exists(), isTrue);

    final restartedApi = ReadingShelfApi(dataFile: dataFile);
    await restartedApi.load();
    final restored = await restartedApi.handler(
      Request('GET', Uri.parse('http://localhost/reading-entries/quiet-atlas')),
    );
    final decoded = jsonDecode(await restored.readAsString()) as Map<String, dynamic>;

    expect(restored.statusCode, 200);
    expect(decoded['pagesRead'], 42);
    expect(decoded['note'], 'A good start');
  });

  test('delete removes entry and absent entry returns 404', () async {
    await request(
      'PUT',
      '/reading-entries/quiet-atlas',
      body: jsonEncode({'status': 'wantToRead', 'pagesRead': 0, 'note': ''}),
    );
    final deleted = await request('DELETE', '/reading-entries/quiet-atlas');
    final missing = await request('GET', '/reading-entries/quiet-atlas');

    expect(deleted.statusCode, 204);
    expect(missing.statusCode, 404);
  });

  test('OPTIONS returns CORS headers for web clients', () async {
    final response = await request('OPTIONS', '/books');
    expect(response.statusCode, 204);
    expect(response.headers['access-control-allow-origin'], '*');
  });
}
