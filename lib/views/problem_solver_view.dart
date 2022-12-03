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
  Future<dynamic>? _solutionFuture;
  Duration? _solveDuration;

  void _solve() {
    Stopwatch stopwatch = Stopwatch()..start();
    try {
      _solutionFuture = Future.value(widget.solver.getSolution(_value));
    } catch (exception) {
      _solutionFuture = Future.error(exception);
    }
    _solveDuration = stopwatch.elapsed;

    setState(() {});
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
          Flexible(
            fit: FlexFit.tight,
            child: _inputWidget,
          ),
          const SizedBox(height: 32),
          _dividerWidget,
          const SizedBox(height: 32),
          Flexible(
            fit: FlexFit.tight,
            child: _outputWidget,
          ),
        ],
      ),
      bottomBar: _bottomBarWidget,
    );
  }

  Widget get _bottomBarWidget {
    return FutureBuilder(
      future: _solutionFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // success
          return _getInfoBar(InfoBarSeverity.success, "Success", "Solving succeeded after $_solveDuration");
        } else if (snapshot.hasError) {
          // exception
          return _getInfoBar(InfoBarSeverity.error, "Error", "Solving failed after $_solveDuration");
        } else {
          // not started yet
          return const SizedBox();
        }
      },
    );
  }

    Widget _getInfoBar(InfoBarSeverity severity, String title, String content) {
      return SizedBox(
        width: double.infinity,
        child: InfoBar(
          title: Text(title),
          severity: severity,
          content: Text(content),
        ),
      );
    }

  Widget get _dividerWidget {
    return Row(
      children: [
        const Flexible(
          fit: FlexFit.tight,
          child: Divider(),
        ),
        FilledButton(
          onPressed: _solve,
          child: const Text('Solve'),
        ),
        const Flexible(
          fit: FlexFit.tight,
          child: Divider(),
        ),
      ],
    );
  }

  Widget get _inputWidget {
    return TextBox(
      initialValue: _value ?? '',
      maxLines: null,
      onChanged: (value) {
        setState(() {
          _value = value;
        });
      },
    );
  }

  Widget get _outputWidget {
    return FutureBuilder(
      future: _solutionFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // success
          return Center(
            child: Text(snapshot.data ?? ''),
          );
        } else if (snapshot.hasError) {
          // exception
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (_solutionFuture != null) {
          // solving
          return const Center(
            child: ProgressRing(),
          );
        } else {
          // not started yet
          return const Center(
            child: Text('Click Solve to run this solver'),
          );
        }
      },
    );
  }

}
