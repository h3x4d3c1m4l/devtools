import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:h3x_devtools/main.reflectable.dart';
import 'package:h3x_devtools/solvers/advent_of_code/aoc_solver.dart';
import 'package:h3x_devtools/storage.dart';
import 'package:h3x_devtools/views/challenge_solver_view.dart';
import 'package:h3x_devtools/views/overlay_effects.dart';
import 'package:h3x_devtools/views/settings_screen.dart';
import 'package:intl/intl.dart';
import 'package:reflectable/reflectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

// Imports needed for Reflectable to find the solvers:

// ignore: unused_import, directives_ordering
import 'package:h3x_devtools/solvers/advent_of_code/2021/_all_solvers.dart' as aoc2021;
// ignore: unused_import, directives_ordering
import 'package:h3x_devtools/solvers/advent_of_code/2022/_all_solvers.dart' as aoc2022;
// ignore: unused_import, directives_ordering
import 'package:h3x_devtools/solvers/advent_of_code/2023/_all_solvers.dart' as aoc2023;
// ignore: unused_import, directives_ordering
import 'package:h3x_devtools/solvers/advent_of_code/2024/_all_solvers.dart' as aoc2024;

part 'main.panel_items.dart';

class Reflector extends Reflectable {
  const Reflector() : super(subtypeQuantifyCapability, newInstanceCapability, typeRelationsCapability);
}

const reflector = Reflector();

void main() async {
  initializeReflectable();

  // add OFL for Inconsolata font
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();

  await Highlighter.initialize(['dart']);
  prefs = await SharedPreferences.getInstance();

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
      debugShowCheckedModeBanner: false,
    );
  }

}

int _calculateSelectedIndex(BuildContext context) {
  final location = GoRouterState.of(context).uri.path;
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
          actions: Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text("Running on ${kIsWasm ? 'WASM' : kIsWeb ? 'JS' : 'desktop/mobile'}"),
            ),
          ),
        ),
        pane: NavigationPane(
          selected: _calculateSelectedIndex(context),
          items: _rootPaneItems,
          footerItems: _footerPaneItems,
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
