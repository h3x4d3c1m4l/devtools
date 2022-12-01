import 'package:aoc22/solvers/advent_of_code_2021/day_01_solver.dart' as aoc2101;
import 'package:aoc22/solvers/advent_of_code_2022/day_01_solver.dart' as aoc2201;
import 'package:aoc22/views/problem_solver_view.dart';
import 'package:fluent_ui/fluent_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  int topIndex = 0;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Flutter Demo',
      home: NavigationView(
        appBar: const NavigationAppBar(
          title: Text('Advent of Code'),
          automaticallyImplyLeading: false,
        ),
        pane: NavigationPane(
          selected: topIndex,
          onChanged: (index) => setState(() => topIndex = index),
          displayMode: PaneDisplayMode.open,
          items: _getPaneItems(),
        ),
      ),
    );
  }

  List<NavigationPaneItem> _getPaneItems() {
    return [
      PaneItem(
        icon: const Icon(FluentIcons.home),
        title: const Text('Home'),
        body: Text("Body 1"),
      ),
      PaneItemExpander(
        icon: const Icon(FluentIcons.code),
        title: const Text('Advent of Code 2021'),
        body: const Center(child: Text("Choose a day from the sub menu")),
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.mail),
            title: const Text('Day 01'),
            body: ProblemSolverView(title: "AoC 2021 - Day 01", solver: aoc2101.Day01Solver()),
          ),
        ],
      ),
      PaneItemExpander(
        icon: const Icon(FluentIcons.code),
        title: const Text('Advent of Code 2022'),
        body: const Center(child: Text("Choose a day from the sub menu")),
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.mail),
            title: const Text('Day 01'),
            body: ProblemSolverView(title: "AoC 2021 - Day 01", solver: aoc2201.Day01Solver()),
          ),
        ],
      ),
    ];
  }

}
