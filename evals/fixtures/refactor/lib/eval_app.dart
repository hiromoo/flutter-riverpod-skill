import 'package:flutter/material.dart';
import 'catalog_gateway.dart';
export 'catalog_gateway.dart';

class EvalApp extends StatelessWidget {
  const EvalApp({super.key, required this.gateway, this.locale = const Locale('en')});
  final CatalogGateway gateway;
  final Locale locale;
  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: locale, home: SearchScreen(gateway: gateway, locale: locale));
}
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.gateway, required this.locale});
  final CatalogGateway gateway;
  final Locale locale;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  final input = TextEditingController();
  List<Map<String, dynamic>> books = [];
  bool loading = true;
  bool failed = false;
  String query = '';
  @override
  void initState() { super.initState(); search(''); }
  Future<void> search(String q) async {
    setState(() { query = q; loading = true; failed = false; });
    try {
      final result = await widget.gateway.search(q);
      if (!mounted) return;
      setState(() { books = result; loading = false; });
    } catch (_) {
      if (mounted) setState(() { failed = true; loading = false; });
    }
  }
  @override
  void dispose() { input.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(body: Column(children: [
    TextField(key: const Key('search-input'), controller: input, onSubmitted: search),
    if (loading) const CircularProgressIndicator()
    else if (failed) TextButton(key: const Key('retry'), onPressed: () => search(query),
      child: Text(widget.locale.languageCode == 'ja' ? '再試行' : 'Retry'))
    else if (books.isEmpty) Text(widget.locale.languageCode == 'ja' ? '本がありません' : 'No books')
    else Expanded(child: ListView(children: [for (final book in books)
      ListTile(key: Key('book-${book['id']}'), title: Text(book['title'] as String))])),
  ]));
}
