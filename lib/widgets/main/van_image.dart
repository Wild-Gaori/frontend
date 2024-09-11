import 'package:flutter/material.dart';

class VanImage extends StatelessWidget {
  const VanImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'asset/img/van_sized.png',
        height: MediaQuery.of(context).size.height * 0.25,
      ),
    );
  }
}
