import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../app/router.dart';
import '../../../core/l10n/build_context_l10n.dart';
import '../../../core/presentation/book_cover.dart';
import '../../../core/presentation/load_error.dart';
import '../application/catalog_providers.dart';
import '../domain/book.dart';

class SearchScreen extends HookConsumerWidget {
  const SearchScreen({required this.query, required this.page, super.key});

  final String query;
  final int page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: query);
    useEffect(() {
      if (controller.text != query) controller.text = query;
      return null;
    }, [query]);
    final result = ref.watch(bookSearchProvider(query: query, page: page));

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.l.search, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 18),
                TextField(
                  controller: controller,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) => _search(context, value),
                  decoration: InputDecoration(
                    hintText: context.l.searchHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: IconButton(
                      tooltip: context.l.search,
                      onPressed: () => _search(context, controller.text),
                      icon: const Icon(Icons.arrow_forward_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: result.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => LoadError(
                      error: error,
                      onRetry: () => ref.invalidate(bookSearchProvider(query: query, page: page)),
                    ),
                    data: (searchPage) => _Results(page: searchPage, query: query, currentPage: page),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void _search(BuildContext context, String value) =>
      SearchRoute(query: value.trim().isEmpty ? null : value.trim(), page: 1).go(context);
}

class _Results extends StatelessWidget {
  const _Results({required this.page, required this.query, required this.currentPage});

  final BookSearchPage page;
  final String query;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final pageCount = (page.total / page.pageSize).ceil().clamp(1, 999999);
    if (page.items.isEmpty) {
      return Center(child: Text(context.l.noResults, textAlign: TextAlign.center));
    }
    return Column(children: [
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(context.l.booksFound(page.total), style: Theme.of(context).textTheme.labelLarge),
      ),
      const SizedBox(height: 12),
      Expanded(
        child: GridView.builder(
          key: const ValueKey('book-results'),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 520,
            mainAxisExtent: 194,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: page.items.length,
          itemBuilder: (context, index) => _BookCard(book: page.items[index]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
            tooltip: context.l.previousPage,
            onPressed: currentPage > 1 ? () => SearchRoute(query: query, page: currentPage - 1).go(context) : null,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Text(context.l.pageLabel(currentPage, pageCount)),
          IconButton(
            tooltip: context.l.nextPage,
            onPressed: currentPage < pageCount ? () => SearchRoute(query: query, page: currentPage + 1).go(context) : null,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ]),
      ),
    ]);
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: () => BookDetailRoute(bookId: book.id).go(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const BookCover(width: 88, height: 130),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(context.l.author(book.author), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Text(book.genre, style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 2),
                  Text(context.l.pageCount(book.pageCount), style: Theme.of(context).textTheme.bodySmall),
                ]),
              ),
              const Icon(Icons.chevron_right_rounded),
            ]),
          ),
        ),
      );
}
