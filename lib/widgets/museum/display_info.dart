import 'package:flutter/material.dart';
import 'package:qnart/screens/museum/exhibition_detail_screen.dart';
import 'package:qnart/utils/size_config.dart';

class DisplayInfo extends StatefulWidget {
  const DisplayInfo({
    super.key,
  });

  @override
  State<DisplayInfo> createState() => _DisplayInfoState();
}

class _DisplayInfoState extends State<DisplayInfo> {
  int selectedFloor = 0;

  void _changeFloor(int floor) {
    setState(() {
      selectedFloor = floor;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight * 0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          //층별벼튼
          Row(
            children: [
              //임시...
              _buildDisplayButton(3),
            ],
          ),
          const SizedBox(height: 10.0),
          //전시포스터 + 이름&정보
          Row(
            children: [
              Container(
                //포스터
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Image.asset(
                  'asset/img/museum/exhibition_main.png',
                  width: 170,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '이강소: \n風來水面時 풍래수면시',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      //임시
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ExhibitDetailScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        '전시 정보 보기',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayButton(int floor) {
    return GestureDetector(
      onTap: () => _changeFloor(floor),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selectedFloor == floor
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[400]!,
              width: 2.0,
            ),
          ),
        ),
        child: Text('$floor전시실'),
      ),
    );
  }
}
