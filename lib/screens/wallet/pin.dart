import 'package:flutter/material.dart';

import 'wallet_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({Key? key}) : super(key: key);

  @override
  State<PinScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<PinScreen> {
  String enteredPin = '';

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
    '0',
  ];
  bool pinVisible = true;

  List<Widget> _buildStars() {
    List<Widget> stars = [];
    for (int i = 1; i < 5; i++) {
      stars.add(
        const Icon(Icons.star, color: Colors.green),
      );
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Password Keyboard'),
        // ),
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 60,
            color: Colors.black,
          ),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildStars(),
          ),
          // Visibility(
          //   visible: pinVisible,
          //   child: Text(
          //     enteredPin,
          //     style: const TextStyle(fontSize: 24.0),
          //   ),
          // ),
          const SizedBox(height: 15.0),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(20.0),
            child: CustomPaint(
              painter: GridViewDividerPainter(
                crossAxisCount: 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height * 0.5),
                ),
                itemCount: _keyboardCharacters.length,
                itemBuilder: (BuildContext context, int index) {
                  return KeyboardKey(
                    character: _keyboardCharacters[index],
                    onPressed: () {
                      setState(() {
                        enteredPin += _keyboardCharacters[index];
                      });
                      print('Pressed: ${_keyboardCharacters[index]}');
                      if (enteredPin == '6095') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WalletScreen()),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          )),
        ],
      ),
    ));
  }
}

class KeyboardKey extends StatelessWidget {
  final String character;
  final VoidCallback onPressed;

  const KeyboardKey(
      {super.key, required this.character, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          character,
          style: const TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

class GridViewDividerPainter extends CustomPainter {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  GridViewDividerPainter({
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double itemWidth =
        (size.width - (crossAxisSpacing * (crossAxisCount - 1))) /
            crossAxisCount;
    final double itemHeight =
        (size.height - (mainAxisSpacing * (crossAxisCount - 1))) /
            crossAxisCount;

    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    // Draw horizontal lines
    for (int i = 1; i < crossAxisCount; i++) {
      final double y =
          i * (itemHeight + mainAxisSpacing) - (mainAxisSpacing / 2);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw vertical lines
    for (int i = 1; i < crossAxisCount; i++) {
      final double x =
          i * (itemWidth + crossAxisSpacing) - (crossAxisSpacing / 2);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
