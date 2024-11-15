import 'package:flutter/material.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:qnart/widgets/museum/display_info.dart';
import 'package:qnart/widgets/museum/floor_info.dart';
import 'package:qnart/widgets/museum/museum_container.dart';

class MuseumScreen2 extends StatelessWidget {
  const MuseumScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MainAppBar(),
      body: MuseumContainer(
        title: '국립현대미술관 서울',
        childComponent: Column(
          children: [
            FloorInfo(),
            DisplayInfo(),
          ],
        ),
      ),
    );
  }
}
