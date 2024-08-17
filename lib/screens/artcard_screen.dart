import 'package:flutter/material.dart';
import 'package:qnart/widgets/art_card.dart';
import 'package:qnart/widgets/bot_message.dart';
import 'package:qnart/widgets/main_appbar.dart';

class ArtCardScreen extends StatelessWidget {
  const ArtCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            "오늘의 명화 카드",
            style: TextStyle(
              fontSize: 28,
            ),
          ),
          Image.asset('asset/img/title_underline_yellow.png'),
          const SizedBox(height: 20),
          const Center(child: ArtCard()),
          const SizedBox(height: 20),
          const BotMessage(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              '감상 시작하기',
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
