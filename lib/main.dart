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
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
    );
  }
}

class CustomTextStyle {
  static TextStyle getButtonText(BuildContext context) {
    return TextStyle(
      fontSize: 37,
      color: Theme.of(context).colorScheme.onPrimary,
    );
  }

  static TextStyle getMathText(BuildContext context) {
    return TextStyle(
        fontSize: 50,
        color: Theme.of(context).colorScheme.onPrimary,
        fontWeight: FontWeight.bold);
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final Function(String) onPressed;

  const CalculatorButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        child: Text(text, style: CustomTextStyle.getButtonText(context)),
        onPressed: () => onPressed(text),
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
  var operator = "";
  var lastPressed = "";
  bool negative = false;

  bool isOperator(String x) {
    if (x == '÷' || x == '×' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

  void clear(String value) {
    calculatorText = "";
    firstNumber = 0;
    secondNumber = 0;
    operator = "";
    lastPressed = "";
    setState(() {});
  }

  void calculate(String value) {
    if (isOperator(value)) {
      if (lastPressed != "") {
        if (value == "=") {
          if (operator == "add") {
            firstNumber = negative
                ? -firstNumber + secondNumber
                : firstNumber + secondNumber;
          }
          if (operator == "subtract") {
            firstNumber = negative
                ? -firstNumber - secondNumber
                : firstNumber - secondNumber;
          }
          if (operator == "multiply") {
            firstNumber = negative
                ? -firstNumber * secondNumber
                : firstNumber * secondNumber;
          }
          if (operator == "divide") {
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
          if (firstNumber is int) {
            calculatorText = firstNumber.toString();
          } else {
            calculatorText = firstNumber
                .toStringAsFixed(10 - firstNumber.toStringAsFixed(0).length);
          }
          operator = "";
          secondNumber = 0;
        }
        if (operator == "" && calculatorText != " ") {
          if (value == '+') {
            operator = "add";
            calculatorText += value;
          }
          if (value == '-') {
            operator = "subtract";
            calculatorText += value;
          }
          if (value == '×') {
            operator = "multiply";
            calculatorText += value;
          }
          if (value == '÷') {
            operator = "divide";
            calculatorText += value;
          }
        }
      } else if (value == '-') {
        calculatorText += value;
        negative = true;
      }
    } else if (value != "C") {
      if (lastPressed == "" || lastPressed == "=") {
        calculatorText = value;
        firstNumber = int.parse(value);
      } else {
        if (operator == "") {
          firstNumber = firstNumber * 10 + int.parse(value);
          calculatorText += value;
        } else {
          secondNumber = secondNumber * 10 + int.parse(value);
          calculatorText += value;
        }
      }
    }
    setState(() {});
    lastPressed = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
                height: 168,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 10),
                            child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                    calculatorText == "" ? " " : calculatorText,
                                    style: CustomTextStyle.getMathText(
                                        context))))))),
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
                      ),
                    ]))),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                          ),
                        ]))),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                          ),
                          CalculatorButton(
                            text: "+",
                            onPressed: calculate,
                          ),
                        ]))),
          ],
        ),
      ),
    );
  }
}
