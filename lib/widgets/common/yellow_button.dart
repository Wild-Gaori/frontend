import 'dart:async';

import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  final String text;
  final FutureOr<void> Function() handlePress;
  final bool enabled;
  const YellowButton({
    super.key,
    required this.text,
    required this.handlePress,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? handlePress : null,
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
