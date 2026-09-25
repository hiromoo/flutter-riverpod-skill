import 'dart:convert';

import 'package:built_value/serializer.dart';
import 'package:reading_shelf_api_client/reading_shelf_api_client.dart';
import 'package:test/test.dart';

void main() {
  test('deserializes nullable response rating when omitted, null, or populated',
      () {
    final omitted = _deserializeEntry(null);
    expect(omitted.rating.isEmpty, isTrue);

    final json = <String, Object?>{
      'bookId': 'quiet-atlas',
      'status': 'wantToRead',
      'pagesRead': 0,
      'rating': null,
      'note': '',
      'updatedAt': '2026-09-25T09:43:54.842658Z',
    };

    final explicitNull = _deserializeEntry(json);
    expect(explicitNull.rating.isEmpty, isTrue);

    final populated = _deserializeEntry({...json, 'rating': 4});
    expect(populated.rating.isPresent, isTrue);
    expect(populated.rating.value, 4);
    expect(populated.updatedAt.toUtc().year, 2026);
  });

  test('serializes nullable optional request rating as absent or populated',
      () {
    final withoutRating = SaveReadingEntryRequest((builder) => builder
      ..status = ReadingStatus.wantToRead
      ..pagesRead = 0
      ..note = ''
      ..rating = Optional.absent());
    final absentJson = _serializeRequest(withoutRating);
    expect(absentJson, isNot(contains('rating')));

    final withNullRating = SaveReadingEntryRequest((builder) => builder
      ..status = ReadingStatus.wantToRead
      ..pagesRead = 0
      ..note = ''
      ..rating = Optional.present(null));
    final nullJson = _serializeRequest(withNullRating);
    expect(nullJson, containsPair('rating', isNull));

    final withRating = SaveReadingEntryRequest((builder) => builder
      ..status = ReadingStatus.wantToRead
      ..pagesRead = 0
      ..note = ''
      ..rating = Optional.present(4));
    final populatedJson = _serializeRequest(withRating);
    expect(populatedJson, containsPair('rating', 4));
  });
}

ReadingEntry _deserializeEntry(Map<String, Object?>? json) =>
    standardSerializers.deserialize(
      json ??
          const {
            'bookId': 'quiet-atlas',
            'status': 'wantToRead',
            'pagesRead': 0,
            'note': '',
            'updatedAt': '2026-09-25T09:43:54.842658Z',
          },
      specifiedType: const FullType(ReadingEntry),
    )! as ReadingEntry;

Map<String, dynamic> _serializeRequest(SaveReadingEntryRequest request) =>
    jsonDecode(jsonEncode(standardSerializers.serialize(
      request,
      specifiedType: const FullType(SaveReadingEntryRequest),
    ))) as Map<String, dynamic>;
