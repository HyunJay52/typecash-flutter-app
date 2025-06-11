import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/ad_provider.dart';

class AdPage extends StatefulWidget {
  static const routeName = '/ad';
  const AdPage({super.key});

  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  bool _isRewarded = false;

  @override
  void initState() {
    super.initState();

    // 첫 렌더링 후 실행되는 비동기 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdProvider>(context, listen: false).loadInterstitialAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('광고')),
      body: Center(
        child:  Consumer<AdProvider>(builder: (context, adProvider, child) {
          return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('여기에 애드몹 광고 페이지 📺'),
            const SizedBox(height: 20),
            if (!_isRewarded) ...[
                  ElevatedButton(
                    onPressed: adProvider.isAdLoaded
                        ? () async {
                            await adProvider.showInterstitialAd();
                            setState(() => _isRewarded = true);
                          }
                        : null,
                    child: Text(
                      adProvider.isAdLoaded
                          ? '광고 시청하기'
                          : '광고 로딩 중...'
                    ),
                  ),
                ],
            // ElevatedButton(
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return AlertDialog(
            //           title: const Text('리워드 적립 🪙'),
            //           content: const Text('3포인트의 리워드가 적립되었습니다'),
            //           actions: [
            //             TextButton(
            //               onPressed: () {
            //                 Navigator.of(context).pop(); // Close the dialog
            //                 Navigator.of(context).pop(); // Navigate back
            //               },
            //               child: const Text('확인'),
            //             ),
            //           ],
            //         );
            //       },
            //     );
            //   },
            //   child: const Text('리워드 받기'),
            // ),
          ],
        );
        },)
      ),
    );
  }
}
