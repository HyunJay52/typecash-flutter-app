import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:typecash_flutter_app/apis/typecash_apis.dart';

class AdProvider with ChangeNotifier {
  // 광고 관련 상태를 관리하는 프로바이더
  InterstitialAd? _interstitialAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;

  bool _isAdLoaded = false;
  int _rewardPoints = 0;

  bool get isAdLoaded => _isAdLoaded;
  int get rewardPoints => _rewardPoints;

  // AdProvider 클래스에 변수 추가
  DateTime _adStartTime = DateTime.now();
  bool _wasAdWatchedLongEnough = false;

  // Getter 추가
  bool get wasAdWatchedLongEnough => _wasAdWatchedLongEnough;

  Future<void> loadRewardedInterstitialAd() async {
    if (_isAdLoaded) {
      debugPrint('Ad is already loaded. Skip loading.');
      return;
    }
    try {
      debugPrint('Loading Rewarded Interstitial Ad...');
      await RewardedInterstitialAd.load(
        adUnitId: _getInterstitialAdUnitId(),
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            debugPrint('Rewarded Interstitial Ad loaded successfully');
            _rewardedInterstitialAd = ad;
            _isAdLoaded = true;

            // * 광고 이벤트 리스너 설정
            _rewardedInterstitialAd!
                .fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (RewardedInterstitialAd ad) {
                // 광고가 화면에 표시되었을 때
                debugPrint(
                  'Rewarded Interstitial Ad showed full screen content',
                );
                _adStartTime = DateTime.now(); // 광고 시작 시간 기록
              },
              onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
                debugPrint('Rewarded Interstitial Ad dismissed');
                debugPrint(
                  'Rewarded Interstitial AD info : ${ad.responseInfo}',
                );
                // 광고가 닫혔을 때
                _isAdLoaded = false;
                final adDuration = DateTime.now().difference(_adStartTime);
                if (adDuration.inSeconds >= 10) {
                  _wasAdWatchedLongEnough = true; // 광고를 충분히 시청했는지 여부
                  _addReward(3); // 광고 시청 후 보상 포인트 추가
                } else {
                  _wasAdWatchedLongEnough = false; // 광고를 충분히 시청하지 않았음
                  debugPrint(
                    'Ad was not watched long enough: ${adDuration.inSeconds} seconds',
                  );
                }
                _disposeRewardedAd();
                loadRewardedInterstitialAd();
                notifyListeners();
              },
              onAdFailedToShowFullScreenContent: (
                RewardedInterstitialAd ad,
                AdError error,
              ) {
                debugPrint(
                  'Failed to show Rewarded Interstitial Ad: ${error.message}',
                );
                // 광고 표시 실패
                _disposeRewardedAd();
                _isAdLoaded = false;
                // loadRewardedInterstitialAd();
              },
            );

            notifyListeners();
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint(
              'Rewarded Interstitial Ad failed to load: ${error.code} - ${error.message}',
            );
            _isAdLoaded = false;
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

  // * 전면 광고용 함수
  Future<void> loadInterstitialAd() async {
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
              debugPrint('Interstitial AD info : ${ad.responseInfo}');
              // 광고가 닫혔을 때
              _isAdLoaded = false;
              final adDuration = DateTime.now().difference(_adStartTime);
              if (adDuration.inSeconds >= 10) {
                _wasAdWatchedLongEnough = true; // 광고를 충분히 시청했는지 여부
                _addReward(3); // 광고 시청 후 보상 포인트 추가
                _disposeAd(); // 광고 객체 해제
                loadInterstitialAd();
                notifyListeners();
              } else {
                _wasAdWatchedLongEnough = false; // 광고를 충분히 시청하지 않았음
                debugPrint(
                  'Ad was not watched long enough: ${adDuration.inSeconds} seconds',
                );
              }

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

  // * 보상형 전면 광고용 함수
  Future<void> showRewardedInterstitialAd() async {
    if (_isAdLoaded || _rewardedInterstitialAd == null) {
      debugPrint('Showing Rewarded Interstitial Ad - Ad is not loaded yet.');
      return;
    }

    _adStartTime = DateTime.now(); // 광고 시작 시간 기록
    _rewardedInterstitialAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        // 사용자가 보상을 받을 때 호출
        debugPrint('User earned reward: ${reward.amount}');
        _addReward(reward.amount.toInt());
      },
    );
    debugPrint('Showing Rewarded Interstitial Ad');
  }

  // * 전면 광고용 함수
  Future<void> showInterstitialAd() async {
    if (_isAdLoaded && _interstitialAd == null) {
      debugPrint('Showing Interstitial Ad');
      // print('Interstitial Ad is not loaded yet.');
    }

    _adStartTime = DateTime.now(); // 광고 시작 시간 기록
    await _interstitialAd!.show();
  }

  void _addReward(int points) {
    _rewardPoints += points;
    notifyListeners();
  }

  // * 보상형 전면 광고 객체 해제 함수
  void _disposeRewardedAd() {
    _rewardedInterstitialAd?.dispose();
    _rewardedInterstitialAd = null;
    _isAdLoaded = false;
    notifyListeners();
  }

  // * 전면 광고 객체 해제 함수
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
      // * 전면 광고 테스트 : ca-app-pub-3940256099942544/1033173712
      // * 보상형 전면 광고 테스트 : ca-app-pub-3940256099942544/5354046379
      return 'ca-app-pub-3940256099942544/5354046379';
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

  Future<void> callServerApiTest() async {
    // 서버 API 호출 테스트용 메서드
    final response = await TypecashApis().apiTestByUser();
    debugPrint('API TEST called');
    debugPrint('Response: ${response.data}');
  }
}
