import 'package:flutter/material.dart';

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

extension ThemeDataExtension on ThemeData {
  TextStyle get buttonText {
    return brightness == Brightness.light ? TextStyle(fontSize: 37, color: Colors.black) : TextStyle(fontSize: 37, color: Color(0xFFfcfcfc));
  }
  TextStyle get mathText {
    return brightness == Brightness.light ? TextStyle(fontSize: 50, color: Colors.black, fontWeight: FontWeight.bold) : TextStyle(fontSize: 50, color: Color(0xFFfcfcfc), fontWeight: FontWeight.bold);
  }
}

class CustomTheme {
  static ThemeData lightTheme = ThemeData(
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
        extensions: const <ThemeExtension<CustomTextStyle>>[
          CustomTextStyle(
              buttonText: TextStyle(fontSize: 37, color: Colors.black),
              mathText: TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
    ],
  );

  static ThemeData darkTheme = ThemeData(
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
          extensions: const <ThemeExtension<CustomTextStyle>>[
            CustomTextStyle(
                buttonText: TextStyle(fontSize: 37, color: Color(0xFFfcfcfc)),
                mathText: TextStyle(
                    fontSize: 50,
                    color: Color(0xFFfcfcfc),
                fontWeight: FontWeight.bold)),
    ],
  );
}
