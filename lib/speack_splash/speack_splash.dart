import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login_screen.dart';
import '../home/Home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const routeName = 'splash-screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final bool _isInit = false;

  @override
  void didChangeDependencies() {
    _initialize();
    super.didChangeDependencies();
  }

  void _initialize() async {
    if (!_isInit) {
      Timer(const Duration(seconds: 2), () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String? jwt = prefs.getString('jwt');
        if (jwt != null) {
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (route) => false);
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/log.png'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Image.asset(
              'assets/logo.jpg',
              height: size.height * 0.15,
              width: size.height * 0.15,
            ),
          ),
        ));
  }
}
