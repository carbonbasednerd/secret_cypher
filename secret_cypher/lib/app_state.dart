class AppState {
  static final AppState _appState = AppState._internal();

  String userId;

  factory AppState() {
    return _appState;
  }

  AppState._internal();
}