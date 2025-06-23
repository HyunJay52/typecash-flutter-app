import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/providers/ad_provider.dart';

class AdPage extends StatefulWidget {
  static const routeName = '/ad';
  const AdPage({super.key});

  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  bool _isRewarded = false;
  bool _canClose = false;
  int _remainingTime = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // 로그 메시지 추가
    debugPrint('AdPage initialized');

    // 첫 렌더링 후 실행되는 비동기 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('Post frame callback - loading ad');
      final adProvider = Provider.of<AdProvider>(context, listen: false);

      // 광고 로드 전 상태 리스너 추가
      adProvider.addListener(_checkAdStatus);

      // await adProvider.loadInterstitialAd();
      await adProvider.loadRewardedInterstitialAd();

      // if (adProvider.isAdLoaded) {
      //   debugPrint('Ad loaded successfully, showing ad');
      //   await adProvider.showRewardedInterstitialAd();
      //   setState(() => _isRewarded = true);
      //   _startTimer();

      //   await adProvider.callServerApiTest();
      // } else {
      //   debugPrint('Ad failed to load');
      //   // 광고가 로드되지 않은 경우 사용자에게 알림
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('광고를 불러오지 못했습니다.'),
      //       duration: Duration(seconds: 2),
      //     ),
      //   );
      // }
    });
  }

  void _checkAdStatus() {
    final adProvider = Provider.of<AdProvider>(context, listen: false);

    if (adProvider.isAdLoaded && !_isRewarded) {
      debugPrint('Ad is loaded, showing ad');
      adProvider.showRewardedInterstitialAd();
      _startTimer();
      // 광고 상태에 따른 UI 업데이트
      setState(() {
        _isRewarded = true;  // adProvider.wasAdWatchedLongEnough;
      });
    } else if (!adProvider.isAdLoaded && !_isRewarded) {
      debugPrint('Ad is not loaded yet, waiting...');
    }

    // 광고 상태에 따른 UI 업데이트
    // setState(() {
    //   _isRewarded = adProvider.wasAdWatchedLongEnough;
    // });

    if (!adProvider.isAdLoaded && _isRewarded) {
      // 광고가 닫히고 보상을 받은 경우
      debugPrint('Ad closed and reward earned');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _canClose = true;
          _timer?.cancel();

          // 타이머가 완료되면 자동으로 리워드 다이얼로그 표시
          // _showRewardDialog();
        }
      });
    });
  }

  // * dialog 표시 함수
  void _showRewardDialog() {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('광고'),
        automaticallyImplyLeading: false,
        actions: [
          // 타이머 표시 및 닫기 버튼
          TextButton(
            onPressed: _canClose ? () => Navigator.of(context).pop() : null,
            child: Text(
              _canClose ? '닫기' : '$_remainingTime초',
              style: TextStyle(
                color: _canClose ? Colors.blue : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Consumer<AdProvider>(
          builder: (context, adProvider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!adProvider.isAdLoaded && !_isRewarded) ...[
                  // 광고 로딩 중 표시
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  const Text('광고를 로딩하고 있습니다...'),
                ] else if (!_isRewarded) ...[
                  // 광고 로드 완료 상태 표시
                  const Icon(
                    Icons.ondemand_video,
                    size: 70,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  const Text('광고가 곧 표시됩니다.'),
                ] else ...[
                  // 광고 시청 후 상태 표시
                  Image.asset('assets/images/congrat.png', height: 100),
                  const SizedBox(height: 20),
                  const Text(
                    '광고 시청이 완료되었습니다!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _canClose
                        ? '포인트가 적립되었습니다.'
                        : '$_remainingTime초 후에 포인트가 적립됩니다.',
                    style: TextStyle(
                      fontSize: 16,
                      color: _canClose ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
