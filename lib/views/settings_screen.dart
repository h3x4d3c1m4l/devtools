import 'package:fluent_ui/fluent_ui.dart';
import 'package:h3x_devtools/storage.dart';

class SettingsScreen extends StatefulWidget {

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();

}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text("Settings"),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Button(
            onPressed: _onSetAocSessionTokenClicked,
            child: const Text('Set Advent of Code session token'),
          ),
        ],
      ),
    );
  }

  Future<void> _onSetAocSessionTokenClicked() async {
    String? sessionToken = await showDialog<String>(
      context: context,
      builder: (context) {
        String inputValue = '';

        return ContentDialog(
          title: const Text('Advent of Code session'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Paste your Advent of Code session cookie here:'),
              const SizedBox(height: 16.0),
              TextBox(
                autofocus: true,
                onChanged: (y) => inputValue = y,
              ),
            ],
          ),
          actions: [
            Button(
              child: const Text('Save'),
              onPressed: () => Navigator.pop(context, inputValue),
            ),
            FilledButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context, null),
            ),
          ],
        );
      },
    );

    if (sessionToken != null) {
      await setAdventOfCodeSession(sessionToken);
    }
  }

}
