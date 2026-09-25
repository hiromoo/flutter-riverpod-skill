// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(readingRepository)
final readingRepositoryProvider = ReadingRepositoryProvider._();

final class ReadingRepositoryProvider
    extends
        $FunctionalProvider<
          ReadingRepository,
          ReadingRepository,
          ReadingRepository
        >
    with $Provider<ReadingRepository> {
  ReadingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readingRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReadingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReadingRepository create(Ref ref) {
    return readingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReadingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReadingRepository>(value),
    );
  }
}

String _$readingRepositoryHash() => r'db4bef9e6e14714f0671852c27101917057b73ec';

@ProviderFor(readingEntries)
final readingEntriesProvider = ReadingEntriesProvider._();

final class ReadingEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReadingEntry>>,
          List<ReadingEntry>,
          FutureOr<List<ReadingEntry>>
        >
    with
        $FutureModifier<List<ReadingEntry>>,
        $FutureProvider<List<ReadingEntry>> {
  ReadingEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readingEntriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readingEntriesHash();

  @$internal
  @override
  $FutureProviderElement<List<ReadingEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ReadingEntry>> create(Ref ref) {
    return readingEntries(ref);
  }
}

String _$readingEntriesHash() => r'c15fae7e83c41b4da15806059eb28bb412e8cbe5';

@ProviderFor(readingEntry)
final readingEntryProvider = ReadingEntryFamily._();

final class ReadingEntryProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReadingEntry?>,
          ReadingEntry?,
          FutureOr<ReadingEntry?>
        >
    with $FutureModifier<ReadingEntry?>, $FutureProvider<ReadingEntry?> {
  ReadingEntryProvider._({
    required ReadingEntryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'readingEntryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$readingEntryHash();

  @override
  String toString() {
    return r'readingEntryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ReadingEntry?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReadingEntry?> create(Ref ref) {
    final argument = this.argument as String;
    return readingEntry(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadingEntryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$readingEntryHash() => r'b182af7c0de8f360d207046b3d1b0b23664ac589';

final class ReadingEntryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ReadingEntry?>, String> {
  ReadingEntryFamily._()
    : super(
        retry: null,
        name: r'readingEntryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReadingEntryProvider call(String bookId) =>
      ReadingEntryProvider._(argument: bookId, from: this);

  @override
  String toString() => r'readingEntryProvider';
}

@ProviderFor(ReadingEntryActions)
final readingEntryActionsProvider = ReadingEntryActionsFamily._();

final class ReadingEntryActionsProvider
    extends $AsyncNotifierProvider<ReadingEntryActions, void> {
  ReadingEntryActionsProvider._({
    required ReadingEntryActionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'readingEntryActionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$readingEntryActionsHash();

  @override
  String toString() {
    return r'readingEntryActionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ReadingEntryActions create() => ReadingEntryActions();

  @override
  bool operator ==(Object other) {
    return other is ReadingEntryActionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$readingEntryActionsHash() =>
    r'c637eaccc68d5c93e6a7b2dc6d5dc40557df95ac';

final class ReadingEntryActionsFamily extends $Family
    with
        $ClassFamilyOverride<
          ReadingEntryActions,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          String
        > {
  ReadingEntryActionsFamily._()
    : super(
        retry: null,
        name: r'readingEntryActionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReadingEntryActionsProvider call(String bookId) =>
      ReadingEntryActionsProvider._(argument: bookId, from: this);

  @override
  String toString() => r'readingEntryActionsProvider';
}

abstract class _$ReadingEntryActions extends $AsyncNotifier<void> {
  late final _$args = ref.$arg as String;
  String get bookId => _$args;

  FutureOr<void> build(String bookId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
