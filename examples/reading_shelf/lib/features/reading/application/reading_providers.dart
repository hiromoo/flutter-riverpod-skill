import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../domain/reading_entry.dart';
import '../domain/reading_repository.dart';

final readingRepositoryProvider = Provider<ReadingRepository>(
  (ref) => throw UnimplementedError('Override readingRepository in the app composition root.'),
);

final readingEntriesProvider = FutureProvider<List<ReadingEntry>>(
  (ref) => ref.watch(readingRepositoryProvider).list(),
);

final readingEntryProvider = FutureProvider.family<ReadingEntry?, String>(
  (ref, bookId) => ref.watch(readingRepositoryProvider).getForBook(bookId),
);

final readingEntryActionsProvider = AsyncNotifierProvider<ReadingEntryActions, void>(
  ReadingEntryActions.new,
);

class ReadingEntryActions extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> save(ReadingEntry entry) async {
    if (state.isLoading) return false;
    state = const AsyncLoading<void>();
    try {
      await ref.read(readingRepositoryProvider).save(entry);
      state = const AsyncData<void>(null);
      ref.invalidate(readingEntriesProvider);
      ref.invalidate(readingEntryProvider(entry.bookId));
      return true;
    } catch (error, stackTrace) {
      state = AsyncError<void>(error, stackTrace);
      return false;
    }
  }

  Future<bool> delete(String bookId) async {
    if (state.isLoading) return false;
    state = const AsyncLoading<void>();
    try {
      await ref.read(readingRepositoryProvider).delete(bookId);
      state = const AsyncData<void>(null);
      ref.invalidate(readingEntriesProvider);
      ref.invalidate(readingEntryProvider(bookId));
      return true;
    } catch (error, stackTrace) {
      state = AsyncError<void>(error, stackTrace);
      return false;
    }
  }
}
