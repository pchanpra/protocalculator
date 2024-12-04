import 'calculator_operator.dart';

class CalculatorState {
  String calculatorText;
  num firstNumber;
  num secondNumber;
  CalculatorOperator? currentOperator;
  String lastPressed;
  bool negative;

  CalculatorState({
    required this.calculatorText,
    required this.firstNumber,
    required this.secondNumber,
    required this.currentOperator,
    required this.lastPressed,
    required this.negative,
  });
}
