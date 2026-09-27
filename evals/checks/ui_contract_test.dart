import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_eval_app/eval_app.dart';

Map<String, dynamic> book(String id) => {'id': id, 'title': 'Title $id', 'description': 'Description $id'};
class Gateway implements CatalogGateway {
  final queries = <String>[];
  final pending = <Completer<List<Map<String, dynamic>>>>[];
  @override
  Future<List<Map<String, dynamic>>> search(String query) {
    queries.add(query);
    final c = Completer<List<Map<String, dynamic>>>();
    pending.add(c);
    return c.future;
  }
  @override
  Future<Map<String, dynamic>> get(String id) async => book(id);
}
void main() {
  for (final language in ['en', 'ja']) {
    testWidgets('$language loading, empty, error, query retry, success', (tester) async {
      final gateway = Gateway();
      await tester.pumpWidget(EvalApp(gateway: gateway, locale: Locale(language)));
      await tester.pump();
      expect(gateway.queries, ['']);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      gateway.pending[0].complete([]);
      await tester.pumpAndSettle();
      expect(find.text(language == 'ja' ? '本がありません' : 'No books'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('search-input')), 'broken');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(gateway.queries.last, 'broken');
      gateway.pending.last.completeError(StateError('offline'));
      await tester.pumpAndSettle();
      expect(find.text(language == 'ja' ? '再試行' : 'Retry'), findsOneWidget);
      await tester.tap(find.byKey(const Key('retry')));
      await tester.pump();
      expect(gateway.queries, ['', 'broken', 'broken']);
      gateway.pending.last.complete([book('a')]);
      await tester.pumpAndSettle();
      expect(find.text('Title a'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  if (const bool.fromEnvironment('EVAL_DETAILS')) {
    testWidgets('list opens book details', (tester) async {
      final gateway = Gateway();
      await tester.pumpWidget(EvalApp(gateway: gateway));
      await tester.pump();
      gateway.pending.single.complete([book('detail')]);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('book-detail')));
      await tester.pumpAndSettle();
      expect(find.text('Description detail'), findsOneWidget);
      expect(find.text('Title detail'), findsWidgets);
    });
  }
  if (const bool.fromEnvironment('EVAL_RACE')) {
    testWidgets('latest query wins reversed completion', (tester) async {
      final gateway = Gateway();
      await tester.pumpWidget(EvalApp(gateway: gateway));
      await tester.pump();
      gateway.pending.single.complete([]);
      await tester.pumpAndSettle();
      for (final query in ['old', 'new']) {
        await tester.enterText(find.byKey(const Key('search-input')), query);
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();
      }
      expect(gateway.queries, ['', 'old', 'new']);
      gateway.pending[2].complete([book('new')]);
      await tester.pumpAndSettle();
      gateway.pending[1].complete([book('old')]);
      await tester.pumpAndSettle();
      expect(find.text('Title new'), findsOneWidget);
      expect(find.text('Title old'), findsNothing);
    });
    testWidgets('completion after dispose is safe', (tester) async {
      final gateway = Gateway();
      await tester.pumpWidget(EvalApp(gateway: gateway));
      await tester.pump();
      await tester.pumpWidget(const SizedBox());
      gateway.pending.single.complete([book('late')]);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
