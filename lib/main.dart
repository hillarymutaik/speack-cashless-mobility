import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';

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
      home: const SplashScreen(),
    );
  }
}
