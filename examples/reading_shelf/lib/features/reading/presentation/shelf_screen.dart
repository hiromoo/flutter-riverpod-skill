import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router.dart';
import '../../../core/l10n/build_context_l10n.dart';
import '../../../core/presentation/book_cover.dart';
import '../../../core/presentation/load_error.dart';
import '../../catalog/application/catalog_providers.dart';
import '../application/reading_providers.dart';
import '../domain/reading_entry.dart';

class ShelfScreen extends ConsumerWidget {
  const ShelfScreen({required this.filter, super.key});

  final ReadingStatus? filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(readingEntriesProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.l.shelf, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(spacing: 8, children: [
                    _FilterChip(label: context.l.allBooks, selected: filter == null, onTap: () => const ShelfRoute().go(context)),
                    _FilterChip(label: context.l.wantToRead, selected: filter == ReadingStatus.wantToRead, onTap: () => const ShelfRoute(status: ReadingStatus.wantToRead).go(context)),
                    _FilterChip(label: context.l.reading, selected: filter == ReadingStatus.reading, onTap: () => const ShelfRoute(status: ReadingStatus.reading).go(context)),
                    _FilterChip(label: context.l.finished, selected: filter == ReadingStatus.finished, onTap: () => const ShelfRoute(status: ReadingStatus.finished).go(context)),
                  ]),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: entries.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => LoadError(error: error, onRetry: () => ref.invalidate(readingEntriesProvider)),
                    data: (allEntries) {
                      final visible = filter == null
                          ? allEntries
                          : allEntries.where((entry) => entry.status == filter).toList(growable: false);
                      if (visible.isEmpty) {
                        return Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 420),
                            child: Column(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.menu_book_outlined, size: 44, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(height: 12),
                              Text(context.l.noShelfEntries, textAlign: TextAlign.center),
                            ]),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: visible.length,
                        itemBuilder: (context, index) => _ShelfBookTile(entry: visible[index]),
                      );
                    },
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      );
}

class _ShelfBookTile extends ConsumerWidget {
  const _ShelfBookTile({required this.entry});
  final ReadingEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookByIdProvider(entry.bookId));
    final status = switch (entry.status) {
      ReadingStatus.wantToRead => context.l.wantToRead,
      ReadingStatus.reading => context.l.reading,
      ReadingStatus.finished => context.l.finished,
    };
    return book.when(
      loading: () => const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: LinearProgressIndicator()),
      error: (error, _) => LoadError(error: error, onRetry: () => ref.invalidate(bookByIdProvider(entry.bookId))),
      data: (value) {
        if (value == null) return const SizedBox.shrink();
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => BookDetailRoute(bookId: value.id).go(context),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                const BookCover(width: 58, height: 84),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(value.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(context.l.author(value.author), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text(status, style: Theme.of(context).textTheme.labelLarge),
                    if (entry.status != ReadingStatus.wantToRead) ...[
                      const SizedBox(height: 2),
                      Text(context.l.readingProgress(entry.pagesRead, value.pageCount),
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ]),
                ),
                IconButton(
                  tooltip: context.l.edit,
                  onPressed: () => ReadingEditRoute(bookId: value.id).go(context),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
