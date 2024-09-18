import 'package:couple_book/gen/assets.gen.dart';
import 'package:couple_book/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // image_picker 패키지 추가
import 'dart:io'; // 파일 관련 작업을 위해 추가
import 'package:permission_handler/permission_handler.dart'; // permission_handler 패키지 추가

import '../../../style/text_style.dart';

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
                child: const Icon(Icons.close, color: Colors.black), // 닫기 버튼
              ),
            ),
            const SizedBox(height: 16),
            _buildProfileIcon(), // 프로필 아이콘 빌드
            const SizedBox(height: 16),
            _buildTextField(
              controller: _nameController,
              label: '이름',
              errorText: nameError,
              hintText: '2~20자 이내여야 합니다.',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _birthdateController,
              label: '생일',
              errorText: birthdateError,
              hintText: '날짜를 선택해 주세요.',
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
          bottom: 0,
          right: -4, // 아이콘이 더 오른쪽으로 가도록 위치 조정
          child: IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.orangeAccent),
            onPressed: _showPermissionRequestPopup, // 카메라 아이콘 클릭 시 작은 팝업 표시
          ),
        ),
      ],
    );
  }

  // 작은 팝업을 보여주기 위한 함수
  void _showPermissionRequestPopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildPermissionPopup();
      },
    );
  }

  // 사용자 맞춤형 권한 요청 팝업
  Widget _buildPermissionPopup() {
    return Container(
      width: MediaQuery.of(context).size.width, // 스크린에 꽉 차게 설정
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: ColorName.defaultBlack,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.photo_library,
            color: Colors.blueAccent,
            size: 40,
          ),
          const SizedBox(height: 16),

          // RichText를 사용하여 텍스트 스타일을 다르게 적용
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'COUPLE BOOK',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: ColorName.white, // COUPLE BOOK에 다른 스타일 적용
                  ),
                ),
                TextSpan(
                  text: '에서 기기의 사진과 동영상에\n액세스하도록 허용하시겠습니까?',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 버튼을 세로로 배치하고 가로 크기를 동일하게 맞춤
          Column(
            children: [
              SizedBox(
                width: double.infinity, // 가로 크기를 화면 가득 채우도록 설정
                child: TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // 팝업 닫기
                    await _requestPermissionAndPickImage(); // 실제 권한 요청 수행
                  },
                  child: const Text(
                    '허용',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueAccent, // 버튼 텍스트 색상
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity, // 가로 크기를 화면 가득 채우도록 설정
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 팝업 닫기
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('갤러리 접근 권한이 거부되었습니다.')),
                    );
                  },
                  child: const Text(
                    '허용 안함',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white, // 버튼 텍스트 색상
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Future<void> _requestPermissionAndPickImage() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        await _pickImageFromGallery();
      } else if (await Permission.manageExternalStorage.isDenied) {
        if (await Permission.manageExternalStorage.request().isGranted) {
          await _pickImageFromGallery();
        } else {
          _showPermissionDeniedMessage();
        }
      } else if (await Permission.storage.isPermanentlyDenied) {
        _openAppSettings(); // 권한이 영구적으로 거부되었을 때 설정 페이지로 이동
      }
    } else if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted) {
        await _pickImageFromGallery();
      } else if (await Permission.photos.isPermanentlyDenied) {
        _openAppSettings(); // 권한이 영구적으로 거부되었을 때 설정 페이지로 이동
      } else {
        _showPermissionDeniedMessage();
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('갤러리 접근 권한이 필요합니다.'),
        action: SnackBarAction(
          label: '설정',
          onPressed: _openAppSettings, // "설정" 버튼을 누르면 설정 페이지로 이동
        ),
      ),
    );
  }

  // 설정 페이지로 이동
  Future<void> _openAppSettings() async {
    await openAppSettings();
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
            birthdateError = _birthdateController.text.isEmpty ? '날짜를 선택해 주세요.' : null;
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
        child: const AppText(
          '저장하기',
          style: TypoStyle.notoSansR13_1_4,
          color: ColorName.white,
        ),
      ),
    );
  }

  String? _validateName(String name) {
    if (name.isEmpty) {
      return '이름을 입력해 주세요.';
    } else if (name.length < 2 || name.length > 20) {
      return '2~20자 이내여야 합니다.';
    }
    return null;
  }
}
