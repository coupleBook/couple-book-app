import 'package:couple_book/data/local/local_user_local_data_source.dart';
import 'package:couple_book/api/couple_api/couple_linking_response_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import '../../api/couple_api/couple_api.dart';

class CoupleController {
  final BuildContext context;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final Logger logger = Logger();
  final coupleApi = CoupleApi();
  final LocalUserLocalDataSource localUserLocalDataSource =
      LocalUserLocalDataSource.instance;

  CoupleController(this.context);

  // 커플 연동하기 (입력된 코드 사용)
  Future<CoupleLinkingResponseDto?> coupleLink(String code) async {
    try {
      final response = await coupleApi.linkCouple(code);
      logger.d('커플 연동 성공: $response');
      _showSnackBar('커플 연동에 성공했습니다.');
      return response;
    } catch (e) {
      logger.e('커플 연동 실패: $e');
      _showSnackBar('커플 연동 실패: $e');
      return Future.value(null);
    }
  }

  // SnackBar 표시 함수
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
