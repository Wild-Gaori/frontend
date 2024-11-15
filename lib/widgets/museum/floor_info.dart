import 'package:flutter/material.dart';
import 'package:qnart/utils/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class FloorInfo extends StatefulWidget {
  const FloorInfo({
    super.key,
  });

  @override
  State<FloorInfo> createState() => _FloorInfoState();
}

class _FloorInfoState extends State<FloorInfo> {
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
      height: SizeConfig.screenHeight * 0.35,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      child: Column(
        children: [
          //층별벼튼, 홈페이지버튼(필요?)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  //임시...
                  _buildFloorButton(0),
                  _buildFloorButton(1),
                  _buildFloorButton(2),
                  _buildFloorButton(3),
                ],
              ),
              TextButton(
                onPressed: () async {
                  final Uri url = Uri.parse('https://www.mmca.go.kr/');
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
                child: Text(
                  '홈페이지',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          //지도 사진
          Container(
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
            child: Image.asset(
              selectedFloor == 0
                  ? 'asset/img/museum/floor_b1.png'
                  : 'asset/img/museum/floor_$selectedFloor.png',
              width: 320,
              height: 210,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloorButton(int floor) {
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
        child: floor == 0 ? const Text('B1층') : Text('$floor층'),
      ),
    );
  }
}
