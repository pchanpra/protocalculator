import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calculator_text.dart';
import 'calculator_operator.dart';
import 'calculator_button.dart';
import 'theme.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProtoCalculator',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: ChangeNotifierProvider(
          create: (context) => CalculatorText(), child: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

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
                              context.watch<CalculatorText>().calculatorText == ""
                                  ? " "
                                  : context.watch<CalculatorText>().calculatorText,
                              style: Theme.of(context).extension<CustomTextStyle>()?.mathText ?? TextStyle(),
                              ))))),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    CalculatorButton(
                      text: "7",
                      onPressed: context.read<CalculatorText>().calculate,
                    ),
                    CalculatorButton(
                      text: "8",
                      onPressed: context.read<CalculatorText>().calculate,
                    ),
                    CalculatorButton(
                      text: "9",
                      onPressed: context.read<CalculatorText>().calculate,
                    ),
                    CalculatorButton(
                      text: "×",
                      onPressed: context.read<CalculatorText>().calculate,
                      operator: CalculatorOperator.multiply,
                    ),
                  ]))),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    CalculatorButton(
                      text: "4",
                      onPressed: context.read<CalculatorText>().calculate,
                    ),
                    CalculatorButton(
                      text: "5",
                      onPressed: context.read<CalculatorText>().calculate,
                    ),
                    CalculatorButton(
                      text: "6",
                      onPressed: context.read<CalculatorText>().calculate,
                    ),
                    CalculatorButton(
                      text: "÷",
                      onPressed: context.read<CalculatorText>().calculate,
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
                      onPressed: context.read<CalculatorText>().calculate,
                    ),
                    CalculatorButton(
                      text: "2",
                      onPressed: context.read<CalculatorText>().calculate,
                    ),
                    CalculatorButton(
                      text: "3",
                      onPressed: context.read<CalculatorText>().calculate,
                    ),
                    CalculatorButton(
                      text: "-",
                      onPressed: context.read<CalculatorText>().calculate,
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
                      onPressed: context.read<CalculatorText>().clear,
                    ),
                    CalculatorButton(
                      text: "0",
                      onPressed: context.read<CalculatorText>().calculate,
                    ),
                    CalculatorButton(
                      text: "=",
                      onPressed: context.read<CalculatorText>().calculate,
                      operator: CalculatorOperator.equal,
                    ),
                    CalculatorButton(
                      text: "+",
                      onPressed: context.read<CalculatorText>().calculate,
                      operator: CalculatorOperator.add,
                    ),
                  ]))),
        ],
      ),
    );
  }
}