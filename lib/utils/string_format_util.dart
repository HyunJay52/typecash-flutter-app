class StringFormatUtil {
  static bool isValidEmailFormat(String? value) {
    if (value == null || value.isEmpty) return false;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(value);
  }

  static bool isValidPasswordFormat(String? value) {
    if (value == null || value.isEmpty) return false;
    final passwordRegex = RegExp(r'^(?=.*[0-9])(?=.*[@!*_-]).{8,}$');
    return passwordRegex.hasMatch(value);
  }

  static bool areStringsEqual(String? value1, String? value2) {
    if (value1 == null || value2 == null) {
      return false;
    } else {
      // * 0 means equal
      // * 1 means value1 > value2
      // * -1 means value1 < value2
      return value1.compareTo(value2) == 0;
    }
  }
}
