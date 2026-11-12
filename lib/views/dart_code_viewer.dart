import 'package:code_forge/code_forge.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:re_highlight/languages/dart.dart';
import 'package:re_highlight/styles/vs.dart';
import 'package:re_highlight/styles/vs2015.dart';

class DartCodeViewer extends StatelessWidget {

  final String code;

  const DartCodeViewer(this.code, {super.key});

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.platformBrightnessOf(context);
    return CodeForge(
      initialText: code,
      readOnly: true,
      language: langDart,
      editorTheme: brightness == Brightness.dark ? vs2015Theme : vsTheme,
      enableMinimap: false,
      textStyle: GoogleFonts.inconsolata(
        fontSize: 16,
        height: 1.20,
        fontFeatures: [const FontFeature.enable('dlig')],
      ),
    );
  }

}
