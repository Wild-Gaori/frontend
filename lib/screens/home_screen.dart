import 'package:flutter/material.dart';
import 'package:qnart/screens/artcard/artcard_screen.dart';
import 'package:qnart/screens/museum/museum1_screen.dart';
import 'package:qnart/screens/mypage_screen.dart';
import 'package:qnart/widgets/van_image.dart';
import 'package:qnart/widgets/main_balloon.dart';
import 'package:qnart/consts/char_texts.dart';

class HomeScreen extends StatelessWidget {
  final appBarHeight = kToolbarHeight;

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('asset/img/logo.png'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color(0xffF5F5F5),
        ),
        child: Stack(
          children: [
            Container(
              height:
                  ((MediaQuery.of(context).size.height - appBarHeight) * 0.5),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('asset/img/pattern.png'),
                  fit: BoxFit.cover,
                  opacity: 0.5,
                ),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VanImage(),
                    SizedBox(height: 15),
                    MainBalloon(
                      charTexts: vanTexts,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: (MediaQuery.of(context).size.height * 0.35),
              right: 0,
              child: const MainButton(
                icon: Icons.calendar_view_day_rounded,
                title: "작품 감상하기",
                subtitle: "랜덤으로 선정된 명화를 감상해요",
                destination: ArtCardScreen(),
              ),
            ),
            Positioned(
              bottom: (MediaQuery.of(context).size.height * 0.20),
              right: 0,
              child: const MainButton(
                icon: Icons.museum,
                title: "미술관 찾기",
                subtitle: "미술관 전시를 검색해 감상해요",
                destination: MuseumScreen1(),
              ),
            ),
            Positioned(
              bottom: (MediaQuery.of(context).size.height * 0.05),
              right: 0,
              child: const MainButton(
                icon: Icons.person_rounded,
                title: "마이페이지",
                subtitle: "기록을 확인하거나 정보를 수정해요",
                destination: MyPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget destination;

  const MainButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(20),
            right: Radius.zero,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shadowColor: Colors.grey,
        elevation: 5,
        maximumSize: const Size(339, 88),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 60,
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 20,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 50),
        ],
      ),
    );
  }
}
