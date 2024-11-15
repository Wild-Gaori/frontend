import 'package:flutter/material.dart';
import 'package:qnart/screens/museum/exhibition/art_list_screen.dart';
import 'package:qnart/utils/size_config.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:qnart/widgets/common/yellow_button.dart';
import 'package:qnart/widgets/museum/museum_container.dart';

class ExhibitDetailScreen extends StatelessWidget {
  const ExhibitDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: const MainAppBar(),
        body: MuseumContainer(
            childComponent: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight * 0.75,
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '이강소: 風來水面時\n풍래수면시',
                      style: TextStyle(
                          fontSize: 25, fontFamily: 'NanumSquareRoundBold'),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      '2024.11.1 - 2025.4.13',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Image.asset('asset/img/museum/exhibition_main.png'),
                    const SizedBox(height: 20),
                    const Text(
                      '바람이 물 위를 스칠 때의 모습을\n상상해본 적 있어?',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    YellowButton(
                      text: '감상 시작하기',
                      handlePress: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ArtListScreen(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            title: '국립현대미술관 서울'));
  }
}
