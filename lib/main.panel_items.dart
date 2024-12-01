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
  _adventOfCode2024PaneItem,
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
      _getAdventOfCodePaneItem(aoc2021.Day01Solver()),
      _getAdventOfCodePaneItem(aoc2021.Day02Solver()),
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
      _getAdventOfCodePaneItem(aoc2022.Day01Solver()),
      _getAdventOfCodePaneItem(aoc2022.Day02Solver()),
      _getAdventOfCodePaneItem(aoc2022.Day03Solver()),
      _getAdventOfCodePaneItem(aoc2022.Day04Solver()),
      _getAdventOfCodePaneItem(aoc2022.Day05Solver()),
      _getAdventOfCodePaneItem(aoc2022.Day06Solver()),
      _getAdventOfCodePaneItem(aoc2022.Day07Solver()),
      _getAdventOfCodePaneItem(aoc2022.Day08Solver()),
      _getAdventOfCodePaneItem(aoc2022.Day09Solver()),
      _getAdventOfCodePaneItem(aoc2022.Day10Solver()),
      _getAdventOfCodePaneItem(aoc2022.Day13Solver()),
      _getAdventOfCodePaneItem(aoc2022.Day14Solver()),
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
      _getAdventOfCodePaneItem(aoc2023.Day01Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day02Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day03Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day04Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day05Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day06Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day07Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day08Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day09Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day10Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day11Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day13Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day14Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day15Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day16Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day18Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day19Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day21Solver()),
      _getAdventOfCodePaneItem(aoc2023.Day23Solver()),
    ],
  );
}

_RoutingPaneItemExpander get _adventOfCode2024PaneItem {
  return _RoutingPaneItemExpander(
    routePath: '/aoc2024',
    icon: const Icon(FluentIcons.code),
    title: const Text('Advent of Code 2024'),
    routeBodyBuilder: (context, state) => const Center(child: Text("Choose a day from the sub menu")),
    items: [
      _getAdventOfCodePaneItem(aoc2024.Day01Solver()),
    ],
  );
}

_RoutingPaneItem _getAdventOfCodePaneItem(AdventOfCodeSolver solver) {
  String dayString = _dayNumberFormat.format(solver.dayNumber);

  return _RoutingPaneItem(
    routePath: '/aoc${solver.yearNumber}/day${solver.dayNumber}',
    icon: const Icon(FluentIcons.issue_solid),
    title: Text('Day $dayString'),
    routeBodyBuilder: (context, state) => ChallengeSolverView(
      title: "AoC ${solver.yearNumber} - Day $dayString",
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
