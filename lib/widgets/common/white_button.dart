import 'dart:async';

import 'package:flutter/material.dart';

class WhiteButton extends StatelessWidget {
  final String text;
  final FutureOr<void> Function() handlePress;
  const WhiteButton({super.key, required this.text, required this.handlePress});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: handlePress,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.white,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
