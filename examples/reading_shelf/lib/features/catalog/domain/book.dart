import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';

@freezed
abstract class Book with _$Book {
  const factory Book({
    required String id,
    required String title,
    required String author,
    required String description,
    required int pageCount,
    required int publishedYear,
    required String genre,
  }) = _Book;
}

@freezed
abstract class BookSearchPage with _$BookSearchPage {
  const factory BookSearchPage({
    required List<Book> items,
    required int page,
    required int pageSize,
    required int total,
  }) = _BookSearchPage;
}
