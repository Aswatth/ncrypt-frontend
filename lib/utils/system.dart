import 'dart:io';

class System {
  static final System _instance = System._internal();

  System._internal();

  late final int PORT;
  late final bool IsNewUser;

  factory System () {
    return _instance;
  }
}