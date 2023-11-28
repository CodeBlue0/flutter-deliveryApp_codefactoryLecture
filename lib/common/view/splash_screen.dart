import 'package:codefactory/common/const/colors.dart';
import 'package:codefactory/common/const/data.dart';
import 'package:codefactory/common/layout/default_layout.dart';
import 'package:codefactory/common/secure_storage/secure_storage.dart';
import 'package:codefactory/common/view/root_tab.dart';
import 'package:codefactory/user/view/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  static String get routeName => 'splash';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(
              height: 16.0,
            ),
            const CircularProgressIndicator(color: Colors.white)
          ],
        ),
      ),
    );
  }
}
