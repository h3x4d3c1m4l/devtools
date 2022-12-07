// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class CodeViewer extends SyntaxView {

  final TextStyle? textStyle;

  CodeViewer({required super.code, super.syntaxTheme, this.textStyle});

  @override
  State<StatefulWidget> createState() => SyntaxViewState();
}

class SyntaxViewState extends State<CodeViewer> {
  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        style: widget.textStyle ?? TextStyle(fontFamily: 'monospace', fontSize: widget.fontSize),
        children: <TextSpan>[getSyntax(widget.syntaxTheme).format(widget.code)],
      ),
    );
  }
}
