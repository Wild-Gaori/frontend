import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qnart/consts/char_texts.dart';
import 'package:qnart/utils/fetch_csrf_token.dart';
import 'package:qnart/utils/get_user_pk.dart';
import 'package:http/http.dart' as http;

class MainBalloon extends StatefulWidget {
  final int userPk;

  const MainBalloon({
    super.key,
    required this.userPk,
  });

  @override
  State<MainBalloon> createState() => _MainBalloonState();
}

class _MainBalloonState extends State<MainBalloon> {
  int selectedDocentId = 1; //기본값
  String docentName = "van"; //기본값

  @override
  void initState() {
    super.initState();
    getSelectedDocent();
  }

  void getSelectedDocent() async {
    const apiUrl = "http://13.124.100.182/docent/get-selected-docent/";
    String csrfToken = await fetchCsrfToken(apiUrl);
    final url = Uri.parse(apiUrl);
    var headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken, // CSRF 토큰 포함
      "Cookie": "csrftoken=$csrfToken",
    };
    final body = jsonEncode({
      'user_pk': widget.userPk,
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        setState(() {
          selectedDocentId = (jsonDecode(response.body))["selected_docent_id"];
          docentName = getselectedDocentName();
          print("selected d id : $selectedDocentId");
        });
      } else {
        print('Error: $response.statusCode');
      }
    } finally {}
  }

  String getselectedDocentName() {
    switch (selectedDocentId) {
      case 1:
        return "van";
      case 2:
        return "octo";
      case 3:
        return "monet";
      case 4:
        return "piri";
      default:
        return "van";
    }
  }

  @override
  Widget build(BuildContext context) {
    int randNum = Random().nextInt(mainTexts[selectedDocentId - 1].length);

    return (Container(
      width: 330,
      height: 70,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('asset/img/balloon.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          child: Text(
            mainTexts[selectedDocentId - 1][randNum],
            style: const TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }
}
