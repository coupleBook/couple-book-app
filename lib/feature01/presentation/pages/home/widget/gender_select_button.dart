import 'package:couple_book/data/local/entities/enums/gender_enum.dart';
import 'package:couple_book/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class GenderSelectButton extends StatelessWidget {
  final Gender gender;
  final Gender? selectedGender;
  final ValueChanged<Gender> onSelected;

  const GenderSelectButton({
    required this.gender,
    required this.selectedGender,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = gender == selectedGender;
    return ElevatedButton(
      onPressed: () => onSelected(gender),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? ColorName.defaultBlack : ColorName.lightGray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        gender.toDisplayValue(),
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
