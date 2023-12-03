import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:h3x_devtools/solvers/advent_of_code/2021/_all_solvers.dart' as aoc2021;
import 'package:h3x_devtools/solvers/advent_of_code/2022/_all_solvers.dart' as aoc2022;
import 'package:h3x_devtools/solvers/advent_of_code/2023/_all_solvers.dart' as aoc2023;
import 'package:h3x_devtools/solvers/solver.dart';
import 'package:h3x_devtools/views/challenge_solver_view.dart';
import 'package:h3x_devtools/views/overlay_effects.dart';
import 'package:intl/intl.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

part 'main.panel_items.dart';

void main() async {
  // add OFL for Inconsolata font
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();

  await Highlighter.initialize(['dart']);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
      title: 'Coding Challenges Tool',
      darkTheme: FluentThemeData.dark(),
      routerConfig: _router,
    );
  }

}

int _calculateSelectedIndex(BuildContext context) {
  final location = GoRouterState.of(context).uri.toString();
  return _routes.indexWhere((route) => route.path == location);
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _router = GoRouter(navigatorKey: _rootNavigatorKey, routes: [
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    routes: _routes,
    builder: (context, state, child) {
      return NavigationView(
        appBar: const NavigationAppBar(
          title: Text('h3x4d3c1m4l\'s Coding Challenges Tool'),
          automaticallyImplyLeading: false,
        ),
        pane: NavigationPane(
          selected: _calculateSelectedIndex(context),
          items: _rootPainItems,
        ),
        paneBodyBuilder: (item, _) {
          final name = item?.key is ValueKey ? (item!.key! as ValueKey).value : null;
          return FocusTraversalGroup(
            key: ValueKey('body$name'),
            child: child,
          );
        },
      );
    },
  ),
]);
