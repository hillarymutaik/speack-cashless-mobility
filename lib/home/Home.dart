// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import '../screens/wallet/wallet_screen.dart';
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
    WalletScreen(),
    WalletScreen(),
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
        selectedItemColor: const Color.fromARGB(255, 2, 46, 100),
        unselectedItemColor:
            const Color.fromARGB(255, 2, 46, 99).withOpacity(0.5),
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled, // Use the home icon from Font Awesome
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.money_outlined,
            ),
            label: 'Loans',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.wallet_rounded,
            ),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: ClipOval(
              child: Image.asset(
                'assets/logo.jpg', // Replace 'assets/profile_image.png' with your image path
                width: 23, // Adjust the width as needed
                height: 23, // Adjust the height as needed
                fit: BoxFit.fill, // Adjust the fit as needed
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
