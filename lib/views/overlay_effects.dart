import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:live_background/live_background.dart';
import 'package:live_background/widget/live_background_widget.dart';

class OverlayEffects extends StatefulWidget {

  const OverlayEffects({super.key});

  @override
  State<StatefulWidget> createState() => _OverlayEffectsState();

}

class _OverlayEffectsState extends State<OverlayEffects> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all()),
            clipBehavior: Clip.hardEdge,
            child: FittedBox(
              child: SizedBox(
                width: 300,
                height: 200,
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    Container(
                      foregroundDecoration: const BoxDecoration(color: Color(0x88000000)),
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaY: 16, sigmaX: 16),
                        child: Image.asset("assets/christian-buehner-DItYlc26zVI-unsplash.jpg"),
                      ),
                    ),
                    const LiveBackgroundWidget(
                      palette: Palette(colors: [Colors.white]),
                      particleCount: 10000,
                      velocityX: 1,
                      velocityY: 0.6,
                      particleMinSize: 0.1,
                      particleMaxSize: 0.2,
                      blurSigmaX: 0,
                      blurSigmaY: 0,
                      clipBoundary: false,
                    ),
                    const LiveBackgroundWidget(
                      palette: Palette(colors: [Colors.white]),
                      particleCount: 10000,
                      velocityX: 0.1,
                      velocityY: -0.4,
                      particleMinSize: 0.1,
                      particleMaxSize: 0.2,
                      blurSigmaX: 0,
                      blurSigmaY: 0,
                      clipBoundary: false,
                    ),
                    const LiveBackgroundWidget(
                      palette: Palette(colors: [Colors.white]),
                      particleCount: 10000,
                      velocityX: -0.5,
                      velocityY: -0.1,
                      particleMinSize: 0.1,
                      particleMaxSize: 0.2,
                      blurSigmaX: 0,
                      blurSigmaY: 0,
                      clipBoundary: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
