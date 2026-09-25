//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reading_status.g.dart';

class ReadingStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'wantToRead')
  static const ReadingStatus wantToRead = _$wantToRead;
  @BuiltValueEnumConst(wireName: r'reading')
  static const ReadingStatus reading = _$reading;
  @BuiltValueEnumConst(wireName: r'finished')
  static const ReadingStatus finished = _$finished;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ReadingStatus unknownDefaultOpenApi = _$unknownDefaultOpenApi;

  static Serializer<ReadingStatus> get serializer => _$readingStatusSerializer;

  const ReadingStatus._(String name): super(name);

  static BuiltSet<ReadingStatus> get values => _$values;
  static ReadingStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ReadingStatusMixin = Object with _$ReadingStatusMixin;

