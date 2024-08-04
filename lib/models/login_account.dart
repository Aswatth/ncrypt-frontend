class Account {
  String? username;
  String? password;

  Account({required this.username, required this.password});

  Account.empty();

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
        username: json['username'],
        password: json['password']);
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}
