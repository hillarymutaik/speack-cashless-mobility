import 'package:flutter/material.dart';

import 'wallet_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({Key? key}) : super(key: key);

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String enteredPin = '';
  final String correctPin = '1234'; // Define the correct PIN here

  final List<String> _keyboardCharacters = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'Cancel',
    '0',
    'Ok',
  ];
  bool pinVisible = true;

  List<Widget> _buildStars() {
    List<Widget> stars = [];
    Color starColor = enteredPin == correctPin
        ? const Color.fromARGB(255, 51, 126, 187)
        : Colors.red;
    for (int i = 0; i < 4; i++) {
      stars.add(
        Icon(
          Icons.star,
          color: starColor,
        ),
      );
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(18.0), // Add margin for spacing
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color.fromARGB(255, 51, 126, 187),
                    width: 0.8), // Add border
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 40,
                color: Color.fromARGB(255, 51, 126, 187),
              ),
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildStars(),
            ),
            const SizedBox(height: 15.0),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: (MediaQuery.of(context).size.width - 10) /
                        (MediaQuery.of(context).size.height * 0.5),
                  ),
                  itemCount: _keyboardCharacters.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                        // Align items in the center of each grid cell
                        child: KeyboardKey(
                      character: _keyboardCharacters[index],
                      onPressed: () {
                        setState(() {
                          enteredPin += _keyboardCharacters[index];
                        });
                        if (enteredPin == correctPin) {
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WalletScreen(),
                              ),
                            );
                          });
                        } else if (enteredPin != correctPin &&
                            enteredPin.length == 4) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Center(
                                child: Text('Incorrect PIN. Please try again.'),
                              ),
                              duration: const Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor:
                                  Colors.red[400], // Set background color
                            ),
                          );
                          setState(() {
                            enteredPin = ''; // Clear entered PIN if wrong
                          });
                        }
                      },
                    ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KeyboardKey extends StatelessWidget {
  final String character;
  final VoidCallback onPressed;

  const KeyboardKey({
    Key? key,
    required this.character,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(10.0), // Add margin for spacing
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black87, width: 0.8), // Add border
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          character,
          style: const TextStyle(fontSize: 25.0),
        ),
      ),
    );
  }
}
