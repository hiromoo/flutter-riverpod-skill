// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReadingEntry extends ReadingEntry {
  @override
  final String bookId;
  @override
  final ReadingStatus status;
  @override
  final int pagesRead;
  @override
  final Optional<int?> rating;
  @override
  final String note;
  @override
  final DateTime updatedAt;

  factory _$ReadingEntry([void Function(ReadingEntryBuilder)? updates]) =>
      (ReadingEntryBuilder()..update(updates))._build();

  _$ReadingEntry._(
      {required this.bookId,
      required this.status,
      required this.pagesRead,
      required this.rating,
      required this.note,
      required this.updatedAt})
      : super._();
  @override
  ReadingEntry rebuild(void Function(ReadingEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReadingEntryBuilder toBuilder() => ReadingEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReadingEntry &&
        bookId == other.bookId &&
        status == other.status &&
        pagesRead == other.pagesRead &&
        rating == other.rating &&
        note == other.note &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, pagesRead.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReadingEntry')
          ..add('bookId', bookId)
          ..add('status', status)
          ..add('pagesRead', pagesRead)
          ..add('rating', rating)
          ..add('note', note)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ReadingEntryBuilder
    implements Builder<ReadingEntry, ReadingEntryBuilder> {
  _$ReadingEntry? _$v;

  String? _bookId;
  String? get bookId => _$this._bookId;
  set bookId(String? bookId) => _$this._bookId = bookId;

  ReadingStatus? _status;
  ReadingStatus? get status => _$this._status;
  set status(ReadingStatus? status) => _$this._status = status;

  int? _pagesRead;
  int? get pagesRead => _$this._pagesRead;
  set pagesRead(int? pagesRead) => _$this._pagesRead = pagesRead;

  Optional<int?>? _rating;
  Optional<int?>? get rating => _$this._rating;
  set rating(Optional<int?>? rating) => _$this._rating = rating;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ReadingEntryBuilder() {
    ReadingEntry._defaults(this);
  }

  ReadingEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookId = $v.bookId;
      _status = $v.status;
      _pagesRead = $v.pagesRead;
      _rating = $v.rating;
      _note = $v.note;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReadingEntry other) {
    _$v = other as _$ReadingEntry;
  }

  @override
  void update(void Function(ReadingEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReadingEntry build() => _build();

  _$ReadingEntry _build() {
    final _$result = _$v ??
        _$ReadingEntry._(
          bookId: BuiltValueNullFieldError.checkNotNull(
              bookId, r'ReadingEntry', 'bookId'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ReadingEntry', 'status'),
          pagesRead: BuiltValueNullFieldError.checkNotNull(
              pagesRead, r'ReadingEntry', 'pagesRead'),
          rating: BuiltValueNullFieldError.checkNotNull(
              rating, r'ReadingEntry', 'rating'),
          note: BuiltValueNullFieldError.checkNotNull(
              note, r'ReadingEntry', 'note'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'ReadingEntry', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
