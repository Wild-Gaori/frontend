import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_outlined,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        color: const Color(0xffF5004F),
        padding: const EdgeInsets.all(10),
      ),
      title: Image.asset('asset/img/logo.png'),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
