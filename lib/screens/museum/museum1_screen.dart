import 'package:flutter/material.dart';
import 'package:qnart/screens/museum/museum2_screen.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:qnart/widgets/museum/museum_container.dart';
import 'package:url_launcher/url_launcher.dart';

class MuseumScreen1 extends StatelessWidget {
  const MuseumScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    // double containerWidth = MediaQuery.of(context).size.width;
    // double containerHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const MainAppBar(),
      body: MuseumContainer(
        title: '미술관 목록',
        childComponent: Expanded(
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return const MuseumBtn();
            },
          ),
        ),
      ),
    );
  }
}

class MuseumBtn extends StatelessWidget {
  const MuseumBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 340,
        height: 88,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                //임시 페이지 라우팅
                MaterialPageRoute(builder: (context) => const MuseumScreen2()),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              shadowColor: Colors.grey,
              elevation: 5,
              maximumSize: const Size(339, 88),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'asset/img/museum/mmca_logo.png',
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '국립현대미술관 서울',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 30,
                        child: GestureDetector(
                          onTap: () async {
                            final Uri url =
                                Uri.parse('https://www.mmca.go.kr/');
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          },
                          child: Text(
                            '홈페이지 바로가기',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
