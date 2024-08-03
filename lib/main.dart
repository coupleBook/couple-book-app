import 'package:COUPLE_BOOK/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'gen/colors.gen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: CoupleBookApp()));
}

class CoupleBookApp extends ConsumerStatefulWidget {
  static final navKey = GlobalKey<NavigatorState>();

  const CoupleBookApp({super.key});

  @override
  ConsumerState createState() => _CoupleBookAppState();
}

class _CoupleBookAppState extends ConsumerState<CoupleBookApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'COUPLE BOOK',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorName.white,
          background: ColorName.white,
          surface: ColorName.white,
          surfaceTint: ColorName.white,
        ),
        splashColor: ColorName.lightGray,
        highlightColor: ColorName.lightGray,
      ),
      routerConfig: router,
    );
  }
}
