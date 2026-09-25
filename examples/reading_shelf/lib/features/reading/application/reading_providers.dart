import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/reading_entry.dart';
import '../domain/reading_repository.dart';

part 'reading_providers.g.dart';

@Riverpod(keepAlive: true)
ReadingRepository readingRepository(Ref ref) => throw UnimplementedError(
  'Override readingRepository in the app composition root.',
);

@riverpod
Future<List<ReadingEntry>> readingEntries(Ref ref) =>
    ref.watch(readingRepositoryProvider).list();

@riverpod
Future<ReadingEntry?> readingEntry(Ref ref, String bookId) =>
    ref.watch(readingRepositoryProvider).getForBook(bookId);

@riverpod
class ReadingEntryActions extends _$ReadingEntryActions {
  late String _bookId;

  @override
  FutureOr<void> build(String bookId) {
    _bookId = bookId;
  }

  Future<bool> save(ReadingEntry entry) async {
    if (state.isLoading) return false;
    state = const AsyncLoading<void>();
    try {
      await ref.read(readingRepositoryProvider).save(entry);
      state = const AsyncData<void>(null);
      ref.invalidate(readingEntriesProvider);
      ref.invalidate(readingEntryProvider(_bookId));
      return true;
    } catch (error, stackTrace) {
      state = AsyncError<void>(error, stackTrace);
      return false;
    }
  }

  Future<bool> delete() async {
    if (state.isLoading) return false;
    state = const AsyncLoading<void>();
    try {
      await ref.read(readingRepositoryProvider).delete(_bookId);
      state = const AsyncData<void>(null);
      ref.invalidate(readingEntriesProvider);
      ref.invalidate(readingEntryProvider(_bookId));
      return true;
    } catch (error, stackTrace) {
      state = AsyncError<void>(error, stackTrace);
      return false;
    }
  }
}
