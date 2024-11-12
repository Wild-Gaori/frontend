import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qnart/screens/init/init_complete_screen.dart';
import 'package:qnart/screens/init/init_first_screen.dart';
import 'package:qnart/widgets/common/inituserinfo.dart';

class InitLetterScreen extends StatelessWidget {
  const InitLetterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nicknameController = TextEditingController();
    final TextEditingController birthdateController = TextEditingController();
    final TextEditingController genderController = TextEditingController();
    final TextEditingController clothingController = TextEditingController();
    final TextEditingController hairStyleController = TextEditingController();

    final List<Map<String, TextEditingController>> initMessages = [
      {"내 이름은": nicknameController},
      {"생년월일은": birthdateController},
      {"성별은": genderController},
      {"내 옷은": clothingController},
      {"내 머리 모양은": hairStyleController},
    ];

    return Scaffold(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage('asset/img/letter/letter_bg.png'),
                  fit: BoxFit.contain,
                  scale: 1.5,
                ),
              ),
              child: InputUserInfo(initMessages: initMessages),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InitCompleteScreen()));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '보내기',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
