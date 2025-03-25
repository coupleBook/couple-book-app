import 'dart:io';

import 'package:couple_book/data/local/entities/enums/gender_enum.dart';

/// D-day 상태를 관리하는 모델
class DdayState {
  final String dday;
  final String anniversaryDate;
  final String leftProfileName;
  final String leftProfileBirthdate;
  final Gender? leftProfileGender;
  final File? leftProfileImage;
  final String rightProfileName;
  final String rightProfileBirthdate;
  final Gender? rightProfileGender;
  final File? rightProfileImage;

  DdayState({
    required this.dday,
    required this.anniversaryDate,
    required this.leftProfileName,
    required this.leftProfileBirthdate,
    this.leftProfileGender,
    this.leftProfileImage,
    required this.rightProfileName,
    required this.rightProfileBirthdate,
    this.rightProfileGender,
    this.rightProfileImage,
  });

  DdayState copyWith({
    String? dday,
    String? anniversaryDate,
    String? leftProfileName,
    String? leftProfileBirthdate,
    Gender? leftProfileGender,
    File? leftProfileImage,
    String? rightProfileName,
    String? rightProfileBirthdate,
    Gender? rightProfileGender,
    File? rightProfileImage,
  }) {
    return DdayState(
      dday: dday ?? this.dday,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      leftProfileName: leftProfileName ?? this.leftProfileName,
      leftProfileBirthdate: leftProfileBirthdate ?? this.leftProfileBirthdate,
      leftProfileGender: leftProfileGender ?? this.leftProfileGender,
      leftProfileImage: leftProfileImage ?? this.leftProfileImage,
      rightProfileName: rightProfileName ?? this.rightProfileName,
      rightProfileBirthdate: rightProfileBirthdate ?? this.rightProfileBirthdate,
      rightProfileGender: rightProfileGender ?? this.rightProfileGender,
      rightProfileImage: rightProfileImage ?? this.rightProfileImage,
    );
  }
}
