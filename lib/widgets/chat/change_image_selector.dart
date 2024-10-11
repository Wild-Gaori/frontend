import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:qnart/widgets/common/yellow_button.dart';

class ChangeImageSelector extends StatefulWidget {
  final String imgPath;

  const ChangeImageSelector({
    super.key,
    required this.imgPath,
  });

  @override
  State<ChangeImageSelector> createState() => _ChangeImageSelectorState();
}

class _ChangeImageSelectorState extends State<ChangeImageSelector> {
  Offset? startDrag;
  Offset? currentDrag;
  Rect? selectedRect;

  Future<img.Image> processImage(Rect selectedRect) async {
    print(selectedRect);
    final response = await http.get(Uri.parse(widget.imgPath));

    if (response.statusCode == 200) {
      // 네트워크로부터 받은 이미지 데이터를 Uint8List로 변환
      final Uint8List bytes = response.bodyBytes;

      // 이미지 패키지를 이용해 이미지를 디코딩
      final img.Image originalImage = img.decodeImage(bytes)!;

      double scaleX = originalImage.width / 300;
      double scaleY = originalImage.height / 300;

      double imageX = selectedRect.left * scaleX;
      double imageY = selectedRect.top * scaleY;
      double imageRight = selectedRect.right * scaleX;
      double imageBottom = selectedRect.bottom * scaleY;

      Rect actualRect = Rect.fromLTRB(imageX, imageY, imageRight, imageBottom);

      // 선택된 영역을 투명하게 처리
      for (var pixel in originalImage) {
        if (pixel.x >= actualRect.left &&
            pixel.x <= actualRect.right &&
            pixel.y >= actualRect.top &&
            pixel.y <= actualRect.bottom) {
          // 투명하게 설정 (알파 값 0으로 설정하여 투명도 적용)
          // print('pixel x/y is ${pixel.x}, ${pixel.y}');
          pixel.r = 0;
          pixel.g = 0;
          pixel.b = 0;
          pixel.a = 0;
        }
      }

      return originalImage;
    } else {
      throw Exception('Failed to load image from network');
    }
  }

  Future<File> saveImage(img.Image maskedImage) async {
    final png = img.encodePng(maskedImage); //uint8list file
    print(png);

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/masked_output.png';
    final file = File(filePath);
    await file.writeAsBytes(png);
    final result = await ImageGallerySaver.saveImage(png);
    print('이미지가 저장되었습니다: $filePath');
    return file;
  }

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
        child: Column(
          children: [
            GestureDetector(
              onPanStart: (details) {
                setState(() {
                  startDrag = details.localPosition;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  currentDrag = details.localPosition;
                  selectedRect = Rect.fromPoints(startDrag!, currentDrag!);
                });
              },
              onPanEnd: (details) {},
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: widget.imgPath != null
                        ? Image.network(
                            widget.imgPath,
                            width: 300,
                            height: 300,
                          )
                        : const Text('로딩 실패'),
                  ),
                  if (selectedRect != null)
                    Positioned.fromRect(
                      rect: selectedRect!,
                      child: Container(
                        color: Colors.blue.withOpacity(0.8),
                      ),
                    ),
                ],
              ),
            ),
            YellowButton(
                text: '선택 완료',
                handlePress: () async {
                  if (selectedRect == null) {
                    return;
                  } else {
                    final Future<File> maskedBytes =
                        saveImage(await processImage(selectedRect!));
                    print(maskedBytes);
                  }
                }),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
