//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'book.g.dart';

/// Book
///
/// Properties:
/// * [id] 
/// * [title] 
/// * [author] 
/// * [description] 
/// * [pageCount] 
/// * [publishedYear] 
/// * [genre] 
@BuiltValue()
abstract class Book implements Built<Book, BookBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'author')
  String get author;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'pageCount')
  int get pageCount;

  @BuiltValueField(wireName: r'publishedYear')
  int get publishedYear;

  @BuiltValueField(wireName: r'genre')
  String get genre;

  Book._();

  factory Book([void updates(BookBuilder b)]) = _$Book;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BookBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Book> get serializer => _$BookSerializer();
}

class _$BookSerializer implements PrimitiveSerializer<Book> {
  @override
  final Iterable<Type> types = const [Book, _$Book];

  @override
  final String wireName = r'Book';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Book object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'author';
    yield serializers.serialize(
      object.author,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'pageCount';
    yield serializers.serialize(
      object.pageCount,
      specifiedType: const FullType(int),
    );
    yield r'publishedYear';
    yield serializers.serialize(
      object.publishedYear,
      specifiedType: const FullType(int),
    );
    yield r'genre';
    yield serializers.serialize(
      object.genre,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Book object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BookBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'author':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.author = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'pageCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pageCount = valueDes;
          break;
        case r'publishedYear':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.publishedYear = valueDes;
          break;
        case r'genre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.genre = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Book deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BookBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


