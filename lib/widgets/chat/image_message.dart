import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qnart/widgets/common/dialog_ui.dart';
import 'package:qnart/widgets/common/white_button.dart';
import 'package:qnart/widgets/common/yellow_button.dart';

class ImageMessage extends StatelessWidget {
  final String url;
  final VoidCallback onRedraw;

  const ImageMessage({
    super.key,
    required this.url,
    required this.onRedraw,
  });

  @override
  Widget build(BuildContext context) {
    saveNetworkImage(String url) async {
      var response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: "qnart_imagegenerate_result");
      showDialog(
        context: context,
        builder: (context) {
          return const DialogUI(
            dialogMessage: '갤러리에 저장되었습니다.',
          );
        },
      );
    }

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
          child: Column(
            children: [
              url != null ? Image.network(url) : const Text('로딩 실패'),
              const SizedBox(height: 15),
              YellowButton(
                text: '저장하기',
                handlePress: () async {
                  await saveNetworkImage(url);
                },
              ),
              WhiteButton(text: '다시 그리기', handlePress: onRedraw)
            ],
          ),
        ),
      ),
    );
  }
}
