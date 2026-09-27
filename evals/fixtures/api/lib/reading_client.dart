import 'package:dio/dio.dart';
class ReadingRecord {
  const ReadingRecord({required this.id, this.note});
  final String id;
  final String? note;
}
class ReadingClient {
  ReadingClient(Dio dio);
  Future<ReadingRecord> get(String id) => throw UnimplementedError();
  Future<ReadingRecord> save(String id, {required String? note}) => throw UnimplementedError();
}
