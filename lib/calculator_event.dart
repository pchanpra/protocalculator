import 'calculator_operator.dart';

abstract class CalculatorEvent {}

class CalculatorClearEvent extends CalculatorEvent {}

class CalculatorCalculateEvent extends CalculatorEvent {
  final String value;
  final CalculatorOperator? operator;

  CalculatorCalculateEvent({required this.value, this.operator});
}
