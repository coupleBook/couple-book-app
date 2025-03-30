import 'package:couple_book/core/constants/assets.gen.dart';
import 'package:couple_book/core/routing/router.dart';
import 'package:couple_book/core/theme/colors.gen.dart';
import 'package:couple_book/data/local/datasources/auth_local_data_source.dart';
import 'package:couple_book/data/local/datasources/local_user_local_data_source.dart';
import 'package:couple_book/presentation/pages/splash/viewmodels/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late SplashViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SplashViewModel(
      authLocalDataSource: AuthLocalDataSource(),
      localUserLocalDataSource: LocalUserLocalDataSource(),
    );
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (_viewModel.state.isInitialized) {
      if (context.mounted) {
        if (_viewModel.state.existToken) {
          if (_viewModel.state.existAnniversary) {
            context.goNamed(ViewRoute.home.name);
          } else {
            context.goNamed(ViewRoute.coupleAnniversary.name);
          }
        } else {
          context.goNamed(ViewRoute.login.name);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<SplashViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: ColorName.white,
            body: Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: viewModel.state.isInitialized ? 1.0 : 0.0,
                child: Assets.icons.appLogoIcon.svg(
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }
}
