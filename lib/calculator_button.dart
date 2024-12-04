import 'package:flutter/material.dart';
import 'calculator_operator.dart';
import 'theme.dart';

/*
  Manages the buttons in the calculator.
*/

class CalculatorButton extends StatelessWidget {
  final String text;
  final Function(String, CalculatorOperator?) onPressed;
  final CalculatorOperator? operator;
  const CalculatorButton({
    required this.text,
    required this.onPressed,
    this.operator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        child: Text(text, style: Theme.of(context).buttonText),
        onPressed: () => onPressed(text, operator),
      ),
    );
  }
}