import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qnart/screens/home_screen.dart';
import 'package:qnart/screens/login/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          const loginFieldWidget(
            hintText: '아이디',
          ),
          const loginFieldWidget(
            hintText: '비밀번호',
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              //로그인 처리 필요
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
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
    );
  }
}

class loginFieldWidget extends StatelessWidget {
  final String hintText;

  const loginFieldWidget({
    super.key,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: 300,
        height: 50,
        child: TextField(
          style: const TextStyle(
            fontSize: 20,
          ),
          decoration: InputDecoration(
            hintText: hintText,
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
