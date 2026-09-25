// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_search_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BookSearchResult extends BookSearchResult {
  @override
  final BuiltList<Book> items;
  @override
  final int page;
  @override
  final int pageSize;
  @override
  final int total;

  factory _$BookSearchResult(
          [void Function(BookSearchResultBuilder)? updates]) =>
      (BookSearchResultBuilder()..update(updates))._build();

  _$BookSearchResult._(
      {required this.items,
      required this.page,
      required this.pageSize,
      required this.total})
      : super._();
  @override
  BookSearchResult rebuild(void Function(BookSearchResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BookSearchResultBuilder toBuilder() =>
      BookSearchResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookSearchResult &&
        items == other.items &&
        page == other.page &&
        pageSize == other.pageSize &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, pageSize.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BookSearchResult')
          ..add('items', items)
          ..add('page', page)
          ..add('pageSize', pageSize)
          ..add('total', total))
        .toString();
  }
}

class BookSearchResultBuilder
    implements Builder<BookSearchResult, BookSearchResultBuilder> {
  _$BookSearchResult? _$v;

  ListBuilder<Book>? _items;
  ListBuilder<Book> get items => _$this._items ??= ListBuilder<Book>();
  set items(ListBuilder<Book>? items) => _$this._items = items;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _pageSize;
  int? get pageSize => _$this._pageSize;
  set pageSize(int? pageSize) => _$this._pageSize = pageSize;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  BookSearchResultBuilder() {
    BookSearchResult._defaults(this);
  }

  BookSearchResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _page = $v.page;
      _pageSize = $v.pageSize;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BookSearchResult other) {
    _$v = other as _$BookSearchResult;
  }

  @override
  void update(void Function(BookSearchResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BookSearchResult build() => _build();

  _$BookSearchResult _build() {
    _$BookSearchResult _$result;
    try {
      _$result = _$v ??
          _$BookSearchResult._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'BookSearchResult', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'BookSearchResult', 'pageSize'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'BookSearchResult', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BookSearchResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
