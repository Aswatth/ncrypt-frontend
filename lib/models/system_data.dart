import 'package:Ncrypt/models/auto_backup_setting.dart';

class SystemData {
  late int loginCount;
  late String lastLoginDateTime;
  late bool isLoggedIn;
  late String currentLoginDateTime;
  late AutoBackupSetting autoBackupSetting;
  late int sessionDurationInMinutes;
  late String theme;

  SystemData(
      {required this.loginCount,
      required this.lastLoginDateTime,
      required this.isLoggedIn,
      required this.currentLoginDateTime,
      required this.autoBackupSetting,
      required this.sessionDurationInMinutes,
      required this.theme});

  factory SystemData.fromJson(Map<String, dynamic> json) {
    return SystemData(
        loginCount: json['login_count'],
        lastLoginDateTime: json['last_login'],
        isLoggedIn: json['is_logged_in'],
        currentLoginDateTime: json['current_login_date_time'],
        autoBackupSetting:
            AutoBackupSetting.fromJson(json['auto_backup_setting']),
        sessionDurationInMinutes: json['session_duration_in_minutes'],
        theme: json['theme']);
  }

  @override
  String toString() {
    return 'SystemData{loginCount: $loginCount, lastLoginDateTime: $lastLoginDateTime, isLoggedIn: $isLoggedIn, currentLoginDateTime: $currentLoginDateTime, autoBackupSetting: $autoBackupSetting, sessionDurationInMinutes: $sessionDurationInMinutes, theme: $theme}';
  }
}
