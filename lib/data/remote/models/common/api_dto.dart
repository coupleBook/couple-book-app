import 'error_response.dart';

class ApiResponse {
  String status;
  ErrorResponse? error;

  ApiResponse({
    required this.status,
    required this.error
  });
}