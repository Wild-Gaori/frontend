import 'dart:math';

import 'package:flutter/material.dart';

class MainBalloon extends StatelessWidget {
  final List<String> charTexts;

  const MainBalloon({
    super.key,
    required this.charTexts,
  });

  @override
  Widget build(BuildContext context) {
    int randNum = Random().nextInt(charTexts.length);

    return (Container(
      width: 330,
      height: 70,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('asset/img/balloon.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Text(
          charTexts[randNum],
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    ));
  }
}
