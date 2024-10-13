import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:qnart/utils/resize_image.dart';
import 'package:qnart/widgets/common/dialog_drawing_ui.dart';
import 'package:qnart/widgets/common/yellow_button.dart';

class ChangeImageSelector extends StatefulWidget {
  final String imgPath;
  final Function(Future<String>) onFinished;

  const ChangeImageSelector({
    super.key,
    required this.imgPath,
    required this.onFinished,
  });

  @override
  State<ChangeImageSelector> createState() => _ChangeImageSelectorState();
}

class _ChangeImageSelectorState extends State<ChangeImageSelector> {
  Offset? startDrag;
  Offset? currentDrag;
  Rect? selectedRect;
  bool isEnabled = true;

  Future<img.Image> processImage(Rect selectedRect) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const DialogDrawingUI();
      },
    );

    print(selectedRect);
    final response = await http.get(Uri.parse(widget.imgPath));
    print('response type : ${response.headers['content-type']}');

    if (response.statusCode == 200) {
      // 네트워크로부터 받은 이미지 데이터를 Uint8List로 변환
      final Uint8List bytes = response.bodyBytes;
      print('Image size: ${bytes.length} bytes');

      // 이미지 패키지를 이용해 이미지를 디코딩
      img.Image originalImage = img.decodeImage(bytes)!;
      print(
          'Decoded image size: ${originalImage.width}x${originalImage.height}');

      if (!originalImage.hasAlpha) {
        print('알파 채널이 없는 이미지, RGBA로 변환 중...');
        originalImage = originalImage.convert(numChannels: 4, alpha: 255);
      }

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
          pixel.r = 255;
          pixel.g = 0;
          pixel.b = 0;
          pixel.a = 0;
        }
      }

      // print('Resized Image size: ${originalImage.getBytes().length} bytes');

      originalImage = resizeImageCustom(originalImage, 4 * 1024 * 1024);

      Navigator.pop(context);

      return originalImage;
    } else {
      throw Exception('Failed to load image from network');
    }
  }

  Future<String> saveImage(img.Image maskedImage) async {
    final png = img.encodePng(maskedImage); //uint8list file
    print(png);

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/masked_output.png';
    final file = File(filePath);
    await file.writeAsBytes(png);
    print('이미지가 저장되었습니다: $filePath');
    return filePath;
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
                enabled: isEnabled,
                text: '선택 완료',
                handlePress: () async {
                  if (selectedRect == null) {
                    return;
                  } else {
                    final Future<String> maskedBytesPath =
                        saveImage(await processImage(selectedRect!));
                    print(maskedBytesPath);
                    widget.onFinished(maskedBytesPath);
                    isEnabled = false;
                  }
                }),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
