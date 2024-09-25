class AutoBackupSetting {
  late bool _isEnabled;
  late String _backupLocation;
  late String _backupFileName;

  AutoBackupSetting(
      bool isEnabled, String backupFolder, String backupFileName) {
    _isEnabled = isEnabled;
    _backupLocation = backupFolder;
    _backupFileName = backupFileName;
  }

  factory AutoBackupSetting.fromJson(Map<String, dynamic> json) {
    return AutoBackupSetting(
      json['is_enabled'],
      json['backup_location'],
      json['backup_file_name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'is_enabled': _isEnabled,
        'backup_location': _backupLocation,
        'backup_file_name': _backupFileName,
      };


  bool get isEnabled => _isEnabled;

  String get backupLocation => _backupLocation;

  String get backupFileName => _backupFileName;

  @override
  String toString() {
    return 'AutoBackupSetting{_isEnabled: $_isEnabled, _backupLocation: $_backupLocation, _backupFileName: $_backupFileName}';
  }
}
