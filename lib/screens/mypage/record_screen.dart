import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qnart/screens/mypage/chat_record_screen.dart';
import 'package:qnart/utils/fetch_csrf_token.dart';
import 'package:qnart/utils/get_user_pk.dart';
import 'package:qnart/utils/size_config.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:qnart/widgets/mypage/mypage_container.dart';
import 'package:http/http.dart' as http;

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  int? userPk;
  List<dynamic> userRecord = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserRecord();
  }

  Future<void> fetchUserRecord() async {
    var record = await getUserRecord();
    setState(() {
      userRecord = record;
      isLoading = false;
    });
    print(userRecord);
  }

  Future<List<dynamic>> getUserRecord() async {
    userPk = await getUserPk();
    const apiUrl = "http://13.124.100.182/masterpiece/chat/history/";
    String csrfToken = await fetchCsrfToken(apiUrl);
    final url = Uri.parse(apiUrl);
    var headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken, // CSRF 토큰 포함
      "Cookie": "csrftoken=$csrfToken",
    };
    final body = jsonEncode({
      'user_pk': userPk,
      'action': 'comleted',
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        // print(data);
        return data;
      } else {
        print('Error: $response.statusCode');
        return [];
      }
    } finally {}
  }

  void getRecordDetail(int index) {
    final res = userRecord[index];
    print("res: $res");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRecordScreen(
          chatDetailData: res,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
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
          title: '대화 기록 보기',
          childComponent: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: userRecord.length,
                    itemBuilder: (context, index) {
                      var record = userRecord[index];
                      return RecordBtn(
                        title: record['artwork']['title'],
                        artist: record['artwork']['artist'],
                        imagePath: record['artwork']['image_path'],
                        docentId: record['docent_id'],
                        callback: () => getRecordDetail(index),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}

class RecordBtn extends StatelessWidget {
  final String title;
  final String artist;
  final String imagePath;
  final int docentId;
  final void Function() callback;
  const RecordBtn(
      {super.key,
      required this.title,
      required this.artist,
      required this.imagePath,
      required this.docentId,
      required this.callback});

  String get imagePathName {
    switch (docentId) {
      case 1:
        return "van";
      case 2:
        return "octo";
      case 3:
        return "monet";
      case 4:
        return "piri";
      default:
        return "unknown"; // 예외 처리용 기본값
    }
  }

  String get colorName {
    switch (docentId) {
      case 1:
        return "69BDFF";
      case 2:
        return "E1AFD1";
      case 3:
        return "BC9F8B";
      case 4:
        return "6A1C12";
      default:
        return "ffffff"; // 예외 처리용 기본값
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('asset/img/chars/${imagePathName}_sized.png'),
              ),
              color: Colors.transparent,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: callback,
            child: Container(
              width: 260,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(int.parse("0xff$colorName")),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 3.0,
                    offset: Offset(0, 5.0),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Row(
                children: [
                  Container(
                    width: 92,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          artist,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xff020D50),
                          ),
                        ),
                        Text(
                          title,
                          textAlign: TextAlign.start,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
