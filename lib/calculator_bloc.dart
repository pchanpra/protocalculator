import 'calculator_operator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculator_state.dart';
import 'calculator_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
final db = FirebaseFirestore.instance;

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc()
      : super(CalculatorState(
            calculatorText: "",
            firstNumber: 0,
            secondNumber: 0,
            currentOperator: null,
            lastPressed: "",
            negative: false)) {
    on<CalculatorClearEvent>((event, emit) async => emit(await clear()));
    on<CalculatorCalculateEvent>((event, emit) async =>
        emit(await calculate(event.value, event.operator)));
    on<CalculatorInitializeEvent>(
        (event, emit) async => emit(await _initialize()));
  }

  Future<CalculatorState> _initialize() async {
    final calculatorText = await asyncPrefs.getString('calculatorText');
    String? uid;
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      uid = userCredential.user?.uid;
      return CalculatorState(
        calculatorText: calculatorText ?? "",
        firstNumber: state.firstNumber,
        secondNumber: state.secondNumber,
        currentOperator: state.currentOperator,
        lastPressed: state.lastPressed,
        negative: state.negative,
        uid: uid);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
    return CalculatorState(
        calculatorText: calculatorText ?? "",
        firstNumber: state.firstNumber,
        secondNumber: state.secondNumber,
        currentOperator: state.currentOperator,
        lastPressed: state.lastPressed,
        negative: state.negative);
  }

  Future<CalculatorState> clear() async {
    await asyncPrefs.setString('calculatorText', "");
    return CalculatorState(
        calculatorText: "",
        firstNumber: 0,
        secondNumber: 0,
        currentOperator: null,
        lastPressed: "",
        negative: false,
        uid: state.uid);
  }

  Future<CalculatorState> calculate(
      String value, CalculatorOperator? operator) async {
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
        } else if (currentOperator == null &&
            calculatorText != "" &&
            operator != CalculatorOperator.equal) {
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
    await asyncPrefs.setString('calculatorText', calculatorText);
    final userData = <String, String>{
      "calculatorText": calculatorText,
    };
    try {
      await db.collection("users").doc(state.uid).set(userData);
    } catch (e) {print(state.uid);print(e);}
    return CalculatorState(
        calculatorText: calculatorText,
        firstNumber: firstNumber,
        secondNumber: secondNumber,
        currentOperator: currentOperator,
        lastPressed: value,
        negative: negative,
        uid: state.uid);
  }
}
