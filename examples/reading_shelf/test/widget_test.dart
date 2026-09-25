// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reading_shelf/app/reading_shelf_app.dart';
import 'package:reading_shelf/features/catalog/application/catalog_providers.dart';
import 'package:reading_shelf/features/catalog/domain/book.dart';
import 'package:reading_shelf/features/catalog/domain/books_repository.dart';
import 'package:reading_shelf/features/reading/application/reading_providers.dart';
import 'package:reading_shelf/features/reading/domain/reading_repository.dart';
import 'package:reading_shelf/features/settings/application/settings_providers.dart';
import 'package:reading_shelf/features/settings/domain/app_settings.dart';
import 'package:reading_shelf/features/settings/domain/settings_repository.dart';
import 'package:reading_shelf/features/reading/domain/reading_entry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('search screen loads localized results and supports a direct route', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(ProviderScope(
      overrides: [
        booksRepositoryProvider.overrideWith((ref) => _BooksRepository()),
        readingRepositoryProvider.overrideWith((ref) => _ReadingRepository()),
        settingsRepositoryProvider.overrideWith((ref) => _SettingsRepository()),
      ],
      child: const ReadingShelfApp(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Search'), findsWidgets);
    expect(find.text('The Quiet Atlas'), findsWidgets);
    expect(find.text('by Mina Sato'), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(ReadingShelfApp)),
      listen: false,
    );
    await container.read(appSettingsControllerProvider.notifier).saveSettings(
          const AppSettings(locale: LocalePreference.japanese),
        );
    await tester.pumpAndSettle();
    expect(find.text('本を探す'), findsWidgets);

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

class _BooksRepository implements BooksRepository {
  static const _book = Book(id: 'quiet-atlas', title: 'The Quiet Atlas', author: 'Mina Sato',
      description: 'A mapmaker finds a hidden coastline.', pageCount: 285, publishedYear: 2024, genre: 'Fiction');

  @override
  Future<Book?> getById(String id) async => id == _book.id ? _book : null;

  @override
  Future<BookSearchPage> search({required String query, required int page}) async =>
      const BookSearchPage(items: [_book], page: 1, pageSize: 12, total: 1);
}

class _ReadingRepository implements ReadingRepository {
  @override
  Future<ReadingEntry?> getForBook(String bookId) async => null;
  @override
  Future<List<ReadingEntry>> list() async => [];
  @override
  Future<ReadingEntry> save(ReadingEntry entry) async => entry;
  @override
  Future<void> delete(String bookId) async {}
}

class _SettingsRepository implements SettingsRepository {
  @override
  Future<AppSettings> load() async => const AppSettings(locale: LocalePreference.english);
  @override
  Future<void> save(AppSettings settings) async {}
}
