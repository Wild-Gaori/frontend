import 'package:flutter/material.dart';
import 'package:qnart/widgets/bot_record_message.dart';
import 'package:qnart/widgets/chat/bot_message.dart';
import 'package:qnart/widgets/chat/show_image_container.dart';
import 'package:qnart/widgets/chat/user_message.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:qnart/widgets/mypage/mypage_container.dart';

class ChatRecordScreen extends StatelessWidget {
  final Map<String, dynamic> chatDetailData;
  final int sessionId;
  final String title;
  final String artist;
  final String imagePath;
  final int docentId;
  final List<Map<String, dynamic>> messages;

  ChatRecordScreen({super.key, required this.chatDetailData})
      : sessionId = chatDetailData["session_id"],
        title = chatDetailData["artwork"]["title"],
        artist = chatDetailData["artwork"]["artist"],
        imagePath = chatDetailData["artwork"]["image_path"],
        docentId = chatDetailData["docent_id"],
        messages = List<Map<String, dynamic>>.from(chatDetailData["messages"]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: ChatHistory(
        messages: messages,
        imagePath: imagePath,
        docentId: docentId,
      ),
    );
  }
}

class ChatHistory extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final String imagePath;
  final int docentId;
  const ChatHistory(
      {super.key,
      required this.messages,
      required this.imagePath,
      required this.docentId});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ShowImageContainer(imgPath: imagePath);
            } else if (messages[index]['role'] == 'user') {
              return UserMessage(
                message: messages[index]['content']!,
              );
            } else if (messages[index]['role'] == 'assistant') {
              return BotRecordMessage(
                selectedDocentId: docentId,
                message: messages[index]['content']!,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
      const SizedBox(height: 20),
    ]);
  }
}
