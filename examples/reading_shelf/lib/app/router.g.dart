// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$appShellRoute];

RouteBase get $appShellRoute => StatefulShellRouteData.$route(
  factory: $AppShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/',
          hasOverriddenOnExit: false,
          factory: $SearchRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'books/:bookId',
              hasOverriddenOnExit: false,
              factory: $BookDetailRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'reading',
                  hasOverriddenOnExit: false,
                  factory: $ReadingEditRoute._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/shelf',
          hasOverriddenOnExit: false,
          factory: $ShelfRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/settings',
          hasOverriddenOnExit: false,
          factory: $SettingsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $AppShellRouteExtension on AppShellRoute {
  static AppShellRoute _fromState(GoRouterState state) => const AppShellRoute();
}

mixin $SearchRoute on GoRouteData {
  static SearchRoute _fromState(GoRouterState state) => SearchRoute(
    query: state.uri.queryParameters['query'],
    page: _$convertMapValue('page', state.uri.queryParameters, int.tryParse),
  );

  SearchRoute get _self => this as SearchRoute;

  @override
  String get location => GoRouteData.$location(
    '/',
    queryParams: {
      if (_self.query != null) 'query': _self.query,
      if (_self.page != null) 'page': _self.page!.toString(),
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BookDetailRoute on GoRouteData {
  static BookDetailRoute _fromState(GoRouterState state) =>
      BookDetailRoute(bookId: state.pathParameters['bookId']!);

  BookDetailRoute get _self => this as BookDetailRoute;

  @override
  String get location =>
      GoRouteData.$location('/books/${Uri.encodeComponent(_self.bookId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ReadingEditRoute on GoRouteData {
  static ReadingEditRoute _fromState(GoRouterState state) =>
      ReadingEditRoute(bookId: state.pathParameters['bookId']!);

  ReadingEditRoute get _self => this as ReadingEditRoute;

  @override
  String get location => GoRouteData.$location(
    '/books/${Uri.encodeComponent(_self.bookId)}/reading',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ShelfRoute on GoRouteData {
  static ShelfRoute _fromState(GoRouterState state) => ShelfRoute(
    status: _$convertMapValue(
      'status',
      state.uri.queryParameters,
      _$ReadingStatusEnumMap._$fromName,
    ),
  );

  ShelfRoute get _self => this as ShelfRoute;

  @override
  String get location => GoRouteData.$location(
    '/shelf',
    queryParams: {
      if (_self.status != null) 'status': _$ReadingStatusEnumMap[_self.status!],
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

const _$ReadingStatusEnumMap = {
  ReadingStatus.wantToRead: 'want-to-read',
  ReadingStatus.reading: 'reading',
  ReadingStatus.finished: 'finished',
};

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

extension<T extends Enum> on Map<T, String> {
  T? _$fromName(String? value) =>
      entries.where((element) => element.value == value).firstOrNull?.key;
}
