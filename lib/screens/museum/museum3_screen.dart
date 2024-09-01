import 'package:flutter/material.dart';
import 'package:qnart/widgets/main_appbar.dart';

class MuseumScreen3 extends StatelessWidget {
  const MuseumScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MainAppBar(),
      body: Center(
        child: Text('Welcome to Museum Screen 3!'),
      ),
    );
  }
}
