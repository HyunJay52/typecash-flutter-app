import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/config/environment.dart';
import 'package:typecash_flutter_app/providers/ad_provider.dart';
import 'package:typecash_flutter_app/providers/join_user_provider.dart';
import 'package:typecash_flutter_app/providers/user_provider.dart';
import 'package:typecash_flutter_app/screens/ad/ad_page.dart';
import 'package:typecash_flutter_app/screens/home/typecash_home_page.dart';
import 'package:typecash_flutter_app/screens/reward/reward_store_page.dart';
// import 'package:typecash_flutter_app/screens/splash_page.dart';
import 'package:typecash_flutter_app/screens/user/join_user_page.dart';
import 'package:typecash_flutter_app/screens/user/login_page.dart';
import 'package:typecash_flutter_app/screens/user/password_reset_page.dart';
import 'package:typecash_flutter_app/splash_page.dart';

void main() {
  final String flavor = const String.fromEnvironment('FLAVOR', defaultValue:'local');

  final EnvironmentConfig config = EnvironmentConfig.fromFlavor(flavor);
  Environment().initialize(
    environment: config.environmentType,
    server: config.serverType,
  );

  // * google admob init
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdProvider(),),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => JoinUserProvider()),
      ],
      child: const TypeCashApp(),
    ),
  );
}

class TypeCashApp extends StatelessWidget {
  const TypeCashApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TypeCash',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        fontFamily: 'NanumBarunGothic',
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF3182F7), primary: Color(0xFF3182F7), secondary: Color(0xFF3182F7)
        ),
      ),
      supportedLocales: const [
        Locale('ko', 'KR'), // Korean
        Locale('en', 'US'), // English
      ],
      home: LoginPage(), // const MyHomePage(title: 'Login Page'),
      initialRoute: SplashPage.routeName,
      routes: {
        // todo : create route helper
        SplashPage.routeName: (context) => SplashPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        TypecashHomePage.routeName: (context) => const TypecashHomePage(),
        PasswordResetPage.routeName: (context) => const PasswordResetPage(),
        JoinUserPage.routeName: (context) => const JoinUserPage(),
        AdPage.routeName: (context) => const AdPage(),
        RewardStorePage.routeName: (context) => const RewardStorePage(),
      },
    );
  }
}