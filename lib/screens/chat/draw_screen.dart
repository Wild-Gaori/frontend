import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qnart/utils/fetch_csrf_token.dart';
import 'package:qnart/widgets/chat/bot_message.dart';
import 'package:qnart/widgets/chat/draw_buttons.dart';
import 'package:qnart/widgets/chat/image_message.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:qnart/widgets/chat/user_message.dart';
import 'package:qnart/widgets/common/yellow_button.dart';
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
    {'sender': 'bot', 'text': '이제 감상 내용을 바탕으로 그림을 그려볼 시간이야!'},
    {'sender': 'button', 'text': '그림 그릴 방법 선택'}
  ]; // 발신자-메시지 저장
  final TextEditingController _controller = TextEditingController();
  final SpeechToText _speech = SpeechToText();
  // final bool _isListening = false;
  bool _speechEnabled = false;
  String _ttsText = '';
  String prompt = ""; // 달리 프롬프트

  String selectedOption = ""; // 세가지 방법 중 선택된 것
  int repaintCnt = 0; // 다시 그리기 사용 횟수
  bool isPainting = false; // 채팅 입력이 가능한 상태 or 아닌 상태

  final ScrollController _scrollController = ScrollController();

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
        _scrollController.animateTo(
          curve: Curves.easeInOut,
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
        );
      });
      _getBotMessage();
    }
  }

  Future<void> _getBotMessage() async {
    // dalle 응답 받아오기
    String csrfToken =
        await fetchCsrfToken('http://13.124.100.182/imagegen/generate/');
    final url = Uri.parse('http://13.124.100.182/imagegen/generate/');
    var headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken, // CSRF 토큰 포함
      "Cookie": "csrftoken=$csrfToken",
    };
    final body = jsonEncode({
      'action': selectedOption,
      'prompt': prompt,
    });

    try {
      setState(() {
        _messages.add({'sender': 'bot', 'text': '그림을 그리는 중이야, 잠시만 기다려줘!'});
        isPainting = false;
        _scrollController.animateTo(
          curve: Curves.easeInOut,
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
        );
      });
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final dalleResponse = (jsonDecode(response.body))["image_url"];
        print(dalleResponse);
        setState(() {
          _messages.add({'sender': 'image', 'text': dalleResponse});
          _scrollController.animateTo(
            curve: Curves.easeInOut,
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
          );
          isPainting = false;
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
    // print('mic clicked');
    setState(() {});
  }

  void _stopListening() async {
    await _speech.stop();
    // print('mic stopped');
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _ttsText = result.recognizedWords;
      _controller.text = _ttsText;
    });
  }

  void _incrementRepaintCnt() {
    setState(() {
      repaintCnt++;
      isPainting = true;
    });
    if (repaintCnt > 3) {
      isPainting = false;
    }
    print(repaintCnt);
  }

  void _handleSelect(String option) {
    setState(() {
      selectedOption = option;
      _messages.removeWhere((message) => message['sender'] == 'button');
      isPainting = true;
    });
    print(option);
    if (option == "experience") {
      _messages.add({
        'sender': 'bot',
        'text': '감상한 그림에 관련된 네 경험에 대해 자세히 말해주면 그림을 그려볼게!',
      });
    } else if (option == "change") {
      _messages.add({
        'sender': 'bot',
        'text': '감상했던 그림에서 바꾸고 싶은 부분을 말해주면 그림을 그려볼게!',
      });
    } else if (option == "imagine") {
      _messages.add({
        'sender': 'bot',
        'text': '감상했던 그림에서 나타나지 않은 부분을 상상해볼까?',
      });
    } else {}
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
                } else if (_messages[index]['sender'] == 'button') {
                  return DrawButtons(
                    onSelect: _handleSelect,
                  );
                } else {
                  return ImageMessage(
                    url: _messages[index]['text']!,
                    onRedraw: _incrementRepaintCnt,
                  );
                }
              },
            ),
          ),
          repaintCnt > 3
              ? YellowButton(text: '종료하기', handlePress: () {})
              : Container(),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: isPainting,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: (repaintCnt > 3)
                          ? "다시 그리기 기회를 모두 소모했어요."
                          : (_speech.isListening
                              ? '음성 인식 중입니다...'
                              : '메시지를 입력하세요'),
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
