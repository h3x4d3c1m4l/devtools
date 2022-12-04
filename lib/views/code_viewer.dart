// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:google_fonts/google_fonts.dart';

class CodeViewer extends SyntaxView {

  CodeViewer({required super.code, super.syntaxTheme, super.fontSize});

  @override
  State<StatefulWidget> createState() => SyntaxViewState();
}

class SyntaxViewState extends State<SyntaxView> {
  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        style: GoogleFonts.firaCode(fontSize: widget.fontSize),
        children: <TextSpan>[getSyntax(widget.syntaxTheme).format(widget.code)],
      ),
    );
  }
}
