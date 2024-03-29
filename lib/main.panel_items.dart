part of 'main.dart';

final NumberFormat _dayNumberFormat = NumberFormat('00');

// ////////// //
// Root items //
// ////////// //

final List<NavigationPaneItem> _rootPaneItems = [
  _RoutingPaneItem(
    routePath: '/',
    icon: const Icon(FluentIcons.home),
    title: const Text('Home'),
    routeBodyBuilder: (context, state) => const Center(
      child: Text("Welcome!"),
    ),
  ),
  _adventOfCode2021PaneItem,
  _adventOfCode2022PaneItem,
  _adventOfCode2023PaneItem,
  _overlayEffectsItem,
];

final List<GoRoute> _routes = [
  ..._rootPaneItems.map(_navigationPaneItemToGoRoutes).flattened,
  ..._footerPaneItems.map(_navigationPaneItemToGoRoutes).flattened,
];

// ////////////// //
// Advent of Code //
// ////////////// //

_RoutingPaneItemExpander get _adventOfCode2021PaneItem {
  return _RoutingPaneItemExpander(
    routePath: '/aoc2021',
    icon: const Icon(FluentIcons.code),
    title: const Text('Advent of Code 2021'),
    routeBodyBuilder: (context, state) => const Center(child: Text("Choose a day from the sub menu")),
    items: [
      _getAdventOfCodePaneItem(2021, 01, aoc2021.Day01Solver()),
      _getAdventOfCodePaneItem(2021, 02, aoc2021.Day02Solver()),
    ],
  );
}

_RoutingPaneItemExpander get _adventOfCode2022PaneItem {
  return _RoutingPaneItemExpander(
    routePath: '/aoc2022',
    icon: const Icon(FluentIcons.code),
    title: const Text('Advent of Code 2022'),
    routeBodyBuilder: (context, state) => const Center(child: Text("Choose a day from the sub menu")),
    items: [
      _getAdventOfCodePaneItem(2022, 01, aoc2022.Day01Solver()),
      _getAdventOfCodePaneItem(2022, 02, aoc2022.Day02Solver()),
      _getAdventOfCodePaneItem(2022, 03, aoc2022.Day03Solver()),
      _getAdventOfCodePaneItem(2022, 04, aoc2022.Day04Solver()),
      _getAdventOfCodePaneItem(2022, 05, aoc2022.Day05Solver()),
      _getAdventOfCodePaneItem(2022, 06, aoc2022.Day06Solver()),
      _getAdventOfCodePaneItem(2022, 07, aoc2022.Day07Solver()),
      _getAdventOfCodePaneItem(2022, 08, aoc2022.Day08Solver()),
      _getAdventOfCodePaneItem(2022, 09, aoc2022.Day09Solver()),
      _getAdventOfCodePaneItem(2022, 10, aoc2022.Day10Solver()),
      _getAdventOfCodePaneItem(2022, 13, aoc2022.Day13Solver()),
      _getAdventOfCodePaneItem(2022, 14, aoc2022.Day14Solver()),
    ],
  );
}

_RoutingPaneItemExpander get _adventOfCode2023PaneItem {
  return _RoutingPaneItemExpander(
    routePath: '/aoc2023',
    icon: const Icon(FluentIcons.code),
    title: const Text('Advent of Code 2023'),
    routeBodyBuilder: (context, state) => const Center(child: Text("Choose a day from the sub menu")),
    items: [
      _getAdventOfCodePaneItem(2023, 01, aoc2023.Day01Solver()),
      _getAdventOfCodePaneItem(2023, 02, aoc2023.Day02Solver()),
      _getAdventOfCodePaneItem(2023, 03, aoc2023.Day03Solver()),
      _getAdventOfCodePaneItem(2023, 04, aoc2023.Day04Solver()),
      _getAdventOfCodePaneItem(2023, 05, aoc2023.Day05Solver()),
      _getAdventOfCodePaneItem(2023, 06, aoc2023.Day06Solver()),
      _getAdventOfCodePaneItem(2023, 07, aoc2023.Day07Solver()),
      _getAdventOfCodePaneItem(2023, 08, aoc2023.Day08Solver()),
      _getAdventOfCodePaneItem(2023, 09, aoc2023.Day09Solver()),
      _getAdventOfCodePaneItem(2023, 10, aoc2023.Day10Solver()),
      _getAdventOfCodePaneItem(2023, 11, aoc2023.Day11Solver()),
      _getAdventOfCodePaneItem(2023, 13, aoc2023.Day13Solver()),
      _getAdventOfCodePaneItem(2023, 14, aoc2023.Day14Solver()),
      _getAdventOfCodePaneItem(2023, 15, aoc2023.Day15Solver()),
      _getAdventOfCodePaneItem(2023, 16, aoc2023.Day16Solver()),
      _getAdventOfCodePaneItem(2023, 18, aoc2023.Day18Solver()),
      _getAdventOfCodePaneItem(2023, 19, aoc2023.Day19Solver()),
      _getAdventOfCodePaneItem(2023, 21, aoc2023.Day21Solver()),
      _getAdventOfCodePaneItem(2023, 23, aoc2023.Day23Solver()),
    ],
  );
}

_RoutingPaneItem _getAdventOfCodePaneItem(int year, int day, Solver solver) {
  String dayString = _dayNumberFormat.format(day);

  return _RoutingPaneItem(
    routePath: '/aoc$year/day$day',
    icon: const Icon(FluentIcons.issue_solid),
    title: Text('Day $dayString'),
    routeBodyBuilder: (context, state) => ChallengeSolverView(
      title: "AoC $year - Day $dayString",
      solver: solver,
      openCodeDialog: state.uri.queryParameters['openCodeView'] == 'true',
    ),
  );
}

// ///// //
// Other //
// ///// //

_RoutingPaneItem get _overlayEffectsItem {
  return _RoutingPaneItem(
    routePath: '/overlayeffects',
    icon: const Icon(FluentIcons.code),
    title: const Text('Overlay effects'),
    routeBodyBuilder: (context, state) => const Center(child: OverlayEffects()),
  );
}

// ////// //
// Footer //
// ////// //

final List<NavigationPaneItem> _footerPaneItems = [
  _RoutingPaneItem(
    routePath: '/settings',
    icon: const Icon(FluentIcons.settings),
    title: const Text('Settings'),
    routeBodyBuilder: (context, state) => const SettingsScreen(),
  ),
];

// /////// //
// Helpers //
// /////// //

List<GoRoute> _navigationPaneItemToGoRoutes(NavigationPaneItem item) => switch (item) {
      _RoutingPaneItem() => [item.goRoute],
      _RoutingPaneItemExpander() => [item.goRoute, ...item.itemGoRoutes],
      _ => throw Exception('Cannot convert unsupported type <${item.runtimeType}> to GoRoute')
    };

class _RoutingPaneItemExpander extends PaneItemExpander {

  final String routePath;
  final GoRouterWidgetBuilder routeBodyBuilder;

  _RoutingPaneItemExpander({
    required super.icon,
    required super.title,
    required super.items,
    required this.routePath,
    required this.routeBodyBuilder,
  }) : super(
          key: ValueKey(routePath),
          body: const SizedBox.shrink(),
          onTap: () => _router.go(routePath),
        );

  GoRoute get goRoute => GoRoute(
        path: routePath,
        builder: routeBodyBuilder,
      );

  List<GoRoute> get itemGoRoutes => items.map((item) => switch (item) {
    _RoutingPaneItem() => [item.goRoute],
    _RoutingPaneItemExpander() => [item.goRoute, ...item.itemGoRoutes],
    _ => throw Exception('Cannot convert unsupported type <${item.runtimeType}> to GoRoute')
  }).flattened.toList();

}

class _RoutingPaneItem extends PaneItem {

  final String routePath;
  final GoRouterWidgetBuilder routeBodyBuilder;

  _RoutingPaneItem({
    required super.icon,
    required super.title,
    required this.routePath,
    required this.routeBodyBuilder,
  }) : super(
          key: ValueKey(routePath),
          body: const SizedBox.shrink(),
          onTap: () => _router.go(routePath),
        );

  GoRoute get goRoute => GoRoute(
        path: routePath,
        builder: routeBodyBuilder,
      );

}
