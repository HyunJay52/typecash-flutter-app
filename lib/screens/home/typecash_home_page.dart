import 'package:flutter/material.dart';
import 'package:typecash_flutter_app/utils/number_format_util.dart';

import '../../widgets/common_dialog.dart';
import '../ad/ad_page.dart';

class TypecashHomePage extends StatefulWidget {
  static const routeName = '/typecash-home';
  const TypecashHomePage({super.key});

  @override
  State<TypecashHomePage> createState() => _TypecashHomePageState();
}

class _TypecashHomePageState extends State<TypecashHomePage> {
  @override
  Widget build(BuildContext context) {
    final point = NumberFormatUtil.formatNumber(9999000);
    final missionSentence = '포기하지 않는 자에게 기회는 온다';
    String hintSentence = '-';

    return Scaffold(
      appBar: AppBar(title: const Text('Typecash 🏠')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ! 날짜, 포인트, 포인트 사용하기 버튼 섹션
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '2025.05.03',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '내가 모은 포인트: $point',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed:
                          () => {
                            //
                          },
                      child: Text('포인트 사용하기'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // ! 타이핑 미션 섹션
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '총 타이핑 미션: 3회 중 1회 완료',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '도전 > $missionSentence',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => {FocusScope.of(context).unfocus()},
                      // ? Form || TextField
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '타이핑 미션 입력',
                          hintText: hintSentence,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        print('입력 완료 버튼 클릭');
                        CommonDialog(
                          title: "광고",
                          content: "광고",
                          confirmText: "광고 시청하기",
                          cancelText: "취소",
                          onConfirm: () {
                            Navigator.pushNamed(context, AdPage.routeName);
                          },
                          onCancel:
                              () => {
                                //
                              },
                        );
                        // Handle mission action
                        // todo 성공 여부 판단 -> 성공 시 광고 재생 또는 광고 시청 후 포인트 지급
                        // * 정답 여부 확인 후, 팝업 창 띄우기
                        // * 팝업 창에서 광고시청 버튼 클릭 후 광고 페이지 또는 광고 페이지로 이동
                        // final isCorrect = true; // 예시로 true로 설정
                        // if (isCorrect) {
                        //   // 광고 시청 후 포인트 지급
                        //   CommonDialog(
                        //     title: "광고",
                        //     content: "광고",
                        //     confirmText: "광고 시청하기",
                        //     cancelText: "취소",
                        //     onConfirm: () {
                        //       Navigator.pushNamed(context, AdPage.routeName);
                        //     },
                        //     onCancel:
                        //         () => {
                        //           //
                        //         },
                        //   );
                        // } else {
                        //   // 정답이 아닐 경우 처리
                        //   hintSentence = '정답이 아닙니다. 다시 시도해주세요.';
                        // }
                      },
                      child: const Text('입력 완료'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '미션 도전 종료까지 남은 시간',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    const Text('00:34:11', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // ! 앱 푸시 알람 설정 섹션
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            color: Colors.blue[100],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '타이핑 미션 알림',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Switch(
                      value: true,
                      onChanged: (value) {
                        // Handle switch change
                      },
                    ),
                  ],
                ),
                const Text(
                  '매 시 정각에 새로운 받아쓰기 문장이 열릴 때 알려드릴게요',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
