import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  String? _email;
  String? _password;
  String? _confirmPassword;
  bool _agreeToTerms = false;
  bool _agreeToPrivacy = false;

  String? get email => _email;
  String? get password => _password;
  String? get confirmPassword => _confirmPassword;
  bool get agreeToTerms => _agreeToTerms;
  bool get agreeToPrivacy => _agreeToPrivacy;

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

  void toggleAgreeToTerms() {
    _agreeToTerms = !_agreeToTerms;
    notifyListeners();
  }

  void toggleAgreeToPrivacy() {
    _agreeToPrivacy = !_agreeToPrivacy;
    notifyListeners();
  }
}