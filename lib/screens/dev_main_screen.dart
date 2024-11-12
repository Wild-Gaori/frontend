import 'package:flutter/material.dart';
import 'package:qnart/screens/artcard/artcard_screen.dart';
import 'package:qnart/screens/home_screen.dart';
import 'package:qnart/screens/login/login_screen.dart';
import 'package:qnart/screens/mypage_screen.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevMainScreen extends StatelessWidget {
  const DevMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final SharedPreferences pref =
                  await SharedPreferences.getInstance();
              final int? userPk = pref.getInt("user_pk");
              print("userpk: $userPk");
            },
            child: const Text('print pk'),
          ),
          ElevatedButton(
            onPressed: () async {
              final SharedPreferences pref =
                  await SharedPreferences.getInstance();
              await pref.remove("user_pk");
            },
            child: const Text('Logout', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: const Text(
              'Login Screen',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            child: const Text(
              'Home Screen',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ArtCardScreen(),
                ),
              );
            },
            child: const Text(
              'ArtCard Screen',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyPage(),
                ),
              );
            },
            child: const Text(
              'MyPage Screen',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
