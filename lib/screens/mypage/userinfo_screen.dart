import 'package:flutter/material.dart';
import 'package:qnart/widgets/common/inituserinfo.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:qnart/widgets/mypage/mypage_container.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> initMessages = [
      "내 이름은",
      "생년월일은",
      "성별은",
      "내 옷은",
      "내 머리 모양은",
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const MainAppBar(),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          image: const DecorationImage(
            image: AssetImage('asset/img/pattern.png'),
            fit: BoxFit.cover,
            opacity: .5,
          ),
        ),
        child: MyPageContainer(
          title: '내 정보 수정',
          childComponent: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 325,
                decoration: const BoxDecoration(
                  color: Color(0xffFEF6E6),
                ),
                child: Center(child: InputUserInfo(initMessages: initMessages)),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  '저장하기',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
