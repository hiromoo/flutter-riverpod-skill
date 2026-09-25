import 'book.dart';

abstract interface class BooksRepository {
  Future<BookSearchPage> search({required String query, required int page});
  Future<Book?> getById(String id);
}
