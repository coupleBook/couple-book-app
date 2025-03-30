import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/home_state.dart';

class HomeViewModel extends ChangeNotifier {
  HomeState _state;
  late SharedPreferences _prefs;

  HomeViewModel() : _state = HomeState() {
    _initialize();
  }

  HomeState get state => _state;

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    final anniversaryDate = _prefs.getString('anniversaryDate');
    _state = _state.copyWith(anniversaryDate: anniversaryDate);
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _state = _state.copyWith(selectedIndex: index);
    notifyListeners();
  }

  void onNotificationTab() {
    // TODO: 알림 탭 처리
  }

  void onSettingTab() {
    // TODO: 설정 탭 처리
  }
} 