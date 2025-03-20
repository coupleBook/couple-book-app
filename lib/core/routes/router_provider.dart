import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';

/// **GoRouter를 StateNotifierProvider로 관리**
final routerProvider = NotifierProvider<AppRouter, GoRouter>(AppRouter.new);
