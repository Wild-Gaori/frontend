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
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.black,
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
                        name: '빈센트 반 고래',
                        comment: '안녕, 친구들! 오늘은 우리 같이 그림 속으로 모험을 떠나볼까?',
                        imgLink: 'asset/img/chars/van_sized.png',
                      ),
                      DocentInfo(
                        name: 'name',
                        comment: 'comment',
                        imgLink: 'asset/img/chars/van_sized.png',
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
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
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

class DocentInfo extends StatelessWidget {
  //Docent모델 정의 후 나중에 바꿀것
  final String name;
  final String comment;
  final String imgLink;

  const DocentInfo({
    required this.name,
    required this.comment,
    required this.imgLink,
    super.key,
  });

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
              comment,
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
                image: AssetImage(imgLink),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xff020d50),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              '선택하기',
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
