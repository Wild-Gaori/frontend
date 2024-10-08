import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qnart/screens/chat/draw_screen.dart';
import 'package:qnart/utils/fetch_csrf_token.dart';
import 'package:qnart/widgets/chat/bot_message.dart';
import 'package:qnart/widgets/chat/show_image_container.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:qnart/widgets/chat/user_message.dart';
import 'package:qnart/widgets/common/yellow_button.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final int sessionId;
  final String imgPath;

  const ChatScreen({super.key, required this.sessionId, required this.imgPath});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [
    {'sender': 'bot', 'text': '안녕! 오늘은 이 그림에 대해 이야기해볼까? 먼저 그림을 천천히 감상해보자!'}
  ]; // 발신자-메시지 저장
  final TextEditingController _controller = TextEditingController();
  final SpeechToText _speech = SpeechToText();
  final bool _isListening = false;
  bool _speechEnabled = false;
  String _ttsText = '';
  String prompt = '';
  bool isChatting = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _initChat();
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await Permission.microphone.status;
    _speechEnabled = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
    print('Speech enabled: $_speechEnabled');
    setState(() {});
  }

  void _initChat() {
    setState(() {
      _messages.add({'sender': 'image', 'text': widget.imgPath});
      prompt = "시작";
    });
    print(prompt);
    _getBotMessage();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'user', 'text': _controller.text});
        prompt = _controller.text;
        _controller.clear();
      });
      _scrollController.animateTo(
        curve: Curves.easeInOut,
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
      );
    }
    _getBotMessage();
  }

  void _getBotMessage() async {
    // GPT 응답 받아오기
    String csrfToken =
        await fetchCsrfToken('http://13.124.100.182/masterpiece/chat/');
    final url = Uri.parse('http://13.124.100.182/masterpiece/chat/');
    var headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken, // CSRF 토큰 포함
      "Cookie": "csrftoken=$csrfToken",
    };
    final body = jsonEncode({
      'session_id': widget.sessionId,
      'message': prompt,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final gptResponse =
            (jsonDecode(utf8.decode(response.bodyBytes)))["response"];
        print(gptResponse);
        setState(() {
          _messages.add({'sender': 'bot', 'text': gptResponse});
        });
        _scrollController.animateTo(
          curve: Curves.easeInOut,
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
        );

        // 종료 시퀀스
        if (gptResponse.contains('그림 그리러 가자')) {
          setState(() {
            isChatting = false;
          });
        }
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } finally {}
  }

  void _startListening() async {
    await _speech.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      localeId: 'ko_KR',
    );
    // print('mic clicked');
    setState(() {});
  }

  void _stopListening() async {
    await _speech.stop();
    // print('mic stopped');
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    print('speech result');
    print(result);
    setState(() {
      _ttsText = result.recognizedWords;
      _controller.text = _ttsText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                if (_messages[index]['sender'] == 'user') {
                  return UserMessage(
                    message: _messages[index]['text']!,
                  );
                } else if (_messages[index]['sender'] == 'bot') {
                  return BotMessage(
                    message: _messages[index]['text']!,
                  );
                } else {
                  return ShowImageContainer(
                    imgPath: _messages[index]['text']!,
                  );
                }
              },
            ),
          ),
          !isChatting
              ? YellowButton(
                  text: '그림 그리러 가기',
                  handlePress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DrawScreen(),
                      ),
                    );
                  },
                )
              : Container(),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: isChatting,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText:
                          _speech.isListening ? '음성 인식 중입니다...' : '메시지를 입력하세요',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    cursorColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                IconButton(
                  onPressed:
                      _speech.isNotListening ? _startListening : _stopListening,
                  icon: Icon(
                    _speech.isListening ? Icons.mic : Icons.mic_none,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
