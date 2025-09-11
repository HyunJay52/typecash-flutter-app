import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdProvider with ChangeNotifier {
  // 광고 관련 상태를 관리하는 프로바이더
  RewardedInterstitialAd? _rewardedInterstitialAd;

  bool _isAdLoaded = false;
  int _rewardPoints = 0;

  bool get isAdLoaded => _isAdLoaded;
  int get rewardPoints => _rewardPoints;

  Future<void> loadRewardedInterstitialAd() async {
    try {
      debugPrint('Loading Rewarded Interstitial Ad...');
      await RewardedInterstitialAd.load(
        adUnitId: _getInterstitialAdUnitId(),
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            String adUnitId = _getInterstitialAdUnitId();
            debugPrint('Rewarded Interstitial Ad loaded successfully: $adUnitId');
            _rewardedInterstitialAd = ad;
            _isAdLoaded = true;

            setAdEventListeners(ad); // 광고 이벤트 리스너 설정

            notifyListeners();
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint(
              'Rewarded Interstitial Ad failed to load: ${error.code} - ${error.message}',
            );
            _isAdLoaded = false;
            _rewardedInterstitialAd = null; // 광고 객체를 null로 설정
            notifyListeners();
          },
        ),
      );
    } catch (e) {
      debugPrint('Error loading Rewarded Interstitial Ad: $e');
      _isAdLoaded = false;
      notifyListeners();
    }
  }

  void setAdEventListeners(RewardedInterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) {
        debugPrint('Ad showed full screen content');
        debugPrint('Ad Information: ${ad.responseInfo}');
      },
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        debugPrint('Ad dismissed');
        ad.dispose(); // 광고가 닫혔을 때 객체 해제
        _rewardedInterstitialAd = null; // 광고 객체를 null로 설정
        _isAdLoaded = false; // 광고가 닫혔으므로 로드 상태를 false로 설정
        notifyListeners();
      },
      onAdFailedToShowFullScreenContent: (
        RewardedInterstitialAd ad,
        AdError error,
      ) {
        debugPrint('Failed to show ad: ${error.message}');
        ad.dispose(); // 광고 표시 실패 시 객체 해제
        _rewardedInterstitialAd = null; // 광고 객체를 null로 설정
        _isAdLoaded = false; // 광고가 닫혔으므로 로드 상태를 false로 설정
        notifyListeners();
      },
    );
  }

  // * 보상형 전면 광고용 함수
  Future<int> showRewardedInterstitialAd() async {
    debugPrint(
      'Attempting to show ad. isLoaded: $_isAdLoaded, ad: ${_rewardedInterstitialAd != null}',
    );

    if (!_isAdLoaded || _rewardedInterstitialAd == null) {
      debugPrint('Showing Rewarded Interstitial Ad - Ad is not loaded yet.');
      return 0;
    }

    debugPrint('Showing Rewarded Interstitial Ad');

    int rewardAmount = 0;
    _rewardedInterstitialAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        // 사용자가 보상을 받을 때 호출
        debugPrint('User earned reward: ${reward.amount} ${reward.type}');
        _addReward((reward.amount.toInt()*0.5).toInt()); // 보상 포인트 추가
        rewardAmount = reward.amount.toInt();
      },
    );
    return rewardAmount;
  }

  void _addReward(int points) {
    _rewardPoints += points;
    notifyListeners();
  }

  // * 전면 광고 객체 해제 함수
  void _disposeAd() {
    _isAdLoaded = false;
    notifyListeners();
  }

  // 광고 ID 가져오기 (개발/프로덕션 환경 구분)
  String _getInterstitialAdUnitId() {
    debugPrint('Getting Interstitial Ad Unit ID... $kDebugMode');
    if (kDebugMode) {
      // 테스트 광고 ID
      // * 전면 광고 테스트 : ca-app-pub-3940256099942544/1033173712
      // * 보상형 전면 광고 테스트 : ca-app-pub-3940256099942544/5354046379
      return 'ca-app-pub-3940256099942544/5354046379';
    } else {
      // 실제 광고 ID
      return 'ca-app-pub-4617098911306047/9622012563';
    }
  }

  @override
  void dispose() {
    _disposeAd();
    super.dispose();
  }
}
