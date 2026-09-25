import 'package:dio/dio.dart';
import 'package:reading_shelf_api_client/reading_shelf_api_client.dart';

import '../../../core/domain/app_failure.dart';
import '../domain/book.dart' as domain;
import '../domain/books_repository.dart';

class ApiBooksRepository implements BooksRepository {
  ApiBooksRepository(this._api);

  final BooksApi _api;

  @override
  Future<domain.BookSearchPage> search({required String query, required int page}) async {
    try {
      final response = await _api.searchBooks(query: query, page: page, pageSize: 8);
      final result = response.data;
      if (result == null) throw const FormatException('Missing search result.');
      return domain.BookSearchPage(
        items: result.items.map(_mapBook).toList(growable: false),
        page: result.page,
        pageSize: result.pageSize,
        total: result.total,
      );
    } on DioException catch (error) {
      throw _mapDioFailure(error);
    } on FormatException {
      throw const AppFailureException(AppFailure(kind: AppFailureKind.invalidData));
    }
  }

  @override
  Future<domain.Book?> getById(String id) async {
    try {
      final response = await _api.getBook(bookId: id);
      final book = response.data;
      return book == null ? null : _mapBook(book);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) return null;
      throw _mapDioFailure(error);
    }
  }

  domain.Book _mapBook(Book apiBook) => domain.Book(
        id: apiBook.id,
        title: apiBook.title,
        author: apiBook.author,
        description: apiBook.description,
        pageCount: apiBook.pageCount,
        publishedYear: apiBook.publishedYear,
        genre: apiBook.genre,
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
