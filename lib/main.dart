import 'package:aoc22/views/problem_solver_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

import 'solvers/_all_solvers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  static final NumberFormat _dayNumberFormat = NumberFormat('00');
  int _topIndex = 0;
  List<NavigationPaneItem>? _rootPainItems;
  
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Coding Challenges Tool',
      home: NavigationView(
        appBar: const NavigationAppBar(
          title: Text('h3x4d3c1m4l\'s Coding Challenges Tool'),
          automaticallyImplyLeading: false,
        ),
        pane: NavigationPane(
          selected: _topIndex,
          onChanged: (index) => setState(() => _topIndex = index),
          items: _getPaneItems(),
        ),
      ),
    );
  }

  List<NavigationPaneItem> _getPaneItems() {
    return _rootPainItems ??= [
      PaneItem(
        icon: const Icon(FluentIcons.home),
        title: const Text('Home'),
        body: const Center(
          child: Text("Welcome!"),
        ),
      ),
      _adventOfCode2021PaneItem,
      _adventOfCode2022PaneItem,
    ];
  }

  PaneItemExpander get _adventOfCode2021PaneItem {
    return PaneItemExpander(
      icon: const Icon(FluentIcons.code),
      title: const Text('Advent of Code 2021'),
      body: const Center(child: Text("Choose a day from the sub menu")),
      items: [
        _getAdventOfCodePaneItem(2021, 01, Year2021Day01Solver()),
      ],
    );
  }

  PaneItemExpander get _adventOfCode2022PaneItem {
    return PaneItemExpander(
      icon: const Icon(FluentIcons.code),
      title: const Text('Advent of Code 2022'),
      body: const Center(child: Text("Choose a day from the sub menu")),
      items: [
        _getAdventOfCodePaneItem(2022, 01, Year2022Day01Solver()),
        _getAdventOfCodePaneItem(2022, 02, Year2022Day02Solver()),
        _getAdventOfCodePaneItem(2022, 03, Year2022Day03Solver()),
        _getAdventOfCodePaneItem(2022, 04, Year2022Day04Solver()),
        _getAdventOfCodePaneItem(2022, 05, Year2022Day05Solver()),
      ],
    );
  }

  PaneItem _getAdventOfCodePaneItem(int year, int day, Solver solver) {
    String dayString = _dayNumberFormat.format(day);

    return PaneItem(
      icon: const Icon(FluentIcons.issue_solid),
      title: Text('Day $dayString'),
      body: ProblemSolverView(title: "AoC $year - Day $dayString", solver: solver),
    );
  }

}
