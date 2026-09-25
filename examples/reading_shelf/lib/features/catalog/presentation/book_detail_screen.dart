import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router.dart';
import '../../../core/l10n/build_context_l10n.dart';
import '../../../core/presentation/book_cover.dart';
import '../../../core/presentation/load_error.dart';
import '../../reading/application/reading_providers.dart';
import '../../reading/domain/reading_entry.dart';
import '../application/catalog_providers.dart';

class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({required this.bookId, super.key});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookByIdProvider(bookId));
    return Scaffold(
      appBar: AppBar(title: Text(context.l.bookDetail)),
      body: book.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => LoadError(
          error: error,
          onRetry: () => ref.invalidate(bookByIdProvider(bookId)),
        ),
        data: (value) {
          if (value == null) return Center(child: Text(context.l.bookNotFound));
          final entry = ref.watch(readingEntryProvider(bookId));
          final action = ref.watch(readingEntryActionsProvider(bookId));
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: LayoutBuilder(builder: (context, constraints) {
                        final compact = constraints.maxWidth < 560;
                        final cover = const BookCover(width: 150, height: 220);
                        final information = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(value.title, style: Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 8),
                            Text(context.l.author(value.author), style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 16),
                            Wrap(spacing: 8, runSpacing: 8, children: [
                              Chip(label: Text(value.genre)),
                              Chip(label: Text(context.l.publishedYear(value.publishedYear))),
                              Chip(label: Text(context.l.pageCount(value.pageCount))),
                            ]),
                            const SizedBox(height: 16),
                            Text(value.description, style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        );
                        if (compact) {
                          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Center(child: cover),
                            const SizedBox(height: 24),
                            information,
                          ]);
                        }
                        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          cover,
                          const SizedBox(width: 28),
                          Expanded(child: information),
                        ]);
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),
                  entry.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (error, _) => LoadError(
                      error: error,
                      onRetry: () => ref.invalidate(readingEntryProvider(bookId)),
                    ),
                    data: (currentEntry) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (currentEntry == null)
                          FilledButton.icon(
                            onPressed: action.isLoading
                                ? null
                                : () async {
                                    final saved = await ref.read(readingEntryActionsProvider(bookId).notifier).save(
                                          ReadingEntry(
                                            bookId: bookId,
                                            status: ReadingStatus.wantToRead,
                                            pagesRead: 0,
                                            rating: null,
                                            note: '',
                                            updatedAt: DateTime.now().toUtc(),
                                          ),
                                        );
                                    if (context.mounted && !saved) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(context.l.saveFailed)),
                                      );
                                    }
                                  },
                            icon: const Icon(Icons.bookmark_add_outlined),
                            label: Text(context.l.addToShelf),
                          )
                        else ...[
                          FilledButton.icon(
                            onPressed: () => const ShelfRoute().go(context),
                            icon: const Icon(Icons.bookmarks_outlined),
                            label: Text(_statusLabel(context, currentEntry.status)),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () => ReadingEditRoute(bookId: bookId).go(context),
                            icon: const Icon(Icons.edit_outlined),
                            label: Text(context.l.editEntry),
                          ),
                        ],
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }

  String _statusLabel(BuildContext context, ReadingStatus status) => switch (status) {
        ReadingStatus.wantToRead => context.l.wantToRead,
        ReadingStatus.reading => context.l.reading,
        ReadingStatus.finished => context.l.finished,
      };
}
