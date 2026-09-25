import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/book.dart';
import '../domain/books_repository.dart';

part 'catalog_providers.g.dart';

@Riverpod(keepAlive: true)
BooksRepository booksRepository(Ref ref) =>
    throw UnimplementedError('Override booksRepository in the app composition root.');

@riverpod
Future<BookSearchPage> bookSearch(Ref ref, {required String query, required int page}) =>
    ref.watch(booksRepositoryProvider).search(query: query, page: page);

@riverpod
Future<Book?> bookById(Ref ref, String id) => ref.watch(booksRepositoryProvider).getById(id);
