// ignore_for_file: use_key_in_widget_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class DartCodeViewer extends StatelessWidget {

  final String code;

  const DartCodeViewer(this.code);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.platformBrightnessOf(context);
    return FutureBuilder(
      // ignore: discarded_futures
      future: HighlighterTheme.loadForBrightness(brightness),
      builder: (context, snapshot) { 
        if (!snapshot.hasData) return const SizedBox();

        Highlighter highlighter = Highlighter(
          language: 'dart',
          theme: snapshot.data!,
        );

        TextSpan highlightedCode = highlighter.highlight(code);
        return SelectableText.rich(
          highlightedCode,
          style: GoogleFonts.inconsolata(
            fontSize: 16,
            height: 1.20,
            fontFeatures: [const FontFeature.enable('dlig')],
          ),
        );
      },
    );
  }

}
