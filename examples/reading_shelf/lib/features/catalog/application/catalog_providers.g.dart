// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(booksRepository)
final booksRepositoryProvider = BooksRepositoryProvider._();

final class BooksRepositoryProvider
    extends
        $FunctionalProvider<BooksRepository, BooksRepository, BooksRepository>
    with $Provider<BooksRepository> {
  BooksRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'booksRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$booksRepositoryHash();

  @$internal
  @override
  $ProviderElement<BooksRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BooksRepository create(Ref ref) {
    return booksRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BooksRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BooksRepository>(value),
    );
  }
}

String _$booksRepositoryHash() => r'8126ffc200db8576dc343bdd4326da51f2bb27aa';

@ProviderFor(bookSearch)
final bookSearchProvider = BookSearchFamily._();

final class BookSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<BookSearchPage>,
          BookSearchPage,
          FutureOr<BookSearchPage>
        >
    with $FutureModifier<BookSearchPage>, $FutureProvider<BookSearchPage> {
  BookSearchProvider._({
    required BookSearchFamily super.from,
    required ({String query, int page}) super.argument,
  }) : super(
         retry: null,
         name: r'bookSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookSearchHash();

  @override
  String toString() {
    return r'bookSearchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<BookSearchPage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BookSearchPage> create(Ref ref) {
    final argument = this.argument as ({String query, int page});
    return bookSearch(ref, query: argument.query, page: argument.page);
  }

  @override
  bool operator ==(Object other) {
    return other is BookSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookSearchHash() => r'0e6d182dbb71288559e33cfe85ba12efac66f482';

final class BookSearchFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<BookSearchPage>,
          ({String query, int page})
        > {
  BookSearchFamily._()
    : super(
        retry: null,
        name: r'bookSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookSearchProvider call({required String query, required int page}) =>
      BookSearchProvider._(argument: (query: query, page: page), from: this);

  @override
  String toString() => r'bookSearchProvider';
}

@ProviderFor(bookById)
final bookByIdProvider = BookByIdFamily._();

final class BookByIdProvider
    extends $FunctionalProvider<AsyncValue<Book?>, Book?, FutureOr<Book?>>
    with $FutureModifier<Book?>, $FutureProvider<Book?> {
  BookByIdProvider._({
    required BookByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bookByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookByIdHash();

  @override
  String toString() {
    return r'bookByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Book?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Book?> create(Ref ref) {
    final argument = this.argument as String;
    return bookById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BookByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookByIdHash() => r'bad97ce7242bffbd18d3376d6a99baabf79e21df';

final class BookByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Book?>, String> {
  BookByIdFamily._()
    : super(
        retry: null,
        name: r'bookByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookByIdProvider call(String id) =>
      BookByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'bookByIdProvider';
}
