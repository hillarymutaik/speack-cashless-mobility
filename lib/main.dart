import 'package:flutter/material.dart';

import 'auth/login_screen.dart';
import 'home/home_screen.dart';
import 'speack_splash/speack_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SpeackCashless());
}

class SpeackCashless extends StatelessWidget {
  const SpeackCashless({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 13.0),
          bodyMedium: TextStyle(fontSize: 13.0),
        ),
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        SignInScreen.routeName: (_) => const SignInScreen(),
        SearchScreen.routeName: (_) => const SearchScreen(),
      },
    );
  }
}
