import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdProvider with ChangeNotifier {
  // 광고 관련 상태를 관리하는 프로바이더
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  int _rewardPoints = 0;

  bool get isAdLoaded => _isAdLoaded;
  int get rewardPoints => _rewardPoints;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _getInterstitialAdUnitId(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;

          // * 광고 이벤트 리스너 설정
          _interstitialAd!
              .fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (InterstitialAd ad) {
              // 광고가 화면에 표시되었을 때
            },
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              // 광고가 닫혔을 때
              _isAdLoaded = false;
              _addReward(3); // 광고 시청 후 보상 포인트 추가
              _disposeAd(); // 광고 객체 해제
              loadInterstitialAd();
              debugPrint('Interstitial Ad dismissed : $rewardPoints');
              // todo : 광고가 닫힌 후, 다음 광고를 로드합니다. 보상 포인트 내역을 서버로 전송하는 로직을 추가
              
            },
            onAdFailedToShowFullScreenContent: (
              InterstitialAd ad,
              AdError error,
            ) {
              // 광고 표시 실패
              _disposeAd();
              _isAdLoaded = false;
              loadInterstitialAd();
            },
          );

          notifyListeners();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Interstitial Ad failed to load: $error');
          _isAdLoaded = false;
          notifyListeners();
        },
      ),
    );
  }

  Future<void> showInterstitialAd() async {
    if (_isAdLoaded && _interstitialAd == null) {
      debugPrint('Showing Interstitial Ad');
      // print('Interstitial Ad is not loaded yet.');
    }

    await _interstitialAd!.show();
  }

  void _addReward(int points) {
    _rewardPoints += points;
    notifyListeners();
  }

  void _disposeAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isAdLoaded = false;
    notifyListeners();
  }

  // 광고 ID 가져오기 (개발/프로덕션 환경 구분)
  String _getInterstitialAdUnitId() {
    if (kDebugMode) {
      // 테스트 광고 ID
      return 'ca-app-pub-3940256099942544/1033173712';
    } else {
      // 실제 광고 ID
      return '여기에_실제_광고_ID_입력';
    }
  }

  @override
  void dispose() {
    _disposeAd();
    super.dispose();
  }
}
