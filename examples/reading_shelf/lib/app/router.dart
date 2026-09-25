import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/build_context_l10n.dart';
import '../features/catalog/presentation/book_detail_screen.dart';
import '../features/catalog/presentation/search_screen.dart';
import '../features/reading/domain/reading_entry.dart';
import '../features/reading/presentation/reading_editor_screen.dart';
import '../features/reading/presentation/shelf_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import 'app_shell.dart';

part 'router.g.dart';

@TypedStatefulShellRoute<AppShellRoute>(
  branches: [
    TypedStatefulShellBranch<SearchBranch>(routes: [
      TypedGoRoute<SearchRoute>(path: '/', routes: [
        TypedGoRoute<BookDetailRoute>(path: 'books/:bookId', routes: [
          TypedGoRoute<ReadingEditRoute>(path: 'reading'),
        ]),
      ]),
    ]),
    TypedStatefulShellBranch<ShelfBranch>(routes: [TypedGoRoute<ShelfRoute>(path: '/shelf')]),
    TypedStatefulShellBranch<SettingsBranch>(routes: [TypedGoRoute<SettingsRoute>(path: '/settings')]),
  ],
)
class AppShellRoute extends StatefulShellRouteData {
  const AppShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) =>
      AppShell(navigationShell: navigationShell);
}

class SearchBranch extends StatefulShellBranchData { const SearchBranch(); }
class ShelfBranch extends StatefulShellBranchData { const ShelfBranch(); }
class SettingsBranch extends StatefulShellBranchData { const SettingsBranch(); }

class SearchRoute extends GoRouteData with $SearchRoute {
  const SearchRoute({this.query, this.page});
  final String? query;
  final int? page;
  @override
  Widget build(BuildContext context, GoRouterState state) => SearchScreen(query: query ?? '', page: page ?? 1);
}

class BookDetailRoute extends GoRouteData with $BookDetailRoute {
  const BookDetailRoute({required this.bookId});
  final String bookId;
  @override
  Widget build(BuildContext context, GoRouterState state) => BookDetailScreen(bookId: bookId);
}

class ReadingEditRoute extends GoRouteData with $ReadingEditRoute {
  const ReadingEditRoute({required this.bookId});
  final String bookId;
  @override
  Widget build(BuildContext context, GoRouterState state) => ReadingEditorScreen(bookId: bookId);
}

class ShelfRoute extends GoRouteData with $ShelfRoute {
  const ShelfRoute({this.status});
  final ReadingStatus? status;
  @override
  Widget build(BuildContext context, GoRouterState state) => ShelfScreen(filter: status);
}

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const SettingsScreen();
}

final appRouter = GoRouter(
  routes: $appRoutes,
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(),
    body: Center(child: Text(context.l.bookNotFound)),
  ),
);
