import 'package:flutter/material.dart';
import 'package:qnart/screens/init/init_letter_screen.dart';

class InitFirstScreen extends StatelessWidget {
  const InitFirstScreen({super.key});

  final String firstMessage =
      "To. 나와 함께 여행을 떠날 방문자\n\n안녕? 반가워!\n나는 이 세상의 모든 예술을 찾아 여행하고 있는 탐험가야.\n나에 대해 더 알려주기 전에... \n너에 대해 먼저 알고 싶어\n너의 정보를 적어서 보내줘!\n그럼 기다릴게.\n\nFrom. 미술관의 누군가";

  @override
  Widget build(BuildContext context) {
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: SizedBox(
                    width: 200,
                    height: 250,
                    child: Text(firstMessage),
                  ),
                )),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InitLetterScreen()));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '답장하기',
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
