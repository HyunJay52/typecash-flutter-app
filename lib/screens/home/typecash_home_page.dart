import 'package:flutter/material.dart';
import 'package:typecash_flutter_app/screens/reward/reward_store_page.dart';
import 'package:typecash_flutter_app/utils/number_format_util.dart';
import 'dart:convert';
import 'dart:math';

import '../ad/ad_page.dart';

class TypecashHomePage extends StatefulWidget {
  static const routeName = '/typecash-home';
  const TypecashHomePage({super.key});

  @override
  State<TypecashHomePage> createState() => _TypecashHomePageState();
}

class _TypecashHomePageState extends State<TypecashHomePage> {
  late List<dynamic> missions = [];
  late Map<String, dynamic> selectedMission = {};
  final TextEditingController missionInputController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMissionsData();
  }

  @override
  void dispose() {
    missionInputController.dispose();
    super.dispose();
  }

  Future<void> _loadMissionsData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final String response = await DefaultAssetBundle.of(
        context,
      ).loadString('assets/data/dump.json');
      final List<dynamic> loadedMissions = List.from(jsonDecode(response));

      setState(() {
        missions = loadedMissions;
        isLoading = false;
      });

      _selectRandomMission();
    } catch (e) {
      debugPrint('Error loading missions data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _selectRandomMission() {
    if (missions.isEmpty) {
      setState(() {
        selectedMission = {
          'id': 'error',
          'content': '사용 가능한 미션이 없습니다.',
          'used': false,
        };
      });
      return;
    }
    // 사용하지 않은 미션만 필터링
    final List<dynamic> unusedMissions =
        missions.where((mission) => mission['used'] == false).toList();

    if (unusedMissions.isEmpty) {
      // 모든 미션이 사용됐다면 상태 초기화 고려
      setState(() {
        selectedMission = {
          'id': 'error',
          'content': '모든 미션을 완료했습니다. 새로운 미션이 곧 업데이트됩니다.',
          'used': false,
        };
      });
      return;
    }

    // 랜덤으로 미션 선택
    final random = Random();
    final int randomIndex = random.nextInt(unusedMissions.length);

    setState(() {
      selectedMission = unusedMissions[randomIndex];
    });
  }

  Future<void> _markMissionAsUsed() async {
    if (selectedMission.isEmpty || selectedMission['id'] == 'error') {
      return;
    }

    // 메모리에서 미션 상태 업데이트
    setState(() {
      // 미션 리스트에서 현재 선택된 미션 찾기
      final int index = missions.indexWhere(
        (mission) => mission['id'] == selectedMission['id'],
      );
      if (index != -1) {
        // 해당 미션의 used 값을 true로 업데이트
        missions[index]['used'] = true;
        selectedMission['used'] = true;
      }
    });

    // 실제 앱에서는 여기서 서버 API를 호출하거나 로컬 데이터베이스에 저장할 수 있습니다
    // 예시: SharedPreferences나 Hive, SQLite 등을 사용

    // 예시: 다음 미션 선택
    _selectRandomMission();
  }

  void _handleMissionSubmit() {
    if (missionInputController.text.trim() ==  'qwer') { // selectedMission['content']) {
      // 미션 성공 처리
      _showAdDialog();
      _markMissionAsUsed();
    } else {
      // 미션 실패 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('정확히 입력해주세요!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAdDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Column(
              children: [
                Image.asset(
                  'assets/images/congrat.png',
                  height: 65,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                const Text(
                  '정답입니다!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3745),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                const Text(
                  '광고를 시청하시면 미션 성공 포인트가 적립됩니다.\n광고를 시청하시겠어요?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CD),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFFEEBA)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFCC8925),
                        size: 18,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '광고를 끝까지 시청하지 않으면 포인트가 지급되지 않습니다.',
                          style: TextStyle(
                            fontSize: 9,
                            color: Color(0xFFCC8925),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AdPage.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3182F7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '광고 시청하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    '닫기',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3182F7),
                    ),
                  ),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            titlePadding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          )
    );
  }

  Stream<Duration> _countdownStream() {
    // 다음 정각 시간 계산
    final now = DateTime.now();
    final nextHour = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour + 1, // 다음 시간
      0, // 0분
      0, // 0초
    );

    return Stream.periodic(const Duration(seconds: 1), (_) {
      final currentTime = DateTime.now();
      final remainingTime = nextHour.difference(currentTime);
      return remainingTime.isNegative ? Duration.zero : remainingTime;
    });
  }

  // ! 위젯 빌드 메서드
  @override
  Widget build(BuildContext context) {
    bool isNotificationEnabled = false;
    final point = NumberFormatUtil.formatNumber(9999000);
    final String missionContent = 'qwer';
    // selectedMission.isNotEmpty
    //     ? selectedMission['content'] ?? '미션 로딩 중...'
    //     : '미션 로딩 중...';

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/logo_v1.png',
            height: 100, // 로고 크기 줄이기
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // 추가: 필요한 공간만 사용
              children: [
                // ! 날짜, 포인트, 포인트 사용하기 버튼 섹션
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/calendar.png',
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${DateTime.now().year}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().day.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/reward.png',
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '내가 모은 포인트:',
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                ' $point',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed:
                                () => {
                                  Navigator.pushNamed(
                                    context,
                                    RewardStorePage.routeName,
                                  ),
                                },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 249, 231, 240),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '신청하기',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFFC97DA1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/speaker.png',
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            '오늘 총 ',
                            style: TextStyle(fontSize: 13),
                            // textAlign: TextAlign.center,
                          ),
                          const Text(
                            '13',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3182F7),
                            ),
                          ),
                          const Text('문제 중 ', style: TextStyle(fontSize: 13)),
                          const Text(
                            '6',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3182F7),
                            ),
                          ),
                          const Text(
                            '번째 문장입니다',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/participation.png',
                                width: 25,
                                height: 25,
                              ),
                              Text(
                                '오늘 참여 현황',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              ...List.generate(13, (index) {
                                // 서버에서 받아올 수행 여부를 임시로 설정
                                bool isCompleted =
                                    index < 6; // 6개 수행 완료, 나머지 미완료
                                return Image.asset(
                                  isCompleted
                                      ? 'assets/images/o.png'
                                      : 'assets/images/x.png',
                                  width: 18,
                                  height: 18,
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // ! 타이핑 미션 섹션 - Flexible 제거
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // 추가: 필요한 공간만 사용
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              'assets/images/question.png',
                              width: 50,
                              height: 50,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(10),
                            child: Text(
                              'qwer', // missionContent,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: missionInputController,
                            builder: (context, value, child) {
                              final isValid =
                                  value.text.trim() ==
                                  selectedMission['content'];
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap:
                                        () => {
                                          FocusScope.of(context).unfocus(),
                                        },
                                    child: TextField(
                                      controller: missionInputController,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color:
                                                isValid || value.text.isEmpty
                                                    ? Colors.grey
                                                    : Colors.red,
                                            width: 2,
                                          ),
                                        ),
                                        // 라벨 대신 힌트 사용, 포커스 시 사라지게 함
                                        hintText: '위 문장을 똑같이 적어 주세요',
                                        hintStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (!isValid && value.text.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        '오답 입니다. 다시 시도해볼까요?',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            188,
                                            55,
                                            45,
                                          ),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(130, 40),
                              backgroundColor: const Color(0xFF3182F7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _handleMissionSubmit,
                            child: Text(
                              '입력 완료',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[200],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
                // ! 다음 미션까지 남은 시간 섹션
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/sand_timer.png',
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(width: 5),
                          // ! 미션 수행 전 "이번 미션 남은 시간", 미션 수행 후 "다음 미션 남은 시간"
                          const Text(
                            '다음 미션까지 남은 시간',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      StreamBuilder<Duration>(
                        stream: _countdownStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final duration = snapshot.data!;
                            final hours = duration.inHours.toString().padLeft(
                              2,
                              '0',
                            );
                            final minutes = (duration.inMinutes % 60)
                                .toString()
                                .padLeft(2, '0');
                            final seconds = (duration.inSeconds % 60)
                                .toString()
                                .padLeft(2, '0');
                            return Text(
                              '$hours:$minutes:$seconds',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                // color: Colors.blue,
                              ),
                            );
                          } else {
                            return const Text(
                              '00:00:00',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                // ! 앱 푸시 알람 설정 섹션
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/notification.png',
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                '받아쓰기 알림을 받으시겠어요?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Transform.scale(
                            scale:
                                0.7, // Adjust the scale to match the text size
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                return Switch(
                                  value: isNotificationEnabled,
                                  activeColor: const Color(0xFF3182F7),
                                  inactiveTrackColor: Colors.grey[300],
                                  inactiveThumbColor: Colors.grey[600],
                                  onChanged: (value) {
                                    setState(() {
                                      isNotificationEnabled = value;
                                    });
                                    debugPrint('Notification enabled: $value');
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          '매 시 정각에 새로운 받아쓰기 문장이 열릴 때 알려드릴게요,\n포인트 적립 순간을 놓치지 마세요.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromARGB(255, 134, 134, 134),
                          ),
                        ),
                      ),
                    ],
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
