import 'dart:async';

import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  final String text;
  final FutureOr<void> Function() handlePress;
  const YellowButton(
      {super.key, required this.text, required this.handlePress});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: handlePress,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
