import 'package:dio/dio.dart';
import 'package:reading_shelf_api_client/reading_shelf_api_client.dart';

import '../../../core/domain/app_failure.dart';
import '../domain/reading_entry.dart' as domain;
import '../domain/reading_repository.dart';

class ApiReadingRepository implements ReadingRepository {
  ApiReadingRepository(this._api);

  final ReadingEntriesApi _api;

  @override
  Future<List<domain.ReadingEntry>> list() async {
    try {
      final response = await _api.listReadingEntries();
      final entries = response.data;
      if (entries == null) {
        throw const AppFailureException(AppFailure(kind: AppFailureKind.invalidData));
      }
      return entries.map(_mapEntry).toList(growable: false);
    } on DioException catch (error) {
      throw _mapDioFailure(error);
    }
  }

  @override
  Future<domain.ReadingEntry?> getForBook(String bookId) async {
    try {
      final response = await _api.getReadingEntry(bookId: bookId);
      return response.data == null ? null : _mapEntry(response.data!);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) return null;
      throw _mapDioFailure(error);
    }
  }

  @override
  Future<domain.ReadingEntry> save(domain.ReadingEntry entry) async {
    try {
      final request = SaveReadingEntryRequest((builder) => builder
        ..status = ReadingStatus.valueOf(entry.status.name)
        ..pagesRead = entry.pagesRead
        ..rating = Optional.present(entry.rating)
        ..note = entry.note);
      final response = await _api.putReadingEntry(
        bookId: entry.bookId,
        saveReadingEntryRequest: request,
      );
      final saved = response.data;
      if (saved == null) throw const FormatException('Missing saved reading entry.');
      return _mapEntry(saved);
    } on DioException catch (error) {
      throw _mapDioFailure(error);
    } on FormatException {
      throw const AppFailureException(AppFailure(kind: AppFailureKind.invalidData));
    }
  }

  @override
  Future<void> delete(String bookId) async {
    try {
      await _api.deleteReadingEntry(bookId: bookId);
    } on DioException catch (error) {
      throw _mapDioFailure(error);
    }
  }

  domain.ReadingEntry _mapEntry(ReadingEntry entry) => domain.ReadingEntry(
        bookId: entry.bookId,
        status: domain.ReadingStatus.values.firstWhere(
          (status) => status.name == entry.status.name,
          orElse: () => domain.ReadingStatus.wantToRead,
        ),
        pagesRead: entry.pagesRead,
        rating: entry.rating.isPresent ? entry.rating.value : null,
        note: entry.note,
        updatedAt: entry.updatedAt.toUtc(),
      );
}

AppFailureException _mapDioFailure(DioException error) => AppFailureException(
      AppFailure(
        kind: error.type == DioExceptionType.connectionError ||
                error.type == DioExceptionType.connectionTimeout ||
                error.type == DioExceptionType.receiveTimeout
            ? AppFailureKind.network
            : error.response?.statusCode == 404
                ? AppFailureKind.notFound
                : AppFailureKind.unknown,
      ),
    );
