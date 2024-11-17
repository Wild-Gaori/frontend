import 'package:flutter/material.dart';
import 'package:qnart/consts/basic_theme_data.dart';
import 'package:qnart/screens/artcard/artcard_screen.dart';
import 'package:qnart/screens/chat/chat_screen.dart';
import 'package:qnart/screens/chat/draw_screen.dart';
import 'package:qnart/screens/dev_main_screen.dart';
import 'package:qnart/screens/home_screen.dart';
import 'package:qnart/screens/init/init_first_screen.dart';
import 'package:qnart/screens/init/init_letter_screen.dart';
import 'package:qnart/screens/login/login_screen.dart';
import 'package:qnart/screens/login/signup_complete_screen.dart';
import 'package:qnart/screens/museum/exhibition_detail_screen.dart';
import 'package:qnart/screens/mypage/docent_screen.dart';
import 'package:qnart/screens/mypage_screen.dart';
import 'package:qnart/widgets/common/dialog_drawing_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 초기화
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getInt('user_pk') != null; // 로그인 여부 확인
  runApp(MyApp(
    initialRoute: isLoggedIn ? '/home' : '/login',
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      theme: basicThemeData(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
