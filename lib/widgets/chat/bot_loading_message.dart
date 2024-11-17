import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qnart/utils/fetch_csrf_token.dart';
import 'package:qnart/utils/get_user_pk.dart';
import 'package:http/http.dart' as http;

class BotLoadingMessage extends StatefulWidget {
  final String message;

  const BotLoadingMessage({
    super.key,
    required this.message,
  });

  @override
  State<BotLoadingMessage> createState() => _BotLoadingMessageState();
}

class _BotLoadingMessageState extends State<BotLoadingMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  int _dotCnt = 0;

  int selectedDocentId = 1;
  String docentName = "van";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat(reverse: true);
    _timer = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        _dotCnt = (_dotCnt + 1) % 4; // 점 개수: 0, 1, 2, 3
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void getSelectedDocent() async {
    int userPk = await getUserPk();
    const apiUrl = "http://13.124.100.182/docent/get-selected-docent/";
    String csrfToken = await fetchCsrfToken(apiUrl);
    final url = Uri.parse(apiUrl);
    var headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken, // CSRF 토큰 포함
      "Cookie": "csrftoken=$csrfToken",
    };
    final body = jsonEncode({
      'user_pk': userPk,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 18.0, 0, 10.0),
      child: (Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('asset/img/chars/${docentName}_sized.png'),
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
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
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                children: [
                  Text(
                    widget.message,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) {
                      return Text(
                        '.' * _dotCnt, // 점 개수에 따라 표시
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 25,
            height: 50,
          ),
        ],
      )),
    );
  }
}
