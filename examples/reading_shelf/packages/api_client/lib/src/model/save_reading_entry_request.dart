//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:reading_shelf_api_client/src/model/reading_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:reading_shelf_api_client/src/optional.dart';

part 'save_reading_entry_request.g.dart';

/// SaveReadingEntryRequest
///
/// Properties:
/// * [status] 
/// * [pagesRead] 
/// * [rating] 
/// * [note] 
@BuiltValue()
abstract class SaveReadingEntryRequest implements Built<SaveReadingEntryRequest, SaveReadingEntryRequestBuilder> {
  @BuiltValueField(wireName: r'status')
  ReadingStatus get status;
  // enum statusEnum {  wantToRead,  reading,  finished,  };

  @BuiltValueField(wireName: r'pagesRead')
  int get pagesRead;

  @BuiltValueField(wireName: r'rating')
  Optional<int?> get rating;

  @BuiltValueField(wireName: r'note')
  String get note;

  SaveReadingEntryRequest._();

  factory SaveReadingEntryRequest([void updates(SaveReadingEntryRequestBuilder b)]) = _$SaveReadingEntryRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SaveReadingEntryRequestBuilder b) => b
      ..rating = Optional.absent();

  @BuiltValueSerializer(custom: true)
  static Serializer<SaveReadingEntryRequest> get serializer => _$SaveReadingEntryRequestSerializer();
}

class _$SaveReadingEntryRequestSerializer implements PrimitiveSerializer<SaveReadingEntryRequest> {
  @override
  final Iterable<Type> types = const [SaveReadingEntryRequest, _$SaveReadingEntryRequest];

  @override
  final String wireName = r'SaveReadingEntryRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SaveReadingEntryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    SaveReadingEntryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SaveReadingEntryRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SaveReadingEntryRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SaveReadingEntryRequestBuilder();
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


