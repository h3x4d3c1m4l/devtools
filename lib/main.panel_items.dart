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
  _getAdventOfCodePaneItems(2021),
  _getAdventOfCodePaneItems(2022),
  _getAdventOfCodePaneItems(2023),
  _getAdventOfCodePaneItems(2024),
  _overlayEffectsItem,
];

final List<GoRoute> _routes = [
  ..._rootPaneItems.map(_navigationPaneItemToGoRoutes).flattened,
  ..._footerPaneItems.map(_navigationPaneItemToGoRoutes).flattened,
];

// ////////////// //
// Advent of Code //
// ////////////// //

_RoutingPaneItemExpander _getAdventOfCodePaneItems(int year) {
  // First find all AoC $year classes through reflection.
  String baseClassName = 'AdventOfCode${year}Solver';
  TypeMirror baseClassMirror = reflector.annotatedClasses.firstWhere((classMirror) => classMirror.simpleName == baseClassName);
  List<ClassMirror> solverClassMirrors = reflector.annotatedClasses.where((classMirror) {
    // Accessing `superclass` will throw an error when it's not supported. Just skip those.
    try { return classMirror.superclass == baseClassMirror; } catch (_) {  return false; }
  }).toList();

   return _RoutingPaneItemExpander(
    routePath: '/aoc$year',
    icon: const Icon(FluentIcons.code),
    title: Text('Advent of Code $year'),
    routeBodyBuilder: (context, state) => const Center(child: Text("Choose a day from the sub menu")),
    items: [
      // Create new solver instances using reflection.
      for (var solverClassMirror in solverClassMirrors)
        _getAdventOfCodePaneItem(solverClassMirror.newInstance('', const []) as AdventOfCodeSolver),
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
