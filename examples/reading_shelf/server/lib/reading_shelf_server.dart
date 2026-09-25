import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

final books = <Map<String, Object>>[
  _book('quiet-atlas', 'The Quiet Atlas', 'Mira Sol', 'A cartographer learns to map the places people leave behind.', 284, 2022, 'Literary fiction'),
  _book('small-orbits', 'Small Orbits', 'Kenji Watanabe', 'Six linked stories about ordinary lives crossing paths.', 216, 2020, 'Short stories'),
  _book('garden-after-rain', 'The Garden After Rain', 'Aiko Mori', 'A botanist returns home to restore a neglected garden.', 338, 2023, 'Fiction'),
  _book('deep-workshop', 'The Deep Workshop', 'Tomas Reed', 'Practical ways to make room for careful, focused work.', 252, 2019, 'Nonfiction'),
  _book('paper-moons', 'Paper Moons', 'Lena Okafor', 'A family discovers a box of letters beneath an old floor.', 310, 2021, 'Mystery'),
  _book('river-of-glass', 'River of Glass', 'Noah Kim', 'A journey along a changing coastline and its communities.', 402, 2024, 'Travel'),
  _book('ordinary-light', 'Ordinary Light', 'Sara Bell', 'A photographer finds new meaning in familiar streets.', 198, 2018, 'Memoir'),
  _book('blue-hour', 'Blue Hour', 'Hana Sato', 'A night-shift radio host receives a call from the future.', 276, 2025, 'Speculative fiction'),
  _book('useful-machines', 'Useful Machines', 'Ravi Shah', 'A clear guide to the tools that shape modern life.', 364, 2022, 'Science'),
  _book('winter-letters', 'Winter Letters', 'Emi Tanaka', 'Correspondence between two friends over one long winter.', 232, 2017, 'Fiction'),
  _book('wild-commons', 'The Wild Commons', 'Peter Vale', 'How shared green spaces improve city life.', 290, 2021, 'Nature'),
  _book('last-lantern', 'The Last Lantern', 'Yuki Arai', 'A village keeper protects an old lighthouse and its stories.', 344, 2024, 'Historical fiction'),
  _book('good-enough-day', 'A Good Enough Day', 'Maya Brooks', 'Small practices for a kinder relationship with ambition.', 176, 2023, 'Wellbeing'),
  _book('borrowed-time', 'Borrowed Time', 'Alex Chen', 'A clockmaker investigates a town where every clock is late.', 320, 2016, 'Fantasy'),
  _book('city-of-seeds', 'City of Seeds', 'Nora Ellis', 'Neighbors build a shared food garden on an empty lot.', 208, 2020, 'Community'),
  _book('clear-water', 'Clear Water', 'Jun Park', 'A scientist follows the story of one river from source to sea.', 388, 2019, 'Science'),
  _book('midnight-library-card', 'The Midnight Library Card', 'Clara Finch', 'A librarian discovers a book that changes each night.', 260, 2025, 'Fantasy'),
  _book('between-stations', 'Between Stations', 'Daichi Kato', 'Short essays about train rides and the people aboard.', 188, 2022, 'Essays'),
];

Map<String, Object> _book(
  String id,
  String title,
  String author,
  String description,
  int pageCount,
  int publishedYear,
  String genre,
) => {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'pageCount': pageCount,
      'publishedYear': publishedYear,
      'genre': genre,
    };

class ReadingShelfApi {
  ReadingShelfApi({required this.dataFile});

  final File dataFile;
  final Map<String, Map<String, Object?>> _entries = {};
  Future<void> _writeQueue = Future<void>.value();

  Router get _router {
    final router = Router();
    router.get('/books', _searchBooks);
    router.get('/books/<bookId>', _getBook);
    router.get('/reading-entries', _listEntries);
    router.get('/reading-entries/<bookId>', _getEntry);
    router.put('/reading-entries/<bookId>', _putEntry);
    router.delete('/reading-entries/<bookId>', _deleteEntry);
    return router;
  }

  Handler get handler => (request) async {
        if (request.method == 'OPTIONS') {
          return _cors(Response(204));
        }
        try {
          return _cors(await _router.call(request));
        } catch (error, stackTrace) {
          stderr.writeln('Unhandled API error: $error\n$stackTrace');
          return _cors(_error(500, 'internal_error', 'An unexpected error occurred.'));
        }
      };

  Future<void> load() async {
    if (!await dataFile.exists()) return;
    final decoded = jsonDecode(await dataFile.readAsString());
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Reading entry store must be a JSON object.');
    }
    for (final entry in decoded.entries) {
      if (entry.value is Map<String, dynamic>) {
        _entries[entry.key] = Map<String, Object?>.from(entry.value as Map);
      }
    }
  }

  Response _searchBooks(Request request) {
    final query = (request.url.queryParameters['query'] ?? '').trim().toLowerCase();
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1');
    final pageSize = int.tryParse(request.url.queryParameters['pageSize'] ?? '10');
    if (page == null || page < 1 || pageSize == null || pageSize < 1 || pageSize > 50) {
      return _error(400, 'invalid_pagination', 'Page must be positive and pageSize must be between 1 and 50.');
    }
    final filtered = books.where((book) {
      return query.isEmpty ||
          '${book['title']} ${book['author']}'.toLowerCase().contains(query);
    }).toList();
    final start = (page - 1) * pageSize;
    final items = start >= filtered.length
        ? <Map<String, Object>>[]
        : filtered.skip(start).take(pageSize).toList();
    return _json(200, {
      'items': items,
      'page': page,
      'pageSize': pageSize,
      'total': filtered.length,
    });
  }

  Response _getBook(Request request, String bookId) {
    final book = _bookById(bookId);
    return book == null
        ? _error(404, 'book_not_found', 'Book was not found.')
        : _json(200, book);
  }

  Response _listEntries(Request request) {
    final values = _entries.values.toList()
      ..sort((a, b) => (b['updatedAt']! as String).compareTo(a['updatedAt']! as String));
    return _json(200, values);
  }

  Response _getEntry(Request request, String bookId) {
    final entry = _entries[bookId];
    return entry == null
        ? _error(404, 'entry_not_found', 'Reading entry was not found.')
        : _json(200, entry);
  }

  Future<Response> _putEntry(Request request, String bookId) async {
    final book = _bookById(bookId);
    if (book == null) return _error(404, 'book_not_found', 'Book was not found.');

    final Object? decoded;
    try {
      decoded = jsonDecode(await request.readAsString());
    } on FormatException {
      return _error(400, 'invalid_json', 'Request body must contain valid JSON.');
    }
    if (decoded is! Map<String, dynamic>) {
      return _error(400, 'invalid_body', 'Request body must be a JSON object.');
    }
    final status = decoded['status'];
    final pagesRead = decoded['pagesRead'];
    final rating = decoded['rating'];
    final note = decoded['note'];
    if (!const ['wantToRead', 'reading', 'finished'].contains(status)) {
      return _error(400, 'invalid_status', 'Status must be wantToRead, reading, or finished.');
    }
    final pageCount = book['pageCount']! as int;
    if (pagesRead is! int || pagesRead < 0 || pagesRead > pageCount) {
      return _error(400, 'invalid_pages_read', 'Pages read must be between 0 and the book page count.');
    }
    if (rating != null && (rating is! int || rating < 1 || rating > 5)) {
      return _error(400, 'invalid_rating', 'Rating must be between 1 and 5.');
    }
    if (note is! String || note.length > 2000) {
      return _error(400, 'invalid_note', 'Note must be a string of at most 2000 characters.');
    }
    if (status == 'finished' && pagesRead != pageCount) {
      return _error(400, 'unfinished_pages', 'A finished book must have all pages read.');
    }

    final entry = <String, Object?>{
      'bookId': bookId,
      'status': status,
      'pagesRead': pagesRead,
      'rating': rating,
      'note': note,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };
    _entries[bookId] = entry;
    await _persist();
    return _json(200, entry);
  }

  Future<Response> _deleteEntry(Request request, String bookId) async {
    if (_entries.remove(bookId) == null) {
      return _error(404, 'entry_not_found', 'Reading entry was not found.');
    }
    await _persist();
    return Response(204);
  }

  Map<String, Object>? _bookById(String bookId) {
    for (final book in books) {
      if (book['id'] == bookId) return book;
    }
    return null;
  }

  Future<void> _persist() async {
    final operation = _writeQueue.then((_) async {
      await dataFile.parent.create(recursive: true);
      final temporary = File('${dataFile.path}.${DateTime.now().microsecondsSinceEpoch}.tmp');
      await temporary.writeAsString(jsonEncode(_entries));
      await temporary.rename(dataFile.path);
    });
    _writeQueue = operation.catchError((Object _) {});
    await operation;
  }
}

Response _json(int status, Object body) => Response(
      status,
      body: jsonEncode(body),
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

Response _error(int status, String code, String message) =>
    _json(status, {'code': code, 'message': message});

Response _cors(Response response) => response.change(headers: {
      ...response.headers,
      'access-control-allow-origin': '*',
      'access-control-allow-methods': 'GET, PUT, DELETE, OPTIONS',
      'access-control-allow-headers': 'Content-Type, Authorization',
    });
