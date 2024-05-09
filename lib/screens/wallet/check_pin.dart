// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speack_cashless_mobility/profile/set_wallet_pin.dart';
import 'package:speack_cashless_mobility/screens/wallet/wallet_pin.dart';

class CheckPINScreen extends StatefulWidget {
  const CheckPINScreen({super.key});

  @override
  State<CheckPINScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<CheckPINScreen> {
  String? tokenzz = '';
  bool pin = true;

  void account() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenzz = prefs.getString('jwt')!;
    Map<String, dynamic> token = jsonDecode(tokenzz!);

    setState(() {
      // print(token);
      pin = token['data']['hasSecurityPIN'];
    });
  }

  @override
  void initState() {
    super.initState();
    account();
    Timer(const Duration(seconds: 1), () async {
      if (pin == true) {
        Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => PinScreen()),
            (Route<dynamic> route) => false);
      } else if (pin == false) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SetWalletPinScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: SizedBox(
          height: size.height * 0.03,
          width: size.height * 0.03,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation(
              Colors.lightBlueAccent,
            ),
          ),
        )));
  }
}
