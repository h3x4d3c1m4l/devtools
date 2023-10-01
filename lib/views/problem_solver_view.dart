import 'dart:async';
import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:h3x_devtools/solvers/solver.dart';
import 'package:h3x_devtools/views/code_viewer.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  final TextEditingController _inputEditingController = TextEditingController();

  Future<dynamic>? _solutionFuture;
  Duration? _solveDuration;

  void _solve() {
    Stopwatch stopwatch = Stopwatch()..start();
    try {
      String input = _inputEditingController.text;
      _solutionFuture = Future.value(widget.solver.getSolution(input));
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
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.globe),
              label: const Text("Open problem description"),
              onPressed: _openUrl,
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.code),
              label: const Text("View solver code"),
              onPressed: () => unawaited(_showCode(context)),
            ),
          ],
        ),
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
      controller: _inputEditingController,
      maxLines: null,
    );
  }

  Widget get _outputWidget {
    return FutureBuilder(
      future: _solutionFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // success
          return Center(
            child: material.SelectionArea(child: Text(snapshot.data ?? '')),
          );
        } else if (snapshot.hasError) {
          // exception
          return Center(
            child: material.SelectionArea(child: Text("Error: ${snapshot.error}")),
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

  Future<void> _showCode(BuildContext context) async {
    // load list of assets
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // find and read the code file asset
    String solverCodeFilename = widget.solver.solverCodeFilename;

    // Dirty hack to avoid error on .single
    var year = widget.solver.problemUrl.split('/')[3];

    // ignore: avoid_dynamic_calls
    String solverCodeAssetPath = manifestMap.entries.where((entry) => entry.key.contains(solverCodeFilename) && entry.key.contains(year)).single.value.first;
    String code = await rootBundle.loadString(solverCodeAssetPath);

    if (mounted) {
      await _openCodeDialog(context, code);
    }
  }

  Future<void> _openUrl() => launchUrlString(widget.solver.problemUrl);

  Future<void> _openCodeDialog(BuildContext context, String code) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ContentDialog(
        constraints: const BoxConstraints.expand(),
        title: Text('Code - ${widget.title}'),
        actions: [
          HyperlinkButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
        content: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: DartCodeViewer(code),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _inputEditingController.dispose();
  }

}
