import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qnart/screens/login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:qnart/screens/login/signup_complete_screen.dart';
import 'package:qnart/utils/fetch_csrf_token.dart';
import 'package:qnart/widgets/common/dialog_ui.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isPasswordMatching = true;

  void showCustomDialog(String dialogMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return DialogUI(
            dialogMessage: dialogMessage,
          );
        });
  }

  Future<void> checkAvailability() async {
    String csrfToken = await fetchCsrfToken(
        'http://13.124.100.182/signup/?action=check_username/');
    var url = Uri.parse('http://13.124.100.182/signup/?action=check_username/');
    var headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken, // CSRF 토큰 포함
      "Cookie": "csrftoken=$csrfToken",
    };

    final body = jsonEncode({
      'action': 'check_username',
      'username': _idController.text,
    });
    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      showCustomDialog('사용 가능한 아이디입니다.');
    } else {
      showCustomDialog('사용 불가한 아이디입니다.\n다른 아이디를 사용해주세요.');
    }
  }

  Future<void> handleSignup(BuildContext context) async {
    String csrfToken =
        await fetchCsrfToken('http://13.124.100.182/signup/?action=signup/');
    var url = Uri.parse('http://13.124.100.182/signup/?action=signup/');
    var headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken, // CSRF 토큰 포함
      "Cookie": "csrftoken=$csrfToken",
    };
    final body = jsonEncode({
      'action': 'signup',
      'username': _idController.text,
      'password': _pwController.text,
      'password_confirm': _confirmPwController.text,
      'email': _emailController.text,
    });
    print(body);
    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        print('signup completed');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignupCompleteScreen(),
          ),
        );
      } else if (response.statusCode == 500) {
        showCustomDialog('Invalid error');
      } else {
        print(response.statusCode);
        print(response.body);
        var errorMessage = (jsonDecode(response.body))['error'];
        if (errorMessage == "Please fill out all fields.") {
          showCustomDialog('모든 정보를 입력해주세요.');
        } else if (errorMessage == "Passwords do not match.") {
          showCustomDialog('비밀번호가 일치하지 않습니다.');
        } else if (errorMessage ==
            "Password must be at least 4 characters long.") {
          showCustomDialog('비밀번호는 4자 이상으로\n입력해주세요.');
        } else
          showCustomDialog('Invalid error');
      }
    } finally {}
  }

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
              height: 150,
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
              controller: _idController,
              suffix: ElevatedButton(
                onPressed: checkAvailability,
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
              controller: _pwController,
            ),
            const SizedBox(height: 16),
            buildTextField(
              context,
              hintText: '비밀번호 확인',
              obscureText: true,
              controller: _confirmPwController,
              onChanged: (value) {
                setState(() {
                  isPasswordMatching = _pwController.text == value;
                });
                setState(() {});
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
              controller: _emailController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await handleSignup(context);
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
