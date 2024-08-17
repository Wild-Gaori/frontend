import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qnart/widgets/main_appbar.dart';

class MuseumScreen1 extends StatelessWidget {
  const MuseumScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width;
    double containerHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const MainAppBar(),
      body: Container(
        width: containerWidth,
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
          children: [
            const SizedBox(height: 20),
            Stack(
              children: <Widget>[
                Text(
                  "미술관 목록",
                  style: TextStyle(
                    fontSize: 28,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = Colors.white,
                  ),
                ),
                Text(
                  "미술관 목록",
                  style: TextStyle(
                    fontSize: 28,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            Image.asset('asset/img/title_underline.png'),
          ],
        ),
      ),
    );
  }
}
