import 'package:flutter/material.dart';
import 'package:qnart/widgets/main/van_image.dart';

class DocentCard extends StatelessWidget {
  const DocentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 450,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              width: 260,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '깊은 바다에서 온 아주 커다란 친구',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontFamily: 'NanumSquareRoundBold',
                    ),
                  ),
                  Text(
                    '빈센트 반 고래',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontFamily: 'NanumSquareRoundBold',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Container(
                width: 260,
                height: 180,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromARGB(255, 41, 70, 255),
                  image: DecorationImage(
                    image: AssetImage('asset/img/grid_bg.png'),
                    fit: BoxFit.cover,
                    opacity: .3,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'asset/img/chars/van_sized.png',
                    height: 150,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 260,
              child: Text(
                '미술관의 행동대장\n명랑하고 친절한 성격.\n덩치가 커서 주변 친구들을 불편하게 할까 항상 조심한다.',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontFamily: 'NanumSquareRoundBold',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
