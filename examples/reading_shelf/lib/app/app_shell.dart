import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/build_context_l10n.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final labels = [context.l.search, context.l.shelf, context.l.settings];
        if (constraints.maxWidth >= 760) {
          return Scaffold(
            body: Row(children: [
              NavigationRail(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: _goBranch,
                labelType: constraints.maxWidth >= 1100
                    ? NavigationRailLabelType.none
                    : NavigationRailLabelType.all,
                extended: constraints.maxWidth >= 1100,
                destinations: [
                  NavigationRailDestination(icon: const Icon(Icons.search_rounded), label: Text(labels[0])),
                  NavigationRailDestination(icon: const Icon(Icons.bookmarks_outlined), label: Text(labels[1])),
                  NavigationRailDestination(icon: const Icon(Icons.tune_rounded), label: Text(labels[2])),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: navigationShell),
            ]),
          );
        }
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _goBranch,
            destinations: [
              NavigationDestination(icon: const Icon(Icons.search_rounded), label: labels[0]),
              NavigationDestination(icon: const Icon(Icons.bookmarks_outlined), label: labels[1]),
              NavigationDestination(icon: const Icon(Icons.tune_rounded), label: labels[2]),
            ],
          ),
        );
      });
}
