enum Gender {
  male,   // 남성
  female; // 여성

  // 서버로 넘길 값 (M, F)
  String toServerValue() {
    switch (this) {
      case Gender.male:
        return 'M';
      case Gender.female:
        return 'F';
    }
  }

  // 화면에 표시할 값 (한글)
  String toDisplayValue() {
    switch (this) {
      case Gender.male:
        return '남';
      case Gender.female:
        return '여';
    }
  }

  // 서버로부터 받은 값을 Enum으로 변환
  static Gender fromServerValue(String value) {
    switch (value) {
      case 'M':
        return Gender.male;
      case 'F':
        return Gender.female;
      default:
        throw Exception('Invalid gender value: $value');
    }
  }
}
