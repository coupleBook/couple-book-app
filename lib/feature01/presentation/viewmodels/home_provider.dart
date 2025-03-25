import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 홈 화면의 선택된 탭 상태를 관리하는 StateNotifier
class HomeState {
  final int selectedIndex;

  HomeState({this.selectedIndex = 0});

  HomeState copyWith({int? selectedIndex}) {
    return HomeState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(HomeState());

  void updateIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }
}

/// HomePage의 탭 인덱스 상태 관리
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});

/// SharedPreferences를 FutureProvider로 관리
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});
