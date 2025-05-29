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
    if (missionInputController.text.trim() == selectedMission['content']) {
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
            title: const Text('미션 성공!'),
            content: const Text('광고를 시청하고 포인트를 받으시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AdPage.routeName);
                },
                child: const Text('광고 시청하기'),
              ),
            ],
          ),
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
    final String missionContent =
        selectedMission.isNotEmpty
            ? selectedMission['content'] ?? '미션 로딩 중...'
            : '미션 로딩 중...';
    
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Typecash 🏠'))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ! 날짜, 포인트, 포인트 사용하기 버튼 섹션
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        '${DateTime.now().year}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().day.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.monetization_on, size: 20),
                          const SizedBox(width: 5),
                          Text('내 포인트:', style: TextStyle(fontSize: 16)),
                          Text(
                            ' $point',
                            style: TextStyle(
                              fontSize: 16,
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
                        child: Row(
                          children: [
                            const Icon(Icons.card_giftcard, size: 20),
                            const SizedBox(width: 5),
                            Text('신청', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // ! 타이핑 미션 섹션
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                  children: [
                  const Icon(Icons.campaign, size: 20),
                  const SizedBox(width: 5),
                  const Text(
                    '13개 문제 중 ',
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    '6번째',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    ' 문장입니다',
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(13, (index) {
                  // 서버에서 받아올 수행 여부를 임시로 설정
                  bool isCompleted = index < 6; // 6개 수행 완료, 나머지 미완료
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                    isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isCompleted ? Colors.green : Colors.grey,
                    size: 20,
                    ),
                  );
                  }),
                ),
                const SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                    missionContent,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => {FocusScope.of(context).unfocus()},
                    child: TextField(
                    controller: missionInputController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '미션 문장을 따라 작성해주세요 ⌨️',
                    ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.blue[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _handleMissionSubmit,
                    child: Text('입력 완료', 
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[200]),
                    )
                  ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer, size: 15),
                        const SizedBox(width: 5),
                        const Text(
                          '다음 미션까지 남은 시간',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            );
                          }
                        },
                      ),
                  ],
                  ),
                ),
                ],
            ),
            const SizedBox(height: 30),
            // ! 앱 푸시 알람 설정 섹션
            Expanded(
              child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(
                  color: Colors.grey[500]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                    children: [
                      const Icon(Icons.notifications, size: 20),
                      const SizedBox(width: 5),
                      const Text(
                      '받아쓰기 알림을 받으시겠어요?',
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      ),
                    ],
                    ),
                    Transform.scale(
                    scale: 0.8, // Adjust the scale to match the text size
                    child: StatefulBuilder(
                      builder: (context, setState) {
                      return Switch(
                        value: isNotificationEnabled,
                        onChanged: (value) {
                        setState(() {
                          isNotificationEnabled = value;
                        });
                        // Handle switch change logic here
                        debugPrint('Notification enabled: $value');
                        },
                      );
                      },
                    ),
                    ),
                  ],
                  ),
                  const Text(
                  '매 시 정각에 새로운 받아쓰기 문장이 열릴 때 알려드릴게요, 포인트 적립 순간을 놓치지 마세요.',
                  style: TextStyle(fontSize: 13),
                  ),
                ],
                ),
              ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
