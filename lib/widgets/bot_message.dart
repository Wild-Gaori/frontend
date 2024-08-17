import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class BotMessage extends StatelessWidget {
  // final String message;
  // final String avatar;

  const BotMessage({
    super.key,
    // required this.message,
    // required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return (Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: const DecorationImage(
              image: AssetImage('asset/img/van_sized.png'),
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 3.0,
                offset: Offset(0, 5.0),
              ),
            ],
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Text(
              '이야기를 나눌 준비가 되었다면 아래 버튼을 눌러줘!',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
