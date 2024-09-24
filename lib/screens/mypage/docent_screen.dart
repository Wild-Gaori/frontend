import 'package:flutter/material.dart';
import 'package:qnart/widgets/common/main_appbar.dart';
import 'package:qnart/widgets/mypage/mypage_container.dart';

class DocentScreen extends StatelessWidget {
  const DocentScreen({super.key});
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
                    children: const <Widget>[
                      DocentInfo(
                        id: 'van',
                        name: '빈센트 반 고래',
                        comment: '안녕, 친구들! 오늘은 우리 같이 그림 속으로 모험을 떠나볼까?',
                        cleared: true,
                      ),
                      DocentInfo(
                        id: 'octo',
                        name: '진주 귀걸이 문어',
                        comment: 'comment',
                        cleared: false,
                      ),
                      DocentInfo(
                        id: 'monet',
                        name: '클로드 모네 해달',
                        comment: 'comment',
                        cleared: false,
                      ),
                      DocentInfo(
                        id: 'piri',
                        name: '피리 부는 가오리',
                        comment: 'comment',
                        cleared: false,
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
  //Docent모델 정의 후 나중에 바꿀것
  final String id; //van, octo, ...
  final String name;
  final String comment;
  final bool cleared;

  const DocentInfo({
    required this.id,
    required this.name,
    required this.comment,
    required this.cleared,
    super.key,
  });

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
            ),
          ),
          Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage(widget.cleared
                    ? 'asset/img/chars/${widget.id}_sized.png'
                    : 'asset/img/chars/black/${widget.id}_black.png'),
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
            onPressed: widget.cleared ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              widget.cleared ? '선택하기' : '선택 불가',
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
