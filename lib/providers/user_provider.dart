import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _email;
  String? _password;
  String? _confirmPassword;
  int _userId = 0;
  int _rewardBalance = 0;

  int get userId => _userId;
  String? get email => _email;
  String? get password => _password;
  String? get confirmPassword => _confirmPassword;
  int get rewardBalance => _rewardBalance;

  // ? 회원가입 프로바이더로 넘김
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    notifyListeners();
  }

  // * 유저 정보
  void setUserInfo({int? userId = 0, String? email, int? rewardBalance = 0}) {
    if (userId != null) _userId = userId;
    if (email != null) _email = email;
    if (rewardBalance != null) _rewardBalance = rewardBalance;

    notifyListeners();
    _saveUserInfoToLocal(); // 로컬 저장소에 저장
  }

  // 사용자 정보 초기화 (로그아웃 시 호출)
  void clearUserInfo() async {
    _email = null;
    _userId = 0;
    _rewardBalance = 0;
    notifyListeners();

    // 로컬 저장소에서도 삭제
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    prefs.remove('email');
    prefs.remove('rewardBalance');
  }

  // 로컬 저장소에 사용자 정보 저장 (선택 사항)
  Future<void> _saveUserInfoToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', _userId);
    if (_email != null) prefs.setString('email', _email!);
    prefs.setInt('rewardBalance', _rewardBalance);
  }

  // 로컬 저장소에서 사용자 정보 불러오기 (앱 시작 시)
  Future<void> loadUserInfoFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('id') ?? 0;
    _email = prefs.getString('email');
    _rewardBalance = prefs.getInt('rewardBalance') ?? 0;
    notifyListeners();
  }

  // 사용자 프로필 정보 불러오기 (API 호출)
  Future<void> fetchUserProfile() async {
    // API 호출로 사용자 정보 가져오기
    // final response = await TypecashApis().getUserProfile(accessToken);
    // setUserInfo(
    //   email: response.data['email'],
    //   nickname: response.data['nickname'],
    //   profileImage: response.data['profileImage'],
    //   point: response.data['point'],
    // );
  }
}
