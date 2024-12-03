import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProtoCalculator',
      theme: ThemeData(
        colorScheme: const ColorScheme(
            primary: Colors.white,
            brightness: Brightness.light,
            onPrimary: Colors.black,
            secondary: Color(0xFFf8f8f8),
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black),
        useMaterial3: true,
        extensions: const <ThemeExtension<dynamic>>[
          CustomTextStyle(
              buttonText: TextStyle(fontSize: 37, color: Colors.black),
              mathText: TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ],
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme(
              primary: Color(0xFF1c1c1c),
              brightness: Brightness.dark,
              onPrimary: Color(0xFFfcfcfc),
              secondary: Color(0xFF313131),
              onSecondary: Colors.white,
              error: Colors.red,
              onError: Colors.white,
              surface: Color(0xFF1c1c1c),
              onSurface: Colors.white),
          useMaterial3: true,
          extensions: const <ThemeExtension<dynamic>>[
            CustomTextStyle(
                buttonText: TextStyle(fontSize: 37, color: Color(0xFFfcfcfc)),
                mathText: TextStyle(
                    fontSize: 50,
                    color: Color(0xFFfcfcfc),
                    fontWeight: FontWeight.bold)),
          ]),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
    );
  }
}

class CustomTextStyle extends ThemeExtension<CustomTextStyle> {
  final TextStyle buttonText;
  final TextStyle mathText;

  const CustomTextStyle({required this.buttonText, required this.mathText});

  @override
  CustomTextStyle copyWith({TextStyle? buttonText, TextStyle? mathText}) {
    return CustomTextStyle(
      buttonText: buttonText ?? this.buttonText,
      mathText: mathText ?? this.mathText,
    );
  }

  @override
  CustomTextStyle lerp(CustomTextStyle? other, double t) {
    if (other is! CustomTextStyle) return this;
    return CustomTextStyle(
      buttonText: TextStyle.lerp(buttonText, other.buttonText, t)!,
      mathText: TextStyle.lerp(mathText, other.mathText, t)!,
    );
  }
}

enum CalculatorOperator {
  add,
  subtract,
  multiply,
  divide,
  equal,
}

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
        child: Text(text,
            style: Theme.of(context).extension<CustomTextStyle>()?.buttonText),
        onPressed: () => onPressed(text, operator),
      ),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var calculatorText = "";
  num firstNumber = 0;
  num secondNumber = 0;
  CalculatorOperator? currentOperator;
  var lastPressed = "";
  bool negative = false;

  void clear(String value, CalculatorOperator? operator) {
    setState(() {
      calculatorText = "";
      firstNumber = 0;
      secondNumber = 0;
      currentOperator = null;
      lastPressed = "";
      negative = false;
    });
  }

  void calculate(String value, CalculatorOperator? operator) {
    if (operator != null) {
      if (lastPressed != "") {
        if (operator == CalculatorOperator.equal) {
          if (currentOperator == CalculatorOperator.add) {
            firstNumber = negative
                ? -firstNumber + secondNumber
                : firstNumber + secondNumber;
          }
          if (currentOperator == CalculatorOperator.subtract) {
            firstNumber = negative
                ? -firstNumber - secondNumber
                : firstNumber - secondNumber;
          }
          if (currentOperator == CalculatorOperator.multiply) {
            firstNumber = negative
                ? -firstNumber * secondNumber
                : firstNumber * secondNumber;
          }
          if (currentOperator == CalculatorOperator.divide) {
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
          }
          if (firstNumber is int) { //handle integers
            calculatorText = firstNumber.toString();
          } else { //handle decimals
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
      } else if (value == '-') { //handle negative numbers
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
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
              height: 168,
              color: Theme.of(context).colorScheme.secondary,
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 10),
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                              calculatorText == "" ? " " : calculatorText,
                              style: Theme.of(context)
                                  .extension<CustomTextStyle>()
                                  ?.mathText))))),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    CalculatorButton(
                      text: "7",
                      onPressed: calculate,
                    ),
                    CalculatorButton(
                      text: "8",
                      onPressed: calculate,
                    ),
                    CalculatorButton(
                      text: "9",
                      onPressed: calculate,
                    ),
                    CalculatorButton(
                      text: "×",
                      onPressed: calculate,
                      operator: CalculatorOperator.multiply,
                    ),
                  ]))),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    CalculatorButton(
                      text: "4",
                      onPressed: calculate,
                    ),
                    CalculatorButton(
                      text: "5",
                      onPressed: calculate,
                    ),
                    CalculatorButton(
                      text: "6",
                      onPressed: calculate,
                    ),
                    CalculatorButton(
                      text: "÷",
                      onPressed: calculate,
                      operator: CalculatorOperator.divide,
                    ),
                  ]))),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    CalculatorButton(
                      text: "1",
                      onPressed: calculate,
                    ),
                    CalculatorButton(
                      text: "2",
                      onPressed: calculate,
                    ),
                    CalculatorButton(
                      text: "3",
                      onPressed: calculate,
                    ),
                    CalculatorButton(
                      text: "-",
                      onPressed: calculate,
                      operator: CalculatorOperator.subtract,
                    ),
                  ]))),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    CalculatorButton(
                      text: "C",
                      onPressed: clear,
                    ),
                    CalculatorButton(
                      text: "0",
                      onPressed: calculate,
                    ),
                    CalculatorButton(
                      text: "=",
                      onPressed: calculate,
                      operator: CalculatorOperator.equal,
                    ),
                    CalculatorButton(
                      text: "+",
                      onPressed: calculate,
                      operator: CalculatorOperator.add,
                    ),
                  ]))),
        ],
      ),
    );
  }
}
