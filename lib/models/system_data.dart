class SystemData {
  late int loginCount;
  late String lastLogin;
  SystemData({required this.loginCount,  required this.lastLogin});

  factory SystemData.fromJson(Map<String, dynamic> json) {
    return SystemData(
      loginCount: json['login_count'],
      lastLogin: json['last_login']
    );
  }
}