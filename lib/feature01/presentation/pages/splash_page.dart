import 'package:couple_book/core/routes/view_route.dart';
import 'package:couple_book/feature01/presentation/viewmodels/auth_info_provider.dart';
import 'package:couple_book/feature01/presentation/viewmodels/local_user_info_provider.dart';
import 'package:couple_book/gen/assets.gen.dart';
import 'package:couple_book/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _controller.reverse().then((_) {
            if (mounted) {
              _navigateByState();
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authInfoProvider, (_, __) => _navigateByState());
    ref.listen(localUserInfoProvider, (_, __) => _navigateByState());

    return Scaffold(
      body: Stack(
        children: [
          FadeTransition(
            opacity: _opacityAnimation,
            child: Container(
              color: ColorName.backgroundColor,
              child: Center(
                child: Assets.icons.appLogoIcon.svg(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateByState() {
    final authInfo = ref.read(authInfoProvider);
    final localUserInfo = ref.read(localUserInfoProvider);

    final hasToken = authInfo?.accessToken.isNotEmpty == true;
    final hasAnniversary = localUserInfo?.anniversary?.isNotEmpty == true;

    if (hasToken && hasAnniversary) {
      context.go(ViewRoute.home.path);
    } else if (hasToken && !hasAnniversary) {
      context.go(ViewRoute.coupleAnniversary.path);
    } else {
      context.go(ViewRoute.login.path);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
