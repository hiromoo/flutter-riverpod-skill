// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Book extends Book {
  @override
  final String id;
  @override
  final String title;
  @override
  final String author;
  @override
  final String description;
  @override
  final int pageCount;
  @override
  final int publishedYear;
  @override
  final String genre;

  factory _$Book([void Function(BookBuilder)? updates]) =>
      (BookBuilder()..update(updates))._build();

  _$Book._(
      {required this.id,
      required this.title,
      required this.author,
      required this.description,
      required this.pageCount,
      required this.publishedYear,
      required this.genre})
      : super._();
  @override
  Book rebuild(void Function(BookBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BookBuilder toBuilder() => BookBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Book &&
        id == other.id &&
        title == other.title &&
        author == other.author &&
        description == other.description &&
        pageCount == other.pageCount &&
        publishedYear == other.publishedYear &&
        genre == other.genre;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, author.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, pageCount.hashCode);
    _$hash = $jc(_$hash, publishedYear.hashCode);
    _$hash = $jc(_$hash, genre.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Book')
          ..add('id', id)
          ..add('title', title)
          ..add('author', author)
          ..add('description', description)
          ..add('pageCount', pageCount)
          ..add('publishedYear', publishedYear)
          ..add('genre', genre))
        .toString();
  }
}

class BookBuilder implements Builder<Book, BookBuilder> {
  _$Book? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _author;
  String? get author => _$this._author;
  set author(String? author) => _$this._author = author;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _pageCount;
  int? get pageCount => _$this._pageCount;
  set pageCount(int? pageCount) => _$this._pageCount = pageCount;

  int? _publishedYear;
  int? get publishedYear => _$this._publishedYear;
  set publishedYear(int? publishedYear) =>
      _$this._publishedYear = publishedYear;

  String? _genre;
  String? get genre => _$this._genre;
  set genre(String? genre) => _$this._genre = genre;

  BookBuilder() {
    Book._defaults(this);
  }

  BookBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _author = $v.author;
      _description = $v.description;
      _pageCount = $v.pageCount;
      _publishedYear = $v.publishedYear;
      _genre = $v.genre;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Book other) {
    _$v = other as _$Book;
  }

  @override
  void update(void Function(BookBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Book build() => _build();

  _$Book _build() {
    final _$result = _$v ??
        _$Book._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Book', 'id'),
          title: BuiltValueNullFieldError.checkNotNull(title, r'Book', 'title'),
          author:
              BuiltValueNullFieldError.checkNotNull(author, r'Book', 'author'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'Book', 'description'),
          pageCount: BuiltValueNullFieldError.checkNotNull(
              pageCount, r'Book', 'pageCount'),
          publishedYear: BuiltValueNullFieldError.checkNotNull(
              publishedYear, r'Book', 'publishedYear'),
          genre: BuiltValueNullFieldError.checkNotNull(genre, r'Book', 'genre'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
