import 'dart:io';
import 'package:couple_book/data/remote/datasources/user_api/profile_image_modification_response_dto.dart';

abstract class UserProfileRepository {
  Future<ProfileImageModificationResponseDto> updateProfileImage(File imageFile);
} 