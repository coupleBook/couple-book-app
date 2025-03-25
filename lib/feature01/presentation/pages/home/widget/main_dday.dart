import 'dart:io';

import 'package:couple_book/core/l10n/l10n.dart';
import 'package:couple_book/data/local/entities/enums/gender_enum.dart';
import 'package:couple_book/feature01/presentation/viewmodels/dday_provider.dart';
import 'package:couple_book/feature01/presentation/viewmodels/dday_state.dart';
import 'package:couple_book/gen/assets.gen.dart';
import 'package:couple_book/gen/colors.gen.dart';
import 'package:couple_book/feature01/presentation/pages/home/widget/permission_handler_widget.dart';
import 'package:couple_book/pages/home/widget/profile_popup.dart';
import 'package:couple_book/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MainDdayView extends ConsumerWidget {
  const MainDdayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ddayState = ref.watch(ddayProvider);
    final ddayNotifier = ref.read(ddayProvider.notifier);
    final todayDate = DateFormat('yy/MM/dd/EEEE', 'ko_KR').format(DateTime.now());

    return Container(
      color: ColorName.backgroundColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PermissionHandlerWidget(
            onPermissionGranted: () {},
            appName: l10n.appName,
            callLocation: 'HOME',
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: AppText(todayDate, style: TypoStyle.notoSansR19_1_4),
          ),
          const SizedBox(height: 2.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.icons.heartContent.svg(width: 43, height: 33),
                const SizedBox(width: 4.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(ddayState.dday, style: TypoStyle.seoyunB32_1_5),
                    const SizedBox(width: 4.0),
                    const AppText('일째', style: TypoStyle.seoyunB32_1_5),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Assets.icons.bookIcon.svg(width: 12, height: 11),
                const SizedBox(width: 4.0),
                AppText(
                  '처음 만난 날: ${ddayState.anniversaryDate}',
                  style: TypoStyle.notoSansR19_1_4.copyWith(fontSize: 12),
                  color: ColorName.defaultGray,
                ),
              ],
            ),
          ),
          const SizedBox(height: 70.0),
          _buildProfileSection(context, ddayState, ddayNotifier),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, DdayState ddayState, DdayNotifier ddayNotifier) {
    final myGender = ddayState.leftProfileGender ?? Gender.male;
    return Center(
      child: Container(
        width: 320,
        height: 240,
        decoration: BoxDecoration(
          color: ColorName.backgroundColor,
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildProfileButton(
                    context, ddayState.leftProfileName, ddayState.leftProfileBirthdate, ddayState.leftProfileImage, myGender.isMale(), ddayNotifier),
                const SizedBox(width: 20.0),
                Assets.icons.miniHeartContent.svg(width: 12, height: 12),
                const SizedBox(width: 20.0),
                _buildProfileButton(context, ddayState.rightProfileName, ddayState.rightProfileBirthdate, ddayState.rightProfileImage,
                    !myGender.isMale(), ddayNotifier),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, String name, String? birthdate, File? profileImage, bool isMale, DdayNotifier ddayNotifier) {
    return GestureDetector(
      onTap: () async {
        var result = await showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.86,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: ProfilePopupForm(
                  name: name,
                  birthdate: birthdate ?? "생일 없음",
                  gender: isMale ? Gender.male : Gender.female,
                  selectedImage: profileImage,
                ),
              ),
            );
          },
        );
        if (result != null) {
          ddayNotifier.updateProfile(result);
        }
      },
      child: _buildProfileColumn(name, birthdate ?? "생일 없음", profileImage, isMale),
    );
  }

  Widget _buildProfileColumn(String name, String birthdate, File? profileImage, bool isMale) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: profileImage != null ? FileImage(profileImage) : null,
          backgroundColor: Colors.transparent,
          child: profileImage == null
              ? (isMale ? Assets.icons.profileMaleContent.svg(width: 80, height: 80) : Assets.icons.profileFemaleContent.svg(width: 80, height: 80))
              : null,
        ),
        const SizedBox(height: 8.0),
        Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(birthdate, style: const TextStyle(fontSize: 10, color: ColorName.defaultGray)),
      ],
    );
  }
}
