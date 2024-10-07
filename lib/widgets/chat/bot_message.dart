import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dart_openai/dart_openai.dart';
import '../../env/env.dart';

import 'package:http/http.dart' as http;

class BotMessage extends StatelessWidget {
  final String message;

  const BotMessage({
    super.key,
    required this.message,
  });

  // OpenAI TTS 버전
  // Future<void> getSpeech() async {
  //   OpenAI.apiKey = Env.apiKey;

  //   final directory = await getApplicationCacheDirectory();
  //   final speechOutputDir = Directory('${directory.path}/speechOutput');
  //   if (!speechOutputDir.existsSync()) {
  //     await speechOutputDir.create(recursive: true);
  //   }

  //   File speechFile = await OpenAI.instance.audio.createSpeech(
  //     model: "tts-1",
  //     input: message,
  //     voice: "nova",
  //     responseFormat: OpenAIAudioSpeechResponseFormat.mp3,
  //     outputDirectory: speechOutputDir,
  //   );

  //   print(speechFile.path);

  //   final player = AudioPlayer();
  //   await player.play(UrlSource('file://${speechFile.path}'), volume: 1.0);
  // }

  //naver TTS 버전
  Future<void> getSpeech() async {
    const String apiUrl =
        'https://naveropenapi.apigw.ntruss.com/tts-premium/v1/tts';

    try {
      var response = await http.post(Uri.parse(apiUrl), headers: {
        'X-NCP-APIGW-API-KEY-ID': Env.clientId,
        'X-NCP-APIGW-API-KEY': Env.clientSecret,
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        'speaker': 'ngaram',
        'text': message,
        'format': 'mp3',
      });

      if (response.statusCode == 200) {
        final directory = await getApplicationCacheDirectory();
        final speechOutputDir = Directory('${directory.path}/speechOutput');
        if (!speechOutputDir.existsSync()) {
          await speechOutputDir.create(recursive: true);
        }

        final File speechFile = File('${directory.path}/tts1.mp3');
        await speechFile.writeAsBytes(response.bodyBytes);

        final player = AudioPlayer();
        await player.play(UrlSource('file://${speechFile.path}'), volume: 1.0);
      } else {
        print('Failed to get speech. statusCode: $response.statusCode');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 18.0, 0, 10.0),
      child: (Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: AssetImage('asset/img/chars/van_sized.png'),
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 5),
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
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 25,
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: getSpeech,
                  icon: const Icon(Icons.volume_down_rounded),
                  padding: EdgeInsets.zero,
                  iconSize: 35.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
