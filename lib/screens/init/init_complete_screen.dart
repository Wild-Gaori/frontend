import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qnart/screens/home_screen.dart';
import 'package:qnart/widgets/common/docent_card.dart';
import 'package:qnart/widgets/museum_title.dart';

class InitCompleteScreen extends StatefulWidget {
  const InitCompleteScreen({super.key});

  @override
  State<InitCompleteScreen> createState() => _InitCompleteScreenState();
}

class _InitCompleteScreenState extends State<InitCompleteScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animationController.forward().whenComplete(() {
      setState(() {
        isChanged = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isChanged ? const VanComplete() : const VanLoading());
  }
}

class VanComplete extends StatelessWidget {
  const VanComplete({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          image: const DecorationImage(
            image: AssetImage('asset/img/pattern.png'),
            fit: BoxFit.cover,
            opacity: .5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const DocentCard(),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: MuseumTitle(title: "새 친구 등장!"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.white,
              ),
              child: Text(
                '다음으로',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VanLoading extends StatefulWidget {
  const VanLoading({
    super.key,
  });

  @override
  State<VanLoading> createState() => _VanLoadingState();
}

class _VanLoadingState extends State<VanLoading> {
  int dotCount = 1;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        dotCount = (dotCount + 1) % 4;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          image: const DecorationImage(
            image: AssetImage('asset/img/pattern.png'),
            fit: BoxFit.cover,
            opacity: .5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage('asset/img/chars/black/van_black.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text('친구를 불러오는 중${'.' * dotCount}'),
          ],
        ),
      ),
    );
  }
}
