import 'package:flutter/material.dart';

class DrawButtons extends StatelessWidget {
  final Function(String) onSelect;

  const DrawButtons({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          DrawButton(
            handlePress: () {
              onSelect('experience');
            },
            text: '내 경험으로 그림 그리기',
          ),
          const SizedBox(height: 5.0),
          DrawButton(
            handlePress: () {
              onSelect('change');
            },
            text: '작품에서 바꾸고 싶은 부분 바꾸기',
          ),
          const SizedBox(height: 5.0),
          DrawButton(
            handlePress: () {
              onSelect('imagine');
            },
            text: '작품에서 나타나지 않은 부분 상상하기',
          ),
        ],
      ),
    );
  }
}

class DrawButton extends StatelessWidget {
  final handlePress;
  final String text;

  const DrawButton({
    super.key,
    required this.handlePress,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: handlePress,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 16,
        ),
      ),
    );
  }
}
