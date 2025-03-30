class HomeState {
  final int selectedIndex;
  final String? anniversaryDate;

  HomeState({
    this.selectedIndex = 0,
    this.anniversaryDate,
  });

  HomeState copyWith({
    int? selectedIndex,
    String? anniversaryDate,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
    );
  }
} 