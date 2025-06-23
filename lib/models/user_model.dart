class UserLogin {
  final String email;
  final String password;

  UserLogin({
    required this.email,
    required this.password,
  });
}

class User {
  final String email;
  final String password;
  final DateTime? createdAt;

  User({
    required this.email,
    required this.password,
    this.createdAt,
  });
}