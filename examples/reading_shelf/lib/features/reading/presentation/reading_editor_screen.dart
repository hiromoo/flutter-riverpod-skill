import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/build_context_l10n.dart';
import '../../../core/presentation/book_cover.dart';
import '../../../core/presentation/load_error.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/domain/book.dart';
import '../application/reading_providers.dart';
import '../domain/reading_entry.dart';

class ReadingEditorScreen extends HookConsumerWidget {
  const ReadingEditorScreen({required this.bookId, super.key});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookByIdProvider(bookId));
    final entry = ref.watch(readingEntryProvider(bookId));
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.entryEditor),
        leading: IconButton(
          tooltip: context.l.back,
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: book.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => LoadError(error: error, onRetry: () => ref.invalidate(bookByIdProvider(bookId))),
        data: (value) {
          if (value == null) return Center(child: Text(context.l.bookNotFound));
          return entry.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => LoadError(error: error, onRetry: () => ref.invalidate(readingEntryProvider(bookId))),
            data: (existing) => _EditorForm(book: value, existing: existing, bookId: bookId),
          );
        },
      ),
    );
  }
}

class _EditorForm extends HookConsumerWidget {
  const _EditorForm({required this.book, required this.existing, required this.bookId});

  final Book book;
  final ReadingEntry? existing;
  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final pagesController = useTextEditingController();
    final noteController = useTextEditingController();
    final status = useState(ReadingStatus.wantToRead);
    final rating = useState<int?>(null);
    final dirty = useState(false);
    final action = ref.watch(readingEntryActionsProvider);
    final saving = action.isLoading;

    useEffect(() {
      pagesController.text = '${existing?.pagesRead ?? 0}';
      noteController.text = existing?.note ?? '';
      status.value = existing?.status ?? ReadingStatus.wantToRead;
      rating.value = existing?.rating;
      dirty.value = false;
      return null;
    }, [existing]);

    Future<void> handleBack(bool didPop) async {
      if (didPop || !dirty.value || saving) return;
      final discard = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text(context.l.unsavedTitle),
              content: Text(context.l.unsavedMessage),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(context.l.keepEditing)),
                FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(context.l.discardChanges)),
              ],
            ),
          ) ??
          false;
      if (discard && context.mounted) {
        dirty.value = false;
        await WidgetsBinding.instance.endOfFrame;
        if (context.mounted) context.pop();
      }
    }

    return PopScope<void>(
      canPop: !dirty.value && !saving,
      onPopInvokedWithResult: (didPop, _) => handleBack(didPop),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const BookCover(width: 52, height: 76),
                    title: Text(book.title),
                    subtitle: Text(context.l.author(book.author)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(context.l.readingStatus, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                SegmentedButton<ReadingStatus>(
                  segments: [
                    ButtonSegment(value: ReadingStatus.wantToRead, label: Text(context.l.wantToRead)),
                    ButtonSegment(value: ReadingStatus.reading, label: Text(context.l.reading)),
                    ButtonSegment(value: ReadingStatus.finished, label: Text(context.l.finished)),
                  ],
                  selected: {status.value},
                  onSelectionChanged: saving
                      ? null
                      : (value) {
                          status.value = value.first;
                          if (status.value == ReadingStatus.finished) pagesController.text = '${book.pageCount}';
                          dirty.value = true;
                        },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: pagesController,
                  enabled: !saving,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => dirty.value = true,
                  decoration: InputDecoration(labelText: context.l.pagesRead, suffixText: '/ ${book.pageCount}'),
                  validator: (value) {
                    final pages = int.tryParse(value ?? '');
                    if (pages == null || pages < 0 || pages > book.pageCount) {
                      return context.l.validationPages(book.pageCount);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int?>(
                  initialValue: rating.value,
                  decoration: InputDecoration(labelText: context.l.rating),
                  items: [
                    DropdownMenuItem<int?>(value: null, child: Text(context.l.noRating)),
                    for (var stars = 1; stars <= 5; stars++)
                      DropdownMenuItem<int?>(value: stars, child: Text(context.l.ratingStars(stars))),
                  ],
                  onChanged: saving ? null : (value) { rating.value = value; dirty.value = true; },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: noteController,
                  enabled: !saving,
                  minLines: 4,
                  maxLines: 8,
                  maxLength: 2000,
                  onChanged: (_) => dirty.value = true,
                  decoration: InputDecoration(labelText: context.l.note, hintText: context.l.noteHint, alignLabelWithHint: true),
                  validator: (value) => (value?.length ?? 0) > 2000 ? context.l.validationNote : null,
                ),
                if (action.hasError) ...[
                  const SizedBox(height: 8),
                  Text(context.l.saveFailed, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: saving ? null : () => _save(context, ref, formKey, pagesController, noteController, status.value, rating.value, dirty),
                  icon: saving
                      ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save_outlined),
                  label: Text(saving ? context.l.saving : context.l.save),
                ),
                if (existing != null) ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: saving ? null : () => _delete(context, ref, dirty),
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: Text(context.l.delete),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    TextEditingController pagesController,
    TextEditingController noteController,
    ReadingStatus status,
    int? rating,
    ValueNotifier<bool> dirty,
  ) async {
    if (!formKey.currentState!.validate()) return;
    final saved = await ref.read(readingEntryActionsProvider.notifier).save(ReadingEntry(
          bookId: bookId,
          status: status,
          pagesRead: int.parse(pagesController.text),
          rating: rating,
          note: noteController.text.trim(),
          updatedAt: existing?.updatedAt ?? DateTime.now().toUtc(),
        ));
    if (saved && context.mounted) {
      dirty.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l.entrySaved)));
      context.pop();
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, ValueNotifier<bool> dirty) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(context.l.deleteConfirmTitle),
            content: Text(context.l.deleteConfirmMessage),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(context.l.cancel)),
              FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(context.l.delete)),
            ],
          ),
        ) ??
        false;
    if (!confirmed || !context.mounted) return;
    final deleted = await ref.read(readingEntryActionsProvider.notifier).delete(bookId);
    if (deleted && context.mounted) {
      dirty.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l.entryDeleted)));
      context.pop();
    }
  }
}
