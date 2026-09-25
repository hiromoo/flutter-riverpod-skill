//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:reading_shelf_api_client/src/model/book.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'book_search_result.g.dart';

/// BookSearchResult
///
/// Properties:
/// * [items] 
/// * [page] 
/// * [pageSize] 
/// * [total] 
@BuiltValue()
abstract class BookSearchResult implements Built<BookSearchResult, BookSearchResultBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<Book> get items;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'pageSize')
  int get pageSize;

  @BuiltValueField(wireName: r'total')
  int get total;

  BookSearchResult._();

  factory BookSearchResult([void updates(BookSearchResultBuilder b)]) = _$BookSearchResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BookSearchResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BookSearchResult> get serializer => _$BookSearchResultSerializer();
}

class _$BookSearchResultSerializer implements PrimitiveSerializer<BookSearchResult> {
  @override
  final Iterable<Type> types = const [BookSearchResult, _$BookSearchResult];

  @override
  final String wireName = r'BookSearchResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BookSearchResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(Book)]),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'pageSize';
    yield serializers.serialize(
      object.pageSize,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BookSearchResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BookSearchResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Book)]),
          ) as BuiltList<Book>;
          result.items.replace(valueDes);
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        case r'pageSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pageSize = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BookSearchResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BookSearchResultBuilder();
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


