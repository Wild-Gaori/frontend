import 'package:flutter/material.dart';
import 'package:qnart/consts/basic_theme_data.dart';
import 'package:qnart/screens/artcard/artcard_screen.dart';
import 'package:qnart/screens/home_screen.dart';
import 'package:qnart/screens/imagetest.dart';
import 'package:qnart/screens/init/init_first_screen.dart';
import 'package:qnart/screens/login/login_screen.dart';
import 'package:qnart/screens/mypage/docent_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: basicThemeData(),
      home: const LoginScreen(), // 홈 화면 설정
    );
  }
}
