import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qnart/screens/login/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isPasswordMatching = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          image: const DecorationImage(
            image: AssetImage('asset/img/pattern.png'),
            fit: BoxFit.cover,
            opacity: .5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 260,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/img/logo/logo.png'),
                  scale: .7,
                ),
              ),
            ),
            Container(
              width: 260,
              height: 50,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/img/signup/signup_img.png'),
                ),
              ),
            ),
            buildTextField(
              context,
              hintText: '아이디를 입력해주세요',
              suffix: ElevatedButton(
                onPressed: () {
                  // 중복 확인 로직 구현
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
                ),
                child: Text(
                  '중복 확인',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            buildTextField(
              context,
              hintText: '비밀번호를 입력해주세요',
              obscureText: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 16),
            buildTextField(
              context,
              hintText: '비밀번호 확인',
              obscureText: true,
              controller: _confirmPasswordController,
              onChanged: (value) {
                setState(() {
                  isPasswordMatching = _passwordController.text == value;
                });
              },
            ),
            if (!isPasswordMatching)
              const Text(
                '비밀번호가 맞지 않습니다',
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            buildTextField(
              context,
              hintText: '이메일을 입력해주세요',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 회원가입 로직 구현
              },
              child: Text(
                '회원가입',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Text(
                '로그인 화면으로 돌아가기',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

Widget buildTextField(BuildContext context,
    {required String hintText,
    bool obscureText = false,
    TextEditingController? controller,
    Widget? suffix,
    ValueChanged<String>? onChanged}) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.8,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
    ),
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        suffixIcon: suffix,
      ),
    ),
  );
}
