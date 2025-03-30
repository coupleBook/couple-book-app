import 'package:couple_book/core/l10n/l10n.dart';
import 'package:couple_book/core/theme/colors.gen.dart';
import 'package:couple_book/core/constants/assets.gen.dart';
import 'package:couple_book/core/theme/text_style.dart';
import 'package:couple_book/data/local/datasources/local_user_local_data_source.dart';
import 'package:couple_book/presentation/pages/couple_anniversary/viewmodels/couple_anniversary_view_model.dart';
import 'package:couple_book/presentation/widgets/calendar/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoupleAnniversaryView extends StatefulWidget {
  const CoupleAnniversaryView({super.key});

  @override
  State<CoupleAnniversaryView> createState() => _CoupleAnniversaryViewState();
}

class _CoupleAnniversaryViewState extends State<CoupleAnniversaryView> {
  late CoupleAnniversaryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CoupleAnniversaryViewModel(
      localUserLocalDataSource: LocalUserLocalDataSource.instance,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
            ),
            child: CalendarView(
              selectedDate: _viewModel.state.selectedDate,
              onDaySelected: (selectedDay) {
                _viewModel.setSelectedDate(selectedDay);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<CoupleAnniversaryViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: const Color(0xFFF6F6D8),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: screenWidth * 0.9,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          bottom: 0,
                          right: screenWidth * 0.11,
                          child: Assets.icons.pencilUnderlineBg.svg(
                            width: screenWidth * 0.64,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: AppText(
                            '처음 만난 날 설정하기',
                            style: TypoStyle.notoSansR19_1_4.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorName.pointBtnBg,
                      foregroundColor: Colors.black87,
                      minimumSize: Size(screenWidth * 0.84, 58),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: AppText(
                      viewModel.state.selectedDate == null
                          ? l10n.selectDate
                          : '${viewModel.state.selectedDate!.year}년 ${viewModel.state.selectedDate!.month}월 ${viewModel.state.selectedDate!.day}일',
                      style: TypoStyle.notoSansSemiBold13_1_4.copyWith(
                        fontSize: 15,
                        letterSpacing: -0.2,
                      ),
                      color: ColorName.defaultGray,
                    ),
                    onPressed: () => _selectDate(context),
                  ),
                  const SizedBox(height: 13),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.disabled)) {
                            return ColorName.defaultGray;
                          }
                          return ColorName.defaultBlack;
                        },
                      ),
                      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                      minimumSize: WidgetStateProperty.all<Size>(Size(screenWidth * 0.84, 58)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: viewModel.state.selectedDate == null
                        ? null
                        : () => viewModel.saveDateAndNavigate(context),
                    child: AppText(
                      l10n.confirmSetting,
                      style: TypoStyle.notoSansSemiBold13_1_4.copyWith(
                        fontSize: 15,
                        letterSpacing: -0.2,
                      ),
                      color: viewModel.state.selectedDate == null
                          ? ColorName.pointBtnBg
                          : ColorName.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
} 