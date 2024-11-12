import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qnart/utils/fetch_csrf_token.dart';
import 'package:qnart/utils/get_user_pk.dart';
import 'package:qnart/widgets/common/dialog_ui.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:qnart/widgets/mypage/mypage_container.dart';
import 'package:http/http.dart' as http;

class DocentScreen extends StatefulWidget {
  const DocentScreen({super.key});

  @override
  State<DocentScreen> createState() => _DocentScreenState();
}

class _DocentScreenState extends State<DocentScreen> {
  int? userPk;
  int selectedDocentId = 0; // 현재 선택된 도슨트 Id
  int sessionCount = 0; // 현재까지 감상 횟수 (세션 수)

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSelectedDocent();
    getSessionCount();
  }

  void getSelectedDocent() async {
    userPk = await getUserPk();
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
          print("selected d id : $selectedDocentId");
        });
      } else {
        print('Error: $response.statusCode');
      }
    } finally {}
  }

  // 현재 감상 횟수 가져오기: 감상 기록의 length
  void getSessionCount() async {
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
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        // print(data);
        setState(() {
          sessionCount = data.length;
          print("session count : $sessionCount");
        });
      } else {
        print('Error: $response.statusCode');
      }
    } finally {}
  }

  // 도슨트 선택
  void selectDocent(int docentId) async {
    setState(() {
      selectedDocentId = docentId;
    });
    const apiUrl = "http://13.124.100.182/docent/update-selected-docent/";
    String csrfToken = await fetchCsrfToken(apiUrl);
    final url = Uri.parse(apiUrl);
    var headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken, // CSRF 토큰 포함
      "Cookie": "csrftoken=$csrfToken",
    };
    final body = jsonEncode({
      'user_pk': userPk,
      'selected_docent_id': selectedDocentId,
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return const DialogUI(
              dialogMessage: '도슨트를 변경했어요.',
            );
          },
        );
      } else {
        print('Error: $response.statusCode');
      }
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

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
          title: '수집한 도슨트 목록',
          childComponent: SizedBox(
            // width: MediaQuery.of(context).size.width * 0.9,
            height: 500,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 50,
                  child: IconButton(
                    onPressed: () {
                      controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: PageView(
                    controller: controller,
                    children: <Widget>[
                      DocentInfo(
                        selectedDocentId: selectedDocentId,
                        id: 1, //van
                        name: '빈센트 반 고래',
                        comment: '안녕, 친구들! 오늘은 우리 같이 그림 속으로 모험을 떠나볼까?',
                        cleared: true,
                        onSelect: selectDocent,
                      ),
                      DocentInfo(
                        selectedDocentId: selectedDocentId,
                        id: 2, //octo
                        name: '진주 귀걸이 문어',
                        comment: '안녕하세요, 친구들. 오늘은 이 멋진 그림을 천천히 감상해보도록 합시다.',
                        cleared: (sessionCount >= 5) ? true : false,
                        onSelect: selectDocent,
                      ),
                      DocentInfo(
                        selectedDocentId: selectedDocentId,
                        id: 3, //monet
                        name: '클로드 모네 해달',
                        comment: '안녕, 나는 모네 해달이야! 오늘은 모네의 아름다운 연못과 정원을 함께 볼까?',
                        cleared: (sessionCount >= 10) ? true : false,
                        onSelect: selectDocent,
                      ),
                      DocentInfo(
                        selectedDocentId: selectedDocentId,
                        id: 4, //piri
                        name: '피리 부는 가오리',
                        comment:
                            '안녕, 친구들! 나는 까칠한 피리부는 가오리야. 소년의 피리 소리가 들리지 않아? 내 말 잘 듣고 따라와 봐.',
                        cleared: (sessionCount >= 15) ? true : false,
                        onSelect: selectDocent,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 50,
                  child: IconButton(
                    onPressed: () {
                      controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DocentInfo extends StatefulWidget {
  final int selectedDocentId;
  //Docent모델 정의 후 나중에 바꿀것
  final int id; //1 van, 2 octo, 3 monet, 4 piri
  final String name;
  final String comment;
  final bool cleared;
  final Function(int) onSelect;

  const DocentInfo({
    required this.selectedDocentId,
    required this.id,
    required this.name,
    required this.comment,
    required this.cleared,
    required this.onSelect,
    super.key,
  });

  String get imagePathName {
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
        return "unknown"; // 예외 처리용 기본값
    }
  }

  @override
  State<DocentInfo> createState() => _DocentInfoState();
}

class _DocentInfoState extends State<DocentInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: 250,
            height: 100,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.onPrimary,
                width: 1,
              ),
            ),
            child: Text(
              widget.cleared ? widget.comment : '아직 만나지 못한 도슨트예요.',
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          Container(
            height: 220,
            width: 220,
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage(widget.cleared
                    ? 'asset/img/chars/${widget.imagePathName}_sized.png'
                    : 'asset/img/chars/black/${widget.imagePathName}_black.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            widget.cleared ? widget.name : '???',
            style: const TextStyle(
              color: Color(0xff020d50),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: widget.cleared
                ? (widget.id == widget.selectedDocentId
                    ? null
                    : () => widget.onSelect(widget.id))
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              widget.cleared
                  ? (widget.id == widget.selectedDocentId ? '선택 중' : '선택하기')
                  : '선택 불가',
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
