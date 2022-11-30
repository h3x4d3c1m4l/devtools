import 'package:aoc22/solvers/solver.dart';
import 'package:fluent_ui/fluent_ui.dart';

class Day01Solver extends Solver<String> {
  
  @override
  Widget getInputWidget(ValueChanged<String> onInputValueChanged) {
    return TextBox(
      onChanged: onInputValueChanged,
    );
  }

  @override
  Widget getOutputWidget(String inputValue) {
    List<String> inputLines = inputValue.split('\r\n');

    int nLargerThanPrevious = 0;
    int? previousValue;
    for (String line in inputLines) {
      int currentValue = int.parse(line);

      if (previousValue != null && currentValue > previousValue) {
        nLargerThanPrevious++;
      }

      previousValue = currentValue;
    }

    return TextBox(
      readOnly: true,
      initialValue: nLargerThanPrevious.toString(),
    );
  }

}
