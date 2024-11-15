import 'package:flutter/material.dart';

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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
