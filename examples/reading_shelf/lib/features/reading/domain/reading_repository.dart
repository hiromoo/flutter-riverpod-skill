import 'reading_entry.dart';

abstract interface class ReadingRepository {
  Future<List<ReadingEntry>> list();
  Future<ReadingEntry?> getForBook(String bookId);
  Future<ReadingEntry> save(ReadingEntry entry);
  Future<void> delete(String bookId);
}
