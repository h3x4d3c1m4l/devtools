import 'dart:convert';
import 'dart:ui';

import 'package:aoc22/solvers/solver.dart';
import 'package:aoc22/views/code_viewer.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:google_fonts/google_fonts.dart';

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
        commandBar: Column(
          children: [
            Tooltip(
              message: "Show solver's Dart code",
              child: IconButton(icon: const Icon(FluentIcons.code), onPressed: () => _showCode(context)),
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

  void _showCode(BuildContext context) async {
    // load list of assets
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // find and read the code file asset
    String solverCodeFilename = widget.solver.dartCodeFilename;
    String solverCodeAssetPath = manifestMap.entries.where((entry) => entry.key.contains(solverCodeFilename)).single.value.first;
    String code = await rootBundle.loadString(solverCodeAssetPath);

    if (mounted) {
      _openCodeDialog(context, code);
    }
  }

  void _openCodeDialog(BuildContext context, String code) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ContentDialog(
        constraints: const BoxConstraints.expand(),
        title: Text('Code - ${widget.title}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
        content: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: CodeViewer(
            code: code,
            syntaxTheme: MediaQuery.platformBrightnessOf(context) == Brightness.light ? SyntaxTheme.vscodeLight() : SyntaxTheme.vscodeDark(),
            textStyle: GoogleFonts.inconsolata(
              fontSize: 16,
              height: 1.20,
              fontFeatures: [const FontFeature.enable('dlig')],
            ),
          ),
        ),
      ),
    );
  }

}
