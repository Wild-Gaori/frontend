import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ShowImageContainer extends StatelessWidget {
  final String imgPath;

  const ShowImageContainer({
    super.key,
    required this.imgPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 18.0, 15.0, 18.0),
      child: Container(
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
          padding: const EdgeInsets.all(15.0),
          child: imgPath != null ? Image.network(imgPath) : const Text('로딩 실패'),
        ),
      ),
    );
  }
}
