import 'package:fluent_ui/fluent_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int topIndex = 0;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Flutter Demo',
      home: NavigationView(
        appBar: const NavigationAppBar(
          title: Text('NavigationView'),
        ),
        pane: NavigationPane(
          selected: topIndex,
          onChanged: (index) => setState(() => topIndex = index),
          displayMode: PaneDisplayMode.open,
          items: [
            PaneItem(
              icon: const Icon(FluentIcons.home),
              title: const Text('Home'),
              body: Text("Body 1"),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.issue_tracking),
              title: const Text('Track an order'),
              infoBadge: const InfoBadge(source: Text('8')),
              body: Text("Body 1"),
            ),
            PaneItemExpander(
              icon: const Icon(FluentIcons.account_management),
              title: const Text('Account'),
              body: Text("Body 1"),
              items: [
                PaneItem(
                  icon: const Icon(FluentIcons.mail),
                  title: const Text('Mail'),
                  body: Text("Body 1"),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.calendar),
                  title: const Text('Calendar'),
                  body: Text("Body 1"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
