import 'package:flutter/material.dart';
import 'package:qnart/widgets/common/inituserinfo.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:qnart/widgets/mypage/mypage_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  int? userPk;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserPk();
  }

  Future<void> getUserPk() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    setState(() {
      userPk = sharedPreferences.getInt('user_pk');
    });
  }

  Future<void> getUserInfo() async {
    var url = Uri.parse('http://13.124.100.182/account/update-userprofile/');
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nicknameController = TextEditingController();
    final TextEditingController birthdateController = TextEditingController();
    final TextEditingController genderController = TextEditingController();
    final TextEditingController clothingController = TextEditingController();
    final TextEditingController hairStyleController = TextEditingController();

    final List<Map<String, TextEditingController>> initMessages = [
      {"내 이름은": nicknameController},
      {"생년월일은": birthdateController},
      {"성별은": genderController},
      {"내 옷은": clothingController},
      {"내 머리 모양은": hairStyleController},
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
