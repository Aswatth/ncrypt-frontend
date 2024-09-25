import 'dart:async';

class SessionTimer {
  int _currentTimeInSeconds = 0;
  int _sessionTimeInSeconds = 0;
  final int _countDownSeconds = 1;

  late Timer _timer;
  late void Function() tickCallback;
  late void Function() timerEndCallback;

  static final SessionTimer _instance = SessionTimer._internal();

  SessionTimer._internal();

  factory SessionTimer() {
    return _instance;
  }

  void start() {
    _instance._timer =
        Timer.periodic(Duration(seconds: _instance._countDownSeconds), (timer) {
      _currentTimeInSeconds -= _countDownSeconds;
      tickCallback.call();
      if (_currentTimeInSeconds <= 0) {
        _timer.cancel();
        timerEndCallback();
      }
    });
  }

  void reset() {
    _currentTimeInSeconds = _sessionTimeInSeconds;
    _timer.cancel();
  }

  int getCurrentTimeInSeconds() {
    return _currentTimeInSeconds;
  }

  int getSessionTimeInSeconds() {
    return _sessionTimeInSeconds;
  }

  void setSessionTimeInMinutes(int minutes) {
    _sessionTimeInSeconds = minutes * 60;
    _currentTimeInSeconds = _sessionTimeInSeconds;
    tickCallback.call();
  }
}
