import 'package:couple_book/core/routing/router.dart';
import 'package:couple_book/data/local/datasources/local_user_local_data_source.dart';
import 'package:couple_book/data/local/entities/local_user_entity.dart';
import 'package:couple_book/presentation/pages/couple_anniversary/models/couple_anniversary_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class CoupleAnniversaryViewModel extends ChangeNotifier {
  final LocalUserLocalDataSource _localUserLocalDataSource;
  CoupleAnniversaryState _state;

  CoupleAnniversaryViewModel({
    required LocalUserLocalDataSource localUserLocalDataSource,
  })  : _localUserLocalDataSource = localUserLocalDataSource,
        _state = CoupleAnniversaryState();

  CoupleAnniversaryState get state => _state;

  void setSelectedDate(DateTime date) {
    _state = _state.copyWith(selectedDate: date);
    notifyListeners();
  }

  Future<void> saveDateAndNavigate(BuildContext context) async {
    if (_state.selectedDate != null) {
      try {
        _state = _state.copyWith(isLoading: true);
        notifyListeners();

        await _localUserLocalDataSource.saveLocalUser(
          LocalUserEntity(anniversary: _state.selectedDate!.toIso8601String()),
        );

        if (context.mounted) {
          context.goNamed(ViewRoute.home.name);
        }
      } catch (e) {
        logger.e('Failed to save anniversary date: $e');
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        );
        notifyListeners();
      }
    }
  }
} 