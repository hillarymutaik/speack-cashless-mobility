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
  final screens = [const HomeScreen(), WalletScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue.withOpacity(.3),
        elevation: 0,
        selectedItemColor: const Color.fromARGB(255, 2, 46, 100),
        unselectedItemColor:
            const Color.fromARGB(255, 2, 46, 99).withOpacity(0.5),
        // iconSize: 25,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled, // Use the home icon from Font Awesome
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment_outlined,
            ),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
