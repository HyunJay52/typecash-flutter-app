import 'package:flutter/widgets.dart';
import 'package:typecash_flutter_app/apis/typecash_apis.dart';
import 'package:typecash_flutter_app/models/gift_type.dart';
import 'package:typecash_flutter_app/providers/user_provider.dart';

class RewardItem {
  final String name;
  final int points;
  final int value;
  final GiftType type;
  final String? imageAsset;

  RewardItem({
    required this.name,
    required this.points,
    required this.value,
    required this.type,
    // todo : present로 변경
    this.imageAsset = 'assets/images/reward.png',
  });
}

enum ExchangeStep { initial, phoneInput, completed }

class RewardProvider with ChangeNotifier {
  final TypecashApis _api = TypecashApis();

  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController phoneConfirmController = TextEditingController();

  // * 상태변수
  ExchangeStep _currentStep = ExchangeStep.initial;
  bool _isProcessing = false;
  String _phoneErrorMessage = '';
  bool _hasPhoneError = false;

  RewardItem? _selectedItem;
  String? _lastUsedPhone;

  // 리워드 상품 목록
  final List<RewardItem> _rewardItems = [
    RewardItem(name: '네이버 포인트', points: 10, value: 10, type: GiftType.naverPoint),
    RewardItem(name: '아마존 기프트 카드', points: 10000, value: 10000, type: GiftType.amazon),
    RewardItem(name: '스타벅스 기프트 카드', points: 5000, value: 5000, type: GiftType.starbucks),
  ];

  RewardProvider() {
    // * 마지막 입력 번호 로드

    // * 컨트롤러 변경 감지 리스너
    phoneController.addListener(_validateOnChange);
    phoneConfirmController.addListener(_validateOnChange);
  }

  // Getters
  ExchangeStep get currentStep => _currentStep;
  bool get isProcessing => _isProcessing;
  String get phoneErrorMessage => _phoneErrorMessage;
  bool get hasPhoneError => _hasPhoneError;
  RewardItem? get selectedItem => _selectedItem;
  String? get lastUsedPhone => _lastUsedPhone;
  List<RewardItem> get rewardItems => List.unmodifiable(_rewardItems);

  // Setters
  void setStep(ExchangeStep step) {
    _currentStep = step;
    notifyListeners();
  }

  // 리워드 아이템 선택
  void selectRewardItem(RewardItem item) {
    _selectedItem = item;
    _currentStep = ExchangeStep.initial;
    _hasPhoneError = false;
    _phoneErrorMessage = '';
    notifyListeners();
  }

  // 자동 유효성 검사 (컨트롤러 리스너)
  void _validateOnChange() {
    // 두 필드 모두 입력되었을 때만 검사
    if (phoneController.text.isNotEmpty &&
        phoneConfirmController.text.isNotEmpty) {
      validatePhoneNumber();
    }
  }

  // 전화번호 유효성 검사
  bool validatePhoneNumber() {
    final phone = phoneController.text.trim();
    final confirmPhone = phoneConfirmController.text.trim();

    if (phone.isEmpty || confirmPhone.isEmpty) {
      _hasPhoneError = true;
      _phoneErrorMessage = '휴대폰 번호를 입력해 주세요.';
      notifyListeners();
      return false;
    }

    if (phone != confirmPhone) {
      _hasPhoneError = true;
      _phoneErrorMessage = '휴대폰 번호가 일치하지 않습니다.';
      notifyListeners();
      return false;
    }

    // 휴대폰 번호 형식 확인
    final phonePattern = RegExp(r'^01[0-9]{8,9}$');
    if (!phonePattern.hasMatch(phone)) {
      _hasPhoneError = true;
      _phoneErrorMessage = '올바른 휴대폰 번호 형식이 아닙니다.';
      notifyListeners();
      return false;
    }

    _hasPhoneError = false;
    _phoneErrorMessage = '';
    notifyListeners();
    return true;
  }

  Future<bool> updateRewardAmount(int rewardAmount) async {
    try {
      final result = await _api.updateRewardAmount(amount: rewardAmount);
      
      // todo 유저 정보 업데이트 : rewardBalance
      
      return true;  
    } catch (e) {
      debugPrint('Error updating reward amount: $e');
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> processExchange(UserProvider userProvider) async {
    if (_selectedItem == null) return false;

    _isProcessing = true;
    notifyListeners();

    try {
      // 여기서 실제 교환 API 호출을 수행합니다.
      final phoneNumber = phoneController.text.trim();
      final giftCardId = giftTypeToString(_selectedItem!.type);

      // * response example
      // {
      //   "userId": 10000,
      //   "amount": -10,
      //   "balanceAfter": 130
      // }
      final result = await _api.redeemPoints(
        giftCardId: giftCardId,
        pointsToUse: _selectedItem!.points,
        phoneNumber: phoneNumber,
      );
      // 예시로 1초 대기
      await Future.delayed(const Duration(seconds: 2));

      // 교환 성공 후 전화번호 저장
      _lastUsedPhone = phoneNumber;

      // 교환 완료 상태로 변경
      _currentStep = ExchangeStep.completed;

      // 포인트 차감 처리
      // ? 갱신된 유저 정보로 처리하는게 맞을까?
      // ? redeemPoints response에 갱신된 포인트 정보가 오면 그걸로 처리?
      if (userProvider.rewardBalance >= _selectedItem!.points) {
        final newBalance = userProvider.rewardBalance - _selectedItem!.points;
        userProvider.setUserInfo(
          rewardBalance: newBalance > 0 ? newBalance : 0,
        );
      }
      debugPrint(
        '포인트 교환 처리: ${_selectedItem!.name}, ${_selectedItem!.points} 포인트, $_lastUsedPhone',
      );
    } catch (e) {
      // 오류 처리s
      _hasPhoneError = true;
      _phoneErrorMessage = '교환 처리 중 오류가 발생했습니다.';
    } finally {
      _isProcessing = false;
      notifyListeners();
    }

    return true;
  }

  // 교환 완료 후 초기화
  void resetAfterExchange() {
    _currentStep = ExchangeStep.initial;
    _selectedItem = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // 컨트롤러 리스너 제거
    phoneController.removeListener(_validateOnChange);
    phoneConfirmController.removeListener(_validateOnChange);

    // 컨트롤러 dispose
    phoneController.dispose();
    phoneConfirmController.dispose();

    super.dispose();
  }
}
