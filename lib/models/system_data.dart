class SystemData {
  late int loginCount;
  late String lastLoginDateTime;
  late bool isLoggedIn;
  late String currentLoginDateTime;
  late bool automaticBackup;
  late String automaticBackupLocation;
  late String backupFileName;
  late int sessionTimeInMinutes;

  SystemData(
      {required this.loginCount,
      required this.lastLoginDateTime,
      required this.isLoggedIn,
      required this.currentLoginDateTime,
      required this.automaticBackup,
      required this.automaticBackupLocation,
      required this.backupFileName,
      required this.sessionTimeInMinutes});

  factory SystemData.fromJson(Map<String, dynamic> json) {
    return SystemData(
        loginCount: json['login_count'],
        lastLoginDateTime: json['last_login'],
        isLoggedIn: json['is_logged_in'],
        currentLoginDateTime: json['current_login_date_time'],
        automaticBackup: json['automatic_backup'] == "true",
        automaticBackupLocation: json['automatic_backup_location'],
        backupFileName: json['backup_file_name'],
        sessionTimeInMinutes: json['session_time_in_minutes']);
  }

  @override
  String toString() {
    return 'SystemData{loginCount: $loginCount, lastLoginDateTime: $lastLoginDateTime, isLoggedIn: $isLoggedIn, currentLoginDateTime: $currentLoginDateTime, automaticBackup: $automaticBackup, automaticBackupLocation: $automaticBackupLocation, backupFileName: $backupFileName, sessionTimeInMinutes: $sessionTimeInMinutes}';
  }
}
