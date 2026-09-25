import 'dart:io';

import 'package:reading_shelf_server/reading_shelf_server.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  final dataPath = Platform.environment['READING_SHELF_DATA_FILE'] ??
      'data/reading_entries.json';
  final api = ReadingShelfApi(dataFile: File(dataPath));
  await api.load();

  final server = await shelf_io.serve(api.handler, InternetAddress.anyIPv4, port);
  server.autoCompress = true;
  stdout.writeln('Reading Shelf API listening at http://localhost:${server.port}');
  stdout.writeln('Reading entries are stored in ${File(dataPath).absolute.path}');
}
