import 'package:couple_book/data/local/datasources/auth_local_data_source.dart';
import 'package:couple_book/data/local/datasources/local_user_local_data_source.dart';
import 'package:couple_book/core/constants/assets.gen.dart';
import 'package:couple_book/core/theme/colors.gen.dart';
import 'package:couple_book/pages/couple_anniversary/page.dart';
import 'package:couple_book/pages/home/page.dart';
import 'package:couple_book/presentation/pages/login/views/login_view.dart';
import 'package:couple_book/presentation/pages/splash/viewmodels/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late SplashViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SplashViewModel(
      authLocalDataSource: AuthLocalDataSource(),
      localUserLocalDataSource: LocalUserLocalDataSource(),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<SplashViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.state.hideSplash) {
            if (viewModel.state.existToken && viewModel.state.existAnniversary) {
              return const HomePage();
            } else if (viewModel.state.existToken) {
              return const CoupleAnniversaryPage();
            } else {
              return const LoginView();
            }
          }

          return AnimatedOpacity(
            opacity: viewModel.opacity,
            duration: const Duration(milliseconds: 500),
            child: Container(
              color: ColorName.backgroundColor,
              child: Center(
                child: Assets.icons.appLogoIcon.svg(),
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
