import 'package:flutter/material.dart';

class ImageTestScreen extends StatelessWidget {
  const ImageTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Test'),
      ),
      body: Center(
        child: Image.network(
            "https://drive.google.com/uc?export=view&id=1yKyvzHPLMOKac-1ZejJOvSeDd0ntmbxt"),
      ),
    );
  }
}
