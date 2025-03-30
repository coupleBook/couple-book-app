class CoupleAnniversaryState {
  final DateTime? selectedDate;
  final bool isLoading;
  final String? errorMessage;

  CoupleAnniversaryState({
    this.selectedDate,
    this.isLoading = false,
    this.errorMessage,
  });

  CoupleAnniversaryState copyWith({
    DateTime? selectedDate,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CoupleAnniversaryState(
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
} 