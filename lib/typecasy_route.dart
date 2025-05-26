import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/common/unknown_page.dart';
import 'screens/home/typecash_home_page.dart';
import 'screens/user/join_user_page.dart';
import 'screens/user/login_page.dart';
import 'screens/user/password_reset_page.dart';

// 라우팅 관리 클래스
//
class TypecasyRoute {
  static final RouteObserver<ModalRoute<void>> pageRouteObserver =
      RouteObserver<ModalRoute<void>>();

  static RouteFactory? get onGenerateRoute => (settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        // GaGaNavigatorObserver 에서 기록
        // if (settings.arguments is GaGaArguments) {
        //   final args = settings.arguments as GaGaArguments;
        //   colorPrint('navigator push - route name: ${settings.name}, arguments: ${args.keys}',
        //       LogHelper.brightWhite);
        // } else {
        //   colorPrint('navigator push - route name: ${settings.name}', LogHelper.brightWhite);
        // }

        return getScreen(settings.name, arguments: settings.arguments);
      },
    );
  };

  static RouteFactory? get onUnknownRoute =>
      (settings) => MaterialPageRoute(builder: (_) => const UnknownScreen());

  static Widget getScreen(String? name, {Object? arguments}) {
    return _getScreen(name, arguments: arguments) ?? const UnknownScreen();
  }

  static Widget? _getScreen(String? name, {Object? arguments}) {
    // route page
    switch (name) {
      case LoginPage.routeName:
        return _getLoginPage();
      case TypecashHomePage.routeName:
        return _getHomePage();
      case JoinUserPage.routeName:
        return _getJoinUserPage();
      case PasswordResetPage.routeName:
        return _getPasswordResetPage();
      default:
        return null;
    }
  }

  static Widget? _getLoginPage() {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => LoginPageViewModel()),
      ],
      child: const LoginPage(),
    );
  }

  static Widget? _getHomePage() {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => TypecashHomePageViewModel()),
      ],
      child: const TypecashHomePage(),
    );
  }

  static Widget? _getPasswordResetPage() {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => PasswordResetPageViewModel()),
      ],
      child: const PasswordResetPage(),
    );
  }

  static Widget? _getJoinUserPage() {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => JoinUserPageViewModel()),
      ],
      child: const JoinUserPage(),
    );
  }
}
