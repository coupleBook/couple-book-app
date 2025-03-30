import 'dart:io';
import 'package:couple_book/data/remote/datasources/user_api/profile_image_modification_response_dto.dart';
import 'package:couple_book/domain/repositories/user_profile_repository.dart';

class UpdateUserProfileImageUseCase {
  final UserProfileRepository _repository;

  UpdateUserProfileImageUseCase(this._repository);

  Future<ProfileImageModificationResponseDto> execute(File imageFile) {
    return _repository.updateProfileImage(imageFile);
  }
} 