import 'dart:convert';

import 'package:built_value/serializer.dart';
import 'package:reading_shelf_api_client/reading_shelf_api_client.dart';
import 'package:test/test.dart';

void main() {
  test('serializes and deserializes a nullable reading entry', () {
    final json = <String, Object?>{
      'bookId': 'quiet-atlas',
      'status': 'wantToRead',
      'pagesRead': 0,
      'rating': null,
      'note': '',
      'updatedAt': '2026-09-25T09:43:54.842658Z',
    };

    final entry = standardSerializers.deserialize(
      json,
      specifiedType: const FullType(ReadingEntry),
    )! as ReadingEntry;
    expect(entry.bookId, 'quiet-atlas');
    expect(entry.rating.isEmpty, isTrue);
    expect(entry.updatedAt.toUtc().year, 2026);

    final serialized = standardSerializers.serialize(
      entry,
      specifiedType: const FullType(ReadingEntry),
    );
    expect(jsonDecode(jsonEncode(serialized)), containsPair('bookId', 'quiet-atlas'));
  });
}
