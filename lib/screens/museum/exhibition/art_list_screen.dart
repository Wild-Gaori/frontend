import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qnart/screens/museum/exhibition/art_chat_screen.dart';
import 'package:qnart/utils/fetch_csrf_token.dart';
import 'package:qnart/utils/get_user_pk.dart';
import 'package:qnart/utils/size_config.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:qnart/widgets/museum/museum_container.dart';
import 'package:http/http.dart' as http;

class ArtListScreen extends StatefulWidget {
  const ArtListScreen({super.key});

  @override
  State<ArtListScreen> createState() => _ArtListScreenState();
}

class _ArtListScreenState extends State<ArtListScreen> {
  List<dynamic> artList = [];
  List<dynamic> completedArtworkIds = [];
  int sessionId = 0; // 각 artwork 눌렀을 때 생성되는 세션id
  int selectedDocentId = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArtList();
    checkCompletion();
  }

  void getArtList() async {
    const apiUrl = "http://13.124.100.182/masterpiece/gallery/list/";
    String csrfToken = await fetchCsrfToken(apiUrl);
    final url = Uri.parse(apiUrl);
    var headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken, // CSRF 토큰 포함
      "Cookie": "csrftoken=$csrfToken",
    };
    final body = jsonEncode({
      "artwork_ids": [5, 6, 7, 8] // 전시 작품 4개
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes))["artworks"];
        print(data);
        setState(() {
          artList = data;
        });
      } else {
        print('Error: $response.statusCode');
      }
    } finally {}
  }

  void checkCompletion() async {
    // 감상 끝낸 작품 불러오기
    int userPk = await getUserPk();
    const apiUrl = "http://13.124.100.182/masterpiece/gallery/completed/";
    String csrfToken = await fetchCsrfToken(apiUrl);
    final url = Uri.parse(apiUrl);
    var headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken, // CSRF 토큰 포함
      "Cookie": "csrftoken=$csrfToken",
    };
    final body = jsonEncode({
      "user_pk": userPk,
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["completed_artwork_ids"];
        print(data);
        setState(() {
          completedArtworkIds = data;
        });
      } else {
        print('Error: $response.statusCode');
      }
    } finally {}
  }

  void startArtChat(int artworkId, String imagePath) async {
    // 각 작품의 세션 생성
    int userPk = await getUserPk();
    const apiUrl = "http://13.124.100.182/masterpiece/gallery/create_session/";
    String csrfToken = await fetchCsrfToken(apiUrl);
    final url = Uri.parse(apiUrl);
    var headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken, // CSRF 토큰 포함
      "Cookie": "csrftoken=$csrfToken",
    };
    final body = jsonEncode({
      "user_pk": userPk,
      "artwork_id": artworkId,
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data);
        setState(() {
          sessionId = data['session_id'];
          selectedDocentId = data['selected_docent_id'];
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtChatScreen(
              imagePath: imagePath,
              sessionId: sessionId,
              artworkId: artworkId,
            ),
          ),
        );
      } else {
        print('Error: $response.statusCode');
      }
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: const MainAppBar(),
      body: MuseumContainer(
        childComponent: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight * 0.75,
          decoration: const BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 170 / 190,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: artList.length,
              itemBuilder: (context, index) {
                final artwork = artList[index];
                return ArtListContent(
                  imagePath: artwork['image_path'],
                  title: artwork['title'],
                  callback: () =>
                      startArtChat(artwork['id'], artwork['image_path']),
                  isComplete: completedArtworkIds.contains(artwork['id']),
                );
              },
            ),
          ),
        ),
        title: '전시 작품 목록',
      ),
    );
  }
}

class ArtListContent extends StatelessWidget {
  final String title;
  final String imagePath;
  final void Function() callback;
  final bool isComplete;
  const ArtListContent(
      {super.key,
      required this.title,
      required this.imagePath,
      required this.callback,
      required this.isComplete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isComplete ? null : callback,
      child: Stack(children: [
        Container(
          width: 170,
          height: 195,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isComplete ? Colors.grey : Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 3.0,
                offset: Offset(0, 5.0),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 130,
                height: 140,
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(imagePath)),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 5,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: isComplete
                  ? const DecorationImage(
                      image: AssetImage('asset/img/chars/stamp_1.png'),
                    )
                  : null,
            ),
            width: 100,
            height: 100,
          ),
        ),
      ]),
    );
  }
}
