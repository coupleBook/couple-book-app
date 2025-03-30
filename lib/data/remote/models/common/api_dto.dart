import 'error_dto.dart';

class ApiResponse {
  String status;
  ErrorDto? error;

  ApiResponse({
    required this.status,
    required this.error
  });
}