import 'package:image/image.dart' as img;

/// 이미지가 4MB를 넘으면 크기를 줄이는 함수
img.Image resizeImageCustom(img.Image originalImage, int maxFileSizeInBytes) {
  // 현재 이미지의 크기 (바이트 단위) 확인
  int currentFileSize = originalImage.getBytes().length;
  if (originalImage.getBytes().length > maxFileSizeInBytes) {
    print('이미지 리사이즈 시작');

    // 해상도를 줄이는 비율을 계산 (용량에 맞춰 0.5로 줄이기 시작)
    double scaleFactor = 0.7;

    while (currentFileSize > maxFileSizeInBytes) {
      print('이미지 크기가 ${maxFileSizeInBytes / (1024 * 1024)}MB를 넘으므로 리사이즈 시작');
      int newWidth = (originalImage.width * scaleFactor).toInt();
      int newHeight = (originalImage.height * scaleFactor).toInt();

      // 리사이즈 적용
      originalImage = img.copyResize(
        originalImage,
        width: newWidth,
        height: newHeight,
      );
      currentFileSize = originalImage.getBytes().length;
      print(
          'Resized image to: ${newWidth}x$newHeight, Current size: ${currentFileSize / (1024 * 1024)} MB');
    }
  }

  return originalImage;
}
