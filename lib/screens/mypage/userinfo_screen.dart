import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qnart/utils/fetch_csrf_token.dart';
import 'package:qnart/widgets/common/dialog_ui.dart';
import 'package:qnart/widgets/common/inituserinfo.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:qnart/widgets/mypage/mypage_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  int? userPk;

  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController clothingController = TextEditingController();
  final TextEditingController hairStyleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserPk();
    getUserInfo();
  }

  Future<void> getUserPk() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    setState(() {
      userPk = sharedPreferences.getInt('user_pk');
    });
  }

  Future<void> getUserInfo() async {
    // 화면 접속 시 유저 정보 가져오기
    var apiUrl = "http://13.124.100.182/account/get-user-profile/";
    String csrfToken = await fetchCsrfToken(apiUrl);
    var url = Uri.parse(apiUrl); // 유저 정보 가져오기 API
    var headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken, // CSRF 토큰 포함
      "Cookie": "csrftoken=$csrfToken",
    };
    final body = jsonEncode({
      'user_pk': userPk,
    });
    try {
      var response = await http.post(url, headers: headers, body: body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData =
            jsonDecode(utf8.decode(response.bodyBytes));
        print(jsonData);
        setState(() {
          nicknameController.text = (jsonData["nickname"]);
          birthdateController.text = jsonData["birthdate"];
          genderController.text = jsonData["gender"];
          clothingController.text = jsonData["clothing"];
          hairStyleController.text = jsonData["hairstyle"];
        });
      } else {
        print(response.body);
        print(response.statusCode);
      }
    } finally {}
  }

  void showCustomDialog(String dialogMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return DialogUI(
            dialogMessage: dialogMessage,
          );
        });
  }

  void setUserInfo() async {
    final Map<String, String> modifiedUserInfo = {
      'nickname': nicknameController.text,
      'birthdate': birthdateController.text,
      'gender': genderController.text,
      'clothing': clothingController.text,
      'hairstyle': hairStyleController.text,
    };
    var apiUrl = "http://13.124.100.182/account/update-profile/";
    String csrfToken = await fetchCsrfToken(apiUrl);
    var url = Uri.parse(apiUrl); // 유저 정보 가져오기 API
    var headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken, // CSRF 토큰 포함
      "Cookie": "csrftoken=$csrfToken",
    };
    final body = jsonEncode({
      'user_pk': userPk,
      'profile_data': modifiedUserInfo,
    });
    try {
      var response = await http.post(url, headers: headers, body: body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        showCustomDialog("내 정보를 수정했어요.");
      } else {
        print(response.statusCode);
        String decodedResponse = utf8.decode(response.bodyBytes);
        print("Failed to update user information: $decodedResponse");
      }
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: setUserInfo,
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
