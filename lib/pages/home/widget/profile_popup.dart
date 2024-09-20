import 'package:couple_book/gen/assets.gen.dart';
import 'package:couple_book/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // image_picker 패키지 추가
import 'dart:io'; // 파일 관련 작업을 위해 추가
import '../../../l10n/l10n.dart';
import '../../../style/text_style.dart';
import 'permission_handler_widget.dart'; // 권한 처리 위젯 추가

class ProfilePopupForm extends StatefulWidget {
  final String name;
  final String birthdate;
  final File? selectedImage; // 프로필 사진 필드 추가

  const ProfilePopupForm({
    super.key,
    required this.name,
    required this.birthdate,
    this.selectedImage, // 프로필 사진 필드 추가
  });

  @override
  _ProfilePopupFormState createState() => _ProfilePopupFormState();
}

class _ProfilePopupFormState extends State<ProfilePopupForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  String? nameError;
  String? birthdateError;

  File? _selectedImage; // 선택한 이미지를 저장할 변수
  final ImagePicker _picker = ImagePicker(); // ImagePicker 인스턴스 생성

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name; // 전달된 이름을 설정
    _birthdateController.text = widget.birthdate; // 전달된 생일을 설정
    _selectedImage = widget.selectedImage; // 전달된 프로필 사진 설정
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.86, // 팝업 높이 설정
      decoration: const BoxDecoration(
        color: Color(0xFFFFF7DF), // 배경색 설정
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), // 패딩 추가
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Assets.icons.closeIcon.svg(width: 16, height: 16), // 닫기 아이콘 추가
              ),
            ),
            const SizedBox(height: 16),
            _buildProfileIcon(), // 프로필 아이콘 빌드
            const SizedBox(height: 16),
            _buildTextField(
              controller: _nameController,
              label: l10n.name,
              errorText: nameError,
              hintText: l10n.limitTextPlaceHolder,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _birthdateController,
              label: l10n.birthday,
              errorText: birthdateError,
              hintText: l10n.selectDate,
              onTap: _selectDate,
              readOnly: true,
            ),
            const Spacer(), // 남은 공간을 차지하게 하여 버튼이 아래로 이동하도록 설정
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileIcon() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60.0, // 프로필 사진 크기를 더 크게 변경
          backgroundColor: Colors.transparent,
          backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null, // 선택한 이미지로 설정
          child: _selectedImage == null
              ? Assets.icons.profileMaleContent.svg(width: 96, height: 96) // 기본 아이콘 크기도 조정
              : null, // 이미지가 선택되지 않았을 때 기본 아이콘 표시
        ),
        Positioned(
          bottom: 4,
          right: -4, // 아이콘이 더 오른쪽으로 가도록 위치 조정
          child: IconButton(
            icon: Assets.icons.albumIcon.svg(width: 26, height: 26), // 카메라 아이콘 추가
            onPressed: () {
              _requestPermissionAndPickImage(); // 권한 요청 및 이미지 선택 실행
            }, // 카메라 아이콘 클릭 시 권한 처리 위젯 실행
          ),
        ),
      ],
    );
  }

// 권한을 요청한 후 이미지 선택을 처리하는 함수
  Future<void> _requestPermissionAndPickImage() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return PermissionHandlerWidget(
          appName: l10n.appName,
          onPermissionGranted: () async {
            // 권한이 허용되면 이미지를 선택하고 모달을 닫음
            await _pickImageFromGallery();
            Navigator.of(context).pop(); // 모달 닫기
          },
          callLocation: 'PHOTO_ACTION',
        );
      },
    );
  }


  // 이미지 선택을 처리하는 함수
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? errorText,
    String? hintText,
    VoidCallback? onTap,
    bool readOnly = false, // 기본적으로 readOnly는 false
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 14)), // 라벨 텍스트 스타일
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          cursorColor: Colors.orangeAccent, // 커서 색상
          readOnly: readOnly, // readOnly는 이름 필드와 날짜 필드에 따라 다르게 적용
          onTap: onTap, // 날짜 필드에서만 캘린더가 뜨도록 onTap 이벤트 설정
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.orangeAccent), // 힌트 텍스트 스타일
            errorText: errorText,
            errorStyle: const TextStyle(color: Colors.orangeAccent), // 에러 텍스트 색상
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColorName.defaultGray), // 밑줄 색상
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColorName.defaultGray), // 포커스된 상태에서의 밑줄 색상
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _birthdateController.text = "${pickedDate.toLocal()}".split(' ')[0];
        birthdateError = null;
      });
    }
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            nameError = _validateName(_nameController.text);
            birthdateError = _birthdateController.text.isEmpty ? l10n.selectDate : null;
          });
          if (nameError == null && birthdateError == null) {
            Navigator.of(context).pop({
              'name': _nameController.text,
              'birthdate': _birthdateController.text,
              'image': _selectedImage,
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorName.defaultBlack, // 버튼 색상
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
        child: AppText(
          l10n.save,
          style: TypoStyle.notoSansR13_1_4,
          color: ColorName.white,
        ),
      ),
    );
  }

  String? _validateName(String name) {
    if (name.isEmpty) {
      return l10n.typingName;
    } else if (name.length < 2 || name.length > 20) {
      return l10n.limitTextPlaceHolder;
    }
    return null;
  }
}
