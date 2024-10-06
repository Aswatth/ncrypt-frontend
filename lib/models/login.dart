import 'attributes.dart';
import 'login_account.dart';

class LoginData {
  late String name;
  late String url;
  late Attributes attributes;
  late List<Account> accounts;

  LoginData(
      {required this.name,
      required this.url,
      required this.attributes,
      required this.accounts});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    List<dynamic> accountsJson = json['accounts'];

    // Convert List<dynamic> to List<Account>
    List<Account> accounts = accountsJson
        .map((m) => Account.fromJson(m))
        .toList();

    return LoginData(
        name: json['name'],
        url: json['url'],
        attributes: Attributes.fromJson(json['attributes']),
        accounts: accounts);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        'attributes': attributes.toJson(),
        'accounts': accounts.map((account) => account.toJson()).toList(),
      };
}
