import 'package:flutter/material.dart';
import 'package:qnart/screens/home_screen.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBackEnabled;
  const MainAppBar({
    super.key,
    this.isBackEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: isBackEnabled,
      leading: isBackEnabled
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              color: const Color(0xffF5004F),
              padding: const EdgeInsets.all(10),
            )
          : null,
      title: Image.asset('asset/img/logo/logo.png'),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            // 홈 버튼 클릭 시 이동할 동작 정의
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen())); // 예: 홈 화면으로 이동
          },
          color: const Color(0xffF5004F), // 버튼 색상 설정
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
