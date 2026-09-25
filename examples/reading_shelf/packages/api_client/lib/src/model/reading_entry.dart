//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:reading_shelf_api_client/src/model/reading_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:reading_shelf_api_client/src/optional.dart';

part 'reading_entry.g.dart';

/// ReadingEntry
///
/// Properties:
/// * [bookId] 
/// * [status] 
/// * [pagesRead] 
/// * [rating] 
/// * [note] 
/// * [updatedAt] 
@BuiltValue()
abstract class ReadingEntry implements Built<ReadingEntry, ReadingEntryBuilder> {
  @BuiltValueField(wireName: r'bookId')
  String get bookId;

  @BuiltValueField(wireName: r'status')
  ReadingStatus get status;
  // enum statusEnum {  wantToRead,  reading,  finished,  };

  @BuiltValueField(wireName: r'pagesRead')
  int get pagesRead;

  @BuiltValueField(wireName: r'rating')
  Optional<int?> get rating;

  @BuiltValueField(wireName: r'note')
  String get note;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  ReadingEntry._();

  factory ReadingEntry([void updates(ReadingEntryBuilder b)]) = _$ReadingEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReadingEntryBuilder b) => b
      ..rating = Optional.absent();

  @BuiltValueSerializer(custom: true)
  static Serializer<ReadingEntry> get serializer => _$ReadingEntrySerializer();
}

class _$ReadingEntrySerializer implements PrimitiveSerializer<ReadingEntry> {
  @override
  final Iterable<Type> types = const [ReadingEntry, _$ReadingEntry];

  @override
  final String wireName = r'ReadingEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReadingEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'bookId';
    yield serializers.serialize(
      object.bookId,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ReadingStatus),
    );
    yield r'pagesRead';
    yield serializers.serialize(
      object.pagesRead,
      specifiedType: const FullType(int),
    );
    if (object.rating.isPresent) {
      yield r'rating';
      final optionalValue = object.rating.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(int),
        );
      }
    }
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReadingEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReadingEntryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bookId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReadingStatus),
          ) as ReadingStatus;
          result.status = valueDes;
          break;
        case r'pagesRead':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pagesRead = valueDes;
          break;
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          result.rating = Optional.present(valueDes);
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReadingEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReadingEntryBuilder();
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


