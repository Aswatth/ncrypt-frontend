
import 'attribute.dart';
import 'login_account.go.dart';

class LoginData {
  late String name;
  late String url;
  late Attribute attribute;
  late List<Account> accounts;
  LoginData(this.name, this.url, this.attribute, this.accounts);
}