enum LoginPlatform {
  naver,
  google;

  static LoginPlatform fromServerValue(String value) {
    switch (value) {
      case 'naver':
        return LoginPlatform.naver;
      case 'google':
        return LoginPlatform.google;
      default:
        throw Exception('Invalid LoginPlatform value: $value');
    }
  }
}