import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_entry.freezed.dart';

enum ReadingStatus { wantToRead, reading, finished }

@freezed
abstract class ReadingEntry with _$ReadingEntry {
  const factory ReadingEntry({
    required String bookId,
    required ReadingStatus status,
    required int pagesRead,
    required int? rating,
    required String note,
    required DateTime updatedAt,
  }) = _ReadingEntry;
}
