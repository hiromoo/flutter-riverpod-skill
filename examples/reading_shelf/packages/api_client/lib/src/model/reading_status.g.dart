// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReadingStatus _$wantToRead = const ReadingStatus._('wantToRead');
const ReadingStatus _$reading = const ReadingStatus._('reading');
const ReadingStatus _$finished = const ReadingStatus._('finished');
const ReadingStatus _$unknownDefaultOpenApi =
    const ReadingStatus._('unknownDefaultOpenApi');

ReadingStatus _$valueOf(String name) {
  switch (name) {
    case 'wantToRead':
      return _$wantToRead;
    case 'reading':
      return _$reading;
    case 'finished':
      return _$finished;
    case 'unknownDefaultOpenApi':
      return _$unknownDefaultOpenApi;
    default:
      return _$unknownDefaultOpenApi;
  }
}

final BuiltSet<ReadingStatus> _$values =
    BuiltSet<ReadingStatus>(const <ReadingStatus>[
  _$wantToRead,
  _$reading,
  _$finished,
  _$unknownDefaultOpenApi,
]);

class _$ReadingStatusMeta {
  const _$ReadingStatusMeta();
  ReadingStatus get wantToRead => _$wantToRead;
  ReadingStatus get reading => _$reading;
  ReadingStatus get finished => _$finished;
  ReadingStatus get unknownDefaultOpenApi => _$unknownDefaultOpenApi;
  ReadingStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<ReadingStatus> get values => _$values;
}

abstract class _$ReadingStatusMixin {
  // ignore: non_constant_identifier_names
  _$ReadingStatusMeta get ReadingStatus => const _$ReadingStatusMeta();
}

Serializer<ReadingStatus> _$readingStatusSerializer =
    _$ReadingStatusSerializer();

class _$ReadingStatusSerializer implements PrimitiveSerializer<ReadingStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'wantToRead': 'wantToRead',
    'reading': 'reading',
    'finished': 'finished',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'wantToRead': 'wantToRead',
    'reading': 'reading',
    'finished': 'finished',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[ReadingStatus];
  @override
  final String wireName = 'ReadingStatus';

  @override
  Object serialize(Serializers serializers, ReadingStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReadingStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReadingStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
