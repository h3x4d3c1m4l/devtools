import 'package:flutter/widgets.dart';

abstract class Solver<TInput> {

  Widget getInputWidget(ValueChanged<TInput> onInputValueChanged);

  Widget getOutputWidget(TInput inputValue);

}
