import 'package:flutter/material.dart';
import 'package:qnart/consts/basic_theme_data.dart';
import 'package:qnart/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: basicThemeData(),
      home: const HomeScreen(), // 홈 화면 설정
    );
  }
}
