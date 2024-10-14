import 'package:couple_book/dto/response_dto/couple_info_response_dto.dart';
import 'package:couple_book/dto/response_dto/create_couple_code_response_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import '../../api/couple_api/couple_api.dart';
import '../../dto/response_dto/couple_code_creator_info_response.dart'; // FindUserInfoResponse 클래스 임포트

class CoupleController {
  final BuildContext context;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final Logger logger = Logger();
  final coupleApi = CoupleApi();

  CoupleController(this.context);

  // 커플 연동 코드 생성
  Future<CreateCoupleCodeResponseDto?> generateCoupleLinkCode() async {
    try {
      final response = await coupleApi.createCoupleCode('2021-10-10');
      logger.d('커플 연동 코드 생성 성공: $response');
      _showSnackBar('커플 연동 코드가 생성되었습니다.');
      return response;
    } catch (e) {
      logger.e('커플 연동 코드 생성 실패: $e');
      _showSnackBar('커플 연동 코드 생성 실패: $e');
      return Future.value(null);
    }
  }

  // 커플 연동 코드 조회 (입력된 코드 사용)
  Future<void> getCoupleLinkCode(String code) async {
    try {
      final response = await coupleApi.findUserInfoByCode(code);
      logger.d('커플 연동 코드 조회 성공: $response');

      // 조회된 데이터를 팝업 창으로 보여줌
      _showPopup(response);
    } catch (e) {
      logger.e('커플 연동 코드 조회 실패: $e');
      _showSnackBar('커플 연동 코드 조회 실패: $e');
    }
  }

  // 커플 연동하기 (입력된 코드 사용)
  Future<CoupleInfoResponse?> coupleLink(String code) async {
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

  // 팝업 창으로 데이터를 보여주는 함수
  void _showPopup(CoupleCodeCreatorInfoResponse userInfo) {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // 바깥 클릭 시 닫기 허용
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('커플 연동 코드 조회 결과'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('코드: ${userInfo.code}'),
                const SizedBox(height: 10),
                Text('이름: ${userInfo.username}'),
                if (userInfo.birthday != null) ...[
                  const SizedBox(height: 10),
                  Text('생일: ${userInfo.birthday}'),
                ],
                if (userInfo.gender != null) ...[
                  const SizedBox(height: 10),
                  Text('성별: ${userInfo.gender}'),
                ],
                const SizedBox(height: 10),
                Text('기념일: ${userInfo.datingAnniversary}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 창 닫기
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
