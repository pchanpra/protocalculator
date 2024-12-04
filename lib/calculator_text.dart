import 'package:flutter/material.dart';
import 'calculator_operator.dart';

/*
  Manages the text displayed in the calculator.
*/

class CalculatorText extends ChangeNotifier {
  var calculatorText = "";
  num firstNumber = 0;
  num secondNumber = 0;
  CalculatorOperator? currentOperator;
  var lastPressed = "";
  bool negative = false;

  void clear(String value, CalculatorOperator? operator) {
    calculatorText = "";
    firstNumber = 0;
    secondNumber = 0;
    currentOperator = null;
    lastPressed = "";
    negative = false;
    notifyListeners();
  }

  void calculate(String value, CalculatorOperator? operator) {
    if (operator != null) {
      if (lastPressed != "") {
        if (operator == CalculatorOperator.equal) {
          switch (currentOperator) {
            case CalculatorOperator.add:
              firstNumber = negative
                  ? -firstNumber + secondNumber
                  : firstNumber + secondNumber;
              break;
            case CalculatorOperator.subtract:
              firstNumber = negative
                  ? -firstNumber - secondNumber
                  : firstNumber - secondNumber;
              break;
            case CalculatorOperator.multiply:
              firstNumber = negative
                  ? -firstNumber * secondNumber
                  : firstNumber * secondNumber;
              break;
            case CalculatorOperator.divide:
              if (secondNumber == 0) {
                calculatorText = ":(";
              } else if (firstNumber % secondNumber == 0) {
                firstNumber = negative
                    ? -firstNumber ~/ secondNumber
                    : firstNumber ~/ secondNumber;
              } else {
                firstNumber = negative
                    ? -firstNumber / secondNumber
                    : firstNumber / secondNumber;
              }
              break;
            default:
              break;
          }
          if (firstNumber is int) {
            //handle integers
            calculatorText = firstNumber.toString();
          } else {
            //handle decimals
            calculatorText = firstNumber
                .toStringAsFixed(10 - firstNumber.toStringAsFixed(0).length);
          }
          currentOperator = null;
          secondNumber = 0;
          negative = false;
        } else if (currentOperator == null && calculatorText != "") {
          currentOperator = operator;
          calculatorText += value;
        }
      } else if (value == '-') {
        //handle negative numbers
        calculatorText += value;
        negative = true;
      }
    } else if (value != "C") {
      if (lastPressed == "" || lastPressed == '=') {
        calculatorText = value;
        firstNumber = int.parse(value);
      } else {
        if (currentOperator == null) {
          firstNumber = firstNumber * 10 + int.parse(value);
          calculatorText += value;
        } else {
          secondNumber = secondNumber * 10 + int.parse(value);
          calculatorText += value;
        }
      }
    }
    lastPressed = value;
    notifyListeners();
  }
}
