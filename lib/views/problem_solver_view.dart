import 'package:aoc22/solvers/solver.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ProblemSolverView extends StatefulWidget {

  final String title;
  final Solver solver;

  const ProblemSolverView({
    super.key,
    required this.title,
    required this.solver,
  });

  @override
  State<ProblemSolverView> createState() => _ProblemSolverViewState();

}

class _ProblemSolverViewState extends State<ProblemSolverView> {

  Object? _value;

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return ScaffoldPage.withPadding(
      header: PageHeader(
        title: Text(widget.title),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // input
          Flexible(
            fit: FlexFit.tight,
            child: widget.solver.getInputWidget((value) => _value = value),
          ),

          // separator
          const SizedBox(height: 32),
          Container(
            height: 1,
            color: Colors.black,
          ),
          const SizedBox(height: 32),

          // output
          Flexible(
            fit: FlexFit.tight,
            child: widget.solver.getOutputWidget("123\r\n456"),
          ),
        ],
      ),
    );
  }

}
