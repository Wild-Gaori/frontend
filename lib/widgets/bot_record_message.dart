import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:qnart/utils/fetch_csrf_token.dart';
import 'package:qnart/utils/get_user_pk.dart';
import '../../env/env.dart';

import 'package:http/http.dart' as http;

class BotRecordMessage extends StatefulWidget {
  final int selectedDocentId;
  final String message;

  const BotRecordMessage({
    super.key,
    required this.message,
    required this.selectedDocentId,
  });

  @override
  State<BotRecordMessage> createState() => _BotRecordMessageState();
}

class _BotRecordMessageState extends State<BotRecordMessage> {
  String docentName = "unknown"; //기본값

  @override
  void initState() {
    super.initState();
  }

  String getselectedDocentName(int id) {
    switch (id) {
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

  String getselectedDocentVoice() {
    switch (widget.selectedDocentId) {
      case 1:
        return "ngaram";
      case 2:
        return "nsunhee";
      case 3:
        return "ndain";
      case 4:
        return "nwoosik";
      default:
        return "ngaram";
    }
  }

  //naver TTS 버전
  Future<void> getSpeech() async {
    String voice = getselectedDocentVoice();
    const String apiUrl =
        'https://naveropenapi.apigw.ntruss.com/tts-premium/v1/tts';

    try {
      var response = await http.post(Uri.parse(apiUrl), headers: {
        'X-NCP-APIGW-API-KEY-ID': Env.clientId,
        'X-NCP-APIGW-API-KEY': Env.clientSecret2,
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        'speaker': voice,
        'text': widget.message,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: getselectedDocentName(widget.selectedDocentId) == "unknown"
                  ? null
                  : DecorationImage(
                      image: AssetImage(
                          'asset/img/chars/${getselectedDocentName(widget.selectedDocentId)}_sized.png'),
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
              child: Text(
                widget.message,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 25,
            height: 50,
            child: IconButton(
              onPressed: getSpeech,
              icon: const Icon(Icons.volume_down_rounded),
              padding: EdgeInsets.zero,
              iconSize: 35.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      )),
    );
  }
}
