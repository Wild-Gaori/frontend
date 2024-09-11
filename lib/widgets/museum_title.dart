import 'package:flutter/material.dart';

//글씨 + 흰줄

class MuseumTitle extends StatelessWidget {
  final String title;

  const MuseumTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 28,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = Colors.white,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 28,
            color: Theme.of(context).colorScheme.onPrimary,
            fontFamily: 'NanumSquareRoundBold',
          ),
        ),
      ],
    );
  }
}
