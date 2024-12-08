import 'package:logger/logger.dart';
import 'package:couple_book/utils/security/auth_security.dart';

class TokenManager {
  final logger = Logger();

  /// ************************************************
  /// 액세스 토큰과 리프레시 토큰 저장
  /// ************************************************
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    // 'Bearer ' 제거 및 공백 제거
    String pureAccessToken = _cleanToken(accessToken);
    String pureRefreshToken = _cleanToken(refreshToken);

    // 토큰 저장
    await setAccessToken(pureAccessToken);
    await setRefreshToken(pureRefreshToken);

    // 저장된 토큰 확인
    final savedAccessToken = await getAccessToken();
    final savedRefreshToken = await getRefreshToken();

    if (savedAccessToken != pureAccessToken || savedRefreshToken != pureRefreshToken) {
      throw Exception("토큰 저장 실패");
    }

    logger.d("액세스 토큰과 리프레시 토큰이 성공적으로 저장되었습니다.");
  }

  /// ************************************************
  /// 내부 함수: 토큰 클리닝
  /// ************************************************
  String _cleanToken(String token) {
    return token.replaceFirst('Bearer ', '').replaceAll(' ', '');
  }
}
