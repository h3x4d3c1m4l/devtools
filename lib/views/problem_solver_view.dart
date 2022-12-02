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

  dynamic _value;
  dynamic _solution;

  void _updateSolution() {
    setState(() {
      _solution = widget.solver.getSolution(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
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
            child: TextBox(
              initialValue: _value ?? '',
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  _value = value;
                  _updateSolution();
                });
              },
            ),
          ),

          // separator
          const SizedBox(height: 32),
          _getDivider(),
          const SizedBox(height: 32),

          // output
          Flexible(
            fit: FlexFit.tight,
            child: TextBox(
              initialValue: _solution ?? '',
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDivider() {
    return Row(
      children: [
        const Flexible(
          fit: FlexFit.tight,
          child: Divider(),
        ),
        Button(child: const Text('test'), onPressed: () => {}),
        const Flexible(
          fit: FlexFit.tight,
          child: Divider(),
        ),
      ],
    );
  }

}
