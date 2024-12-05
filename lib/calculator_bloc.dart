import 'calculator_operator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculator_state.dart';
import 'calculator_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() 
      : super(CalculatorState(
            calculatorText: "",
            firstNumber: 0,
            secondNumber: 0,
            currentOperator: null,
            lastPressed: "",
            negative: false)) {
    on<CalculatorClearEvent>((event, emit) => emit(clear()));
    on<CalculatorCalculateEvent>((event, emit) async => emit(await calculate(event.value, event.operator)));
    on<CalculatorInitializeEvent>((event, emit) async => emit(await _initialize()));
  }

  Future<CalculatorState> _initialize() async {
    final calculatorText = await asyncPrefs.getString('calculatorText');
    return CalculatorState(
      calculatorText: calculatorText ?? "",
      firstNumber: state.firstNumber,
      secondNumber: state.secondNumber,
      currentOperator: state.currentOperator,
      lastPressed: state.lastPressed,
      negative: state.negative
    );
  }

  CalculatorState clear() {
    return CalculatorState(
      calculatorText: "",
      firstNumber: 0,
      secondNumber: 0,
      currentOperator: null,
      lastPressed: "",
      negative: false
    );
  }

  Future<CalculatorState> calculate(String value, CalculatorOperator? operator) async{
    String calculatorText = state.calculatorText;
    num firstNumber = state.firstNumber;
    num secondNumber = state.secondNumber;
    CalculatorOperator? currentOperator = state.currentOperator;
    bool negative = state.negative;
    String lastPressed = state.lastPressed;
    if (operator != null) {
      if (lastPressed != "") {
        if (operator == CalculatorOperator.equal && currentOperator != null) {
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
        } else if (currentOperator == null && calculatorText != "" && operator != CalculatorOperator.equal) {
          currentOperator = operator;
          calculatorText += value;
        }
      } else if (operator == CalculatorOperator.subtract) {
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
    await asyncPrefs.setString('calculatorText',calculatorText);
    return CalculatorState(
      calculatorText: calculatorText,
      firstNumber: firstNumber,
      secondNumber: secondNumber,
      currentOperator: currentOperator,
      lastPressed: value,
      negative: negative
    );
  }
}
