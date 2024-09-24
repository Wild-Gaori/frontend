import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qnart/screens/home_screen.dart';
import 'package:qnart/screens/login/signup_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  String csrfToken = "";

  @override
  void initState() {
    super.initState();
    fetchCsrfToken();
  }

  // CSRF 토큰을 가져오는 함수
  Future<void> fetchCsrfToken() async {
    final url = Uri.parse('http://13.124.100.182'); // Django 로그인 엔드포인트
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // 쿠키에서 csrf 토큰을 추출
      String? rawCookie = response.headers['set-cookie'];
      if (rawCookie != null) {
        int start = rawCookie.indexOf('csrftoken=');
        if (start != -1) {
          int end = rawCookie.indexOf(';', start);
          csrfToken = rawCookie.substring(start + 10, end);
        }
      }
    } else {
      print('STOP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 380,
              child: Stack(
                children: [
                  // 상단 흰색
                  Positioned.fill(
                    top: 0,
                    bottom: 150,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  // 중간 노란색
                  Positioned.fill(
                    top: 120,
                    bottom: 70,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        image: const DecorationImage(
                          image: AssetImage('asset/img/pattern.png'),
                          fit: BoxFit.cover,
                          opacity: 0.5,
                        ),
                      ),
                    ),
                  ),
                  // 하단 흰색
                  Positioned.fill(
                    top: 290,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  // 이미지 가운데 배치
                  Center(
                    child: Image.asset(
                      'asset/img/logo/pic_logo.png',
                      fit: BoxFit.contain,
                      height: 350,
                    ),
                  ),
                ],
              ),
            ),
          ),
          LoginFieldWidget(
            controller: _idController,
            hintText: '아이디',
          ),
          LoginFieldWidget(
            controller: _pwController,
            hintText: '비밀번호',
            isObscured: true,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () async {
              print(_idController.text);
              print(_pwController.text);
              //로그인 처리 필요

              await handleLogin(context);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              '로그인',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Colors.white,
            ),
            child: Text(
              '계정이 없으신가요?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> handleLogin(BuildContext context) async {
    var url = Uri.parse('http://13.124.100.182');
    var headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken, // CSRF 토큰 포함
      "Cookie": "csrftoken=$csrfToken",
    };
    final body = jsonEncode({
      'user_id': _idController.text,
      'pw': _pwController.text,
    });
    print(body);
    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('ok');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        print(response.body);
      }
    } finally {}
  }
}

class LoginFieldWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscured;

  const LoginFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscured = false,
  });

  @override
  State<LoginFieldWidget> createState() => _LoginFieldWidgetState();
}

class _LoginFieldWidgetState extends State<LoginFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: 300,
        height: 50,
        child: TextField(
          controller: widget.controller,
          obscureText: widget.isObscured,
          style: const TextStyle(
            fontSize: 20,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.onPrimary),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
          ),
          cursorColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
