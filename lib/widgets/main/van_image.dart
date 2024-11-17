import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qnart/utils/fetch_csrf_token.dart';
import 'package:qnart/utils/get_user_pk.dart';

class VanImage extends StatefulWidget {
  const VanImage({super.key});

  @override
  State<VanImage> createState() => _VanImageState();
}

class _VanImageState extends State<VanImage> {
  int selectedDocentId = 0; //기본값
  String docentName = "unknown"; //기본값

  @override
  void initState() {
    super.initState();
    getSelectedDocent();
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
        return "unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: docentName == "unknown"
          ? null
          : Image.asset(
              'asset/img/chars/${docentName}_sized.png',
              height: MediaQuery.of(context).size.height * 0.25,
            ),
    );
  }
}
