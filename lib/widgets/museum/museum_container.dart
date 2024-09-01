import 'package:flutter/material.dart';
import 'package:qnart/widgets/museum_title.dart';

class MuseumContainer extends StatelessWidget {
  final Widget childComponent;
  final String title;

  const MuseumContainer({
    super.key,
    required this.childComponent,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
          MuseumTitle(title: title),
          Image.asset('asset/img/title_underline.png'),
          const SizedBox(height: 20),
          childComponent,
        ],
      ),
    );
  }
}
