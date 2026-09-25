//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:reading_shelf_api_client/src/date_serializer.dart';
import 'package:reading_shelf_api_client/src/model/date.dart';

import 'package:reading_shelf_api_client/src/model/api_error.dart';
import 'package:reading_shelf_api_client/src/model/book.dart';
import 'package:reading_shelf_api_client/src/model/book_search_result.dart';
import 'package:reading_shelf_api_client/src/model/reading_entry.dart';
import 'package:reading_shelf_api_client/src/model/reading_status.dart';
import 'package:reading_shelf_api_client/src/model/save_reading_entry_request.dart';

part 'serializers.g.dart';

@SerializersFor([
  ApiError,
  Book,
  BookSearchResult,
  ReadingEntry,
  ReadingStatus,
  SaveReadingEntryRequest,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ReadingEntry)]),
        () => ListBuilder<ReadingEntry>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Book)]),
        () => ListBuilder<Book>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
