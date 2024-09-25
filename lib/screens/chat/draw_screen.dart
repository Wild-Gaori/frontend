import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qnart/utils/fetch_csrf_token.dart';
import 'package:qnart/widgets/chat/bot_message.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:qnart/widgets/chat/user_message.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final List<Map<String, String>> _messages = [
    {'sender': 'bot', 'text': '이제 감상 내용을 바탕으로 그림을 그려볼 시간이야!'}
  ]; // 발신자-메시지 저장
  final TextEditingController _controller = TextEditingController();
  final SpeechToText _speech = SpeechToText();
  final bool _isListening = false;
  bool _speechEnabled = false;
  String _ttsText = '';

  String prompt = "";

  @override
  void initState() {
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

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'user', 'text': _controller.text});
        prompt = _controller.text; // 프롬프트 설정
        _controller.clear();
      });
    }
    _getBotMessage();
  }

  Future<void> _getBotMessage() async {
    // dalle 응답 받아오기
    String csrfToken =
        await fetchCsrfToken('http://13.124.100.182/imagegen/generate');
    final url = Uri.parse('http://13.124.100.182/imagegen/generate');
    var headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken, // CSRF 토큰 포함
      "Cookie": "csrftoken=$csrfToken",
    };
    final body = jsonEncode({
      'prompt': prompt,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        String dalleResponse = response.body;
        setState(() {
          _messages.add({'sender': 'bot', 'text': dalleResponse});
        });
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
    print('mic clicked');
    setState(() {});
  }

  void _stopListening() async {
    await _speech.stop();
    print('mic stopped');
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
      // resizeToAvoidBottomInset: false,
      appBar: const MainAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                if (_messages[index]['sender'] == 'user') {
                  return UserMessage(
                    message: _messages[index]['text']!,
                  );
                } else {
                  return BotMessage(
                    message: _messages[index]['text']!,
                  );
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
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
