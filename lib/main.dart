import 'package:flutter/material.dart';
import 'calculator_bloc.dart';
import 'calculator_operator.dart';
import 'calculator_button.dart';
import 'theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculator_state.dart';
import 'calculator_event.dart';
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
      home: BlocProvider(
          create: (context) => CalculatorBloc(), child: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final calculatorBloc = context.read<CalculatorBloc>();
    calculatorBloc.add(CalculatorInitializeEvent());
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
                          child: BlocBuilder<CalculatorBloc, CalculatorState>(
                              builder: (context, state) => Text(
                              state.calculatorText == ""
                                  ? " "
                                  : state.calculatorText,
                              style: Theme.of(context).mathText,
                              )))))),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    CalculatorButton(
                      text: "7",
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorCalculateEvent(value: "7", operator: null)),
                    ),
                    CalculatorButton(
                      text: "8",
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorCalculateEvent(value: "8", operator: null)),
                    ),
                    CalculatorButton(
                      text: "9",
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorCalculateEvent(value: "9", operator: null)),
                    ),
                    CalculatorButton(
                      text: "×",
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorCalculateEvent(value: "×", operator: CalculatorOperator.multiply)),
                      operator: CalculatorOperator.multiply,
                    ),
                  ]))),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    CalculatorButton(
                      text: "4",
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorCalculateEvent(value: "4", operator: null)),
                    ),
                    CalculatorButton(
                      text: "5",
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorCalculateEvent(value: "5", operator: null)),
                    ),
                    CalculatorButton(
                      text: "6",
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorCalculateEvent(value: "6", operator: null)),
                    ),
                    CalculatorButton(
                      text: "÷",
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorCalculateEvent(value: "÷", operator: CalculatorOperator.divide)),
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
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorCalculateEvent(value: "1", operator: null)),
                    ),
                    CalculatorButton(
                      text: "2",
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorCalculateEvent(value: "2", operator: null)),
                    ),
                    CalculatorButton(
                      text: "3",
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorCalculateEvent(value: "3", operator: null)),
                    ),
                    CalculatorButton(
                      text: "-",
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorCalculateEvent(value: "-", operator: CalculatorOperator.subtract)),
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
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorClearEvent()),
                    ),
                    CalculatorButton(
                      text: "0",
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorCalculateEvent(value: "0", operator: null)),
                    ),
                    CalculatorButton(
                      text: "=",
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorCalculateEvent(value: "=", operator: CalculatorOperator.equal)),
                      operator: CalculatorOperator.equal,
                    ),
                    CalculatorButton(
                      text: "+",
                      onPressed: (value, operator) => calculatorBloc.add(CalculatorCalculateEvent(value: "+", operator: CalculatorOperator.add)),
                      operator: CalculatorOperator.add,
                    ),
                  ]))),
        ],
      ),
    );
  }
}