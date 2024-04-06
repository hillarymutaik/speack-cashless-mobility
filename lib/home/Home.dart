// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import '../screens/loans/loans_screen.dart';
import '../screens/wallet/wallet_pin.dart';
import 'home_screen.dart';

class Home extends StatefulWidget {
  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;

  int currentIndex = 0;
  final screens = [
    const HomeScreen(),
    const LoansHomeScreen(),
    const PinScreen(),
    // WalletScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 15,
        selectedItemColor: Colors.blue,
        unselectedItemColor:
            const Color.fromARGB(255, 2, 46, 99).withOpacity(0.8),
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              size: 30,
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.money_outlined,
              size: 30,
            ),
            label: 'Loans',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.wallet_rounded,
              size: 30,
            ),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: ClipOval(
              child: Image.asset(
                'assets/logo.jpg', // Replace 'assets/profile_image.png' with your image path
                width: 30,
                height: 30,
                fit: BoxFit.fill,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
