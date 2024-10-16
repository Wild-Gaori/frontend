import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qnart/screens/chat/chat_screen.dart';
import 'package:qnart/widgets/art_card.dart';
import 'package:qnart/widgets/chat/bot_message.dart';
import 'package:qnart/widgets/common/dialog_drawing_ui.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:http/http.dart' as http;

class ArtCardScreen extends StatefulWidget {
  const ArtCardScreen({super.key});

  @override
  State<ArtCardScreen> createState() => _ArtCardScreenState();
}

class _ArtCardScreenState extends State<ArtCardScreen> {
  String hook = "설명";
  String title = "제목";
  String imgPath = "";
  int session_id = 0;
  int id = 0; // artwort id

  Future<void> handleRandom() async {
    final url = Uri.parse("http://13.124.100.182/masterpiece/random/");
    final response = await http.get(url);
    print(response.body);

    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      imgPath = jsonData["image_path"];
      hook = jsonData["hook"];
      title = jsonData["title"];
      session_id = jsonData["session_id"];
      id = jsonData["id"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handleRandom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            "오늘의 명화 카드",
            style: TextStyle(
              fontSize: 28,
            ),
          ),
          Image.asset('asset/img/title_underline_yellow.png'),
          const SizedBox(height: 20),
          Center(
              child: ArtCard(
            imgUrl: imgPath,
            title: title,
            hook: hook,
          )),
          const SizedBox(height: 20),
          const BotMessage(
            message: '이야기를 나눌 준비가 되었다면 아래 버튼을 눌러줘!',
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          sessionId: session_id,
                          imgPath: imgPath,
                          artworkId: id,
                        )),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              '감상 시작하기',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
