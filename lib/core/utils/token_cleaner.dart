class TokenCleaner {
  /// 토큰에서 'Bearer ' 제거 및 모든 공백 제거
  static String cleanToken(String token) {
    return token.replaceFirst('Bearer ', '').replaceAll(' ', '');
  }
}
