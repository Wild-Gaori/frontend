import 'package:flutter/material.dart';

class ImageMessage extends StatelessWidget {
  final String url;

  const ImageMessage({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 18.0, 0, 0),
      child: (Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: AssetImage('asset/img/chars/van_sized.png'),
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 5),
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
              child: url != null ? Image.network(url) : const Text('로딩 실패'),
            ),
          ),
        ],
      )),
    );
  }
}
