import 'package:flutter/material.dart';
import 'package:qnart/utils/size_config.dart';
import 'package:qnart/widgets/museum_title.dart';

class MyPageContainer extends StatelessWidget {
  final Widget childComponent;
  final String title;

  const MyPageContainer({
    super.key,
    required this.childComponent,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      width: SizeConfig.screenWidth * 0.9,
      height: SizeConfig.screenHeight * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          MuseumTitle(title: title),
          Image.asset('asset/img/title_underline_yellow.png'),
          const SizedBox(height: 20),
          childComponent,
        ],
      ),
    );
  }
}
