import 'package:flutter/material.dart';

//명화 카드(큰 버전)
class ArtCard extends StatelessWidget {
  final String hook;
  final String title;
  final String imgUrl;

  const ArtCard({
    super.key,
    required this.hook,
    required this.title,
    required this.imgUrl,
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
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: containerWidth * 0.85,
              height: containerHeight * 0.6,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imgUrl),
                  fit: BoxFit.contain,
                ),
                color: const Color(0xffe7e7e7),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                maxLines: 1,
              ),
            ),
            Text(
              hook,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
