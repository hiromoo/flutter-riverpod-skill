// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_reading_entry_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SaveReadingEntryRequest extends SaveReadingEntryRequest {
  @override
  final ReadingStatus status;
  @override
  final int pagesRead;
  @override
  final Optional<int?> rating;
  @override
  final String note;

  factory _$SaveReadingEntryRequest(
          [void Function(SaveReadingEntryRequestBuilder)? updates]) =>
      (SaveReadingEntryRequestBuilder()..update(updates))._build();

  _$SaveReadingEntryRequest._(
      {required this.status,
      required this.pagesRead,
      required this.rating,
      required this.note})
      : super._();
  @override
  SaveReadingEntryRequest rebuild(
          void Function(SaveReadingEntryRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SaveReadingEntryRequestBuilder toBuilder() =>
      SaveReadingEntryRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SaveReadingEntryRequest &&
        status == other.status &&
        pagesRead == other.pagesRead &&
        rating == other.rating &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, pagesRead.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SaveReadingEntryRequest')
          ..add('status', status)
          ..add('pagesRead', pagesRead)
          ..add('rating', rating)
          ..add('note', note))
        .toString();
  }
}

class SaveReadingEntryRequestBuilder
    implements
        Builder<SaveReadingEntryRequest, SaveReadingEntryRequestBuilder> {
  _$SaveReadingEntryRequest? _$v;

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

  SaveReadingEntryRequestBuilder() {
    SaveReadingEntryRequest._defaults(this);
  }

  SaveReadingEntryRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _pagesRead = $v.pagesRead;
      _rating = $v.rating;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SaveReadingEntryRequest other) {
    _$v = other as _$SaveReadingEntryRequest;
  }

  @override
  void update(void Function(SaveReadingEntryRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SaveReadingEntryRequest build() => _build();

  _$SaveReadingEntryRequest _build() {
    final _$result = _$v ??
        _$SaveReadingEntryRequest._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'SaveReadingEntryRequest', 'status'),
          pagesRead: BuiltValueNullFieldError.checkNotNull(
              pagesRead, r'SaveReadingEntryRequest', 'pagesRead'),
          rating: BuiltValueNullFieldError.checkNotNull(
              rating, r'SaveReadingEntryRequest', 'rating'),
          note: BuiltValueNullFieldError.checkNotNull(
              note, r'SaveReadingEntryRequest', 'note'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
