import 'package:flutter/material.dart';

//명화 카드(큰 버전)
class ArtCard extends StatelessWidget {
  const ArtCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * 0.8;
    double containerHeight = MediaQuery.of(context).size.height * 0.5;

    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
            offset: Offset(0, 5.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: containerWidth * 0.85,
              height: containerHeight * 0.65,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/img/test_art.jpg'),
                  fit: BoxFit.contain,
                ),
                color: Color(0xffe7e7e7),
              ),
            ),
            Text(
              'Title',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              maxLines: 1,
            ),
            Text(
              '모나리자 속에 숨겨진 이야기를 알아볼까요?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
