import 'package:codefactory/user/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final provider = ref.read(authProvier.notifier);

  return GoRouter(
    routes: provider.routes,
    redirect: provider.redirectLogic,
    refreshListenable: provider,
  );
});
