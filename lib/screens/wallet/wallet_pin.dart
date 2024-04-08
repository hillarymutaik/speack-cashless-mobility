import 'package:flutter/material.dart';
import 'package:speack_cashless_mobility/utils/colors_frave.dart';
import 'package:speack_cashless_mobility/utils/validators.dart';

import 'wallet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String enteredPin = '';
  final _setForm = GlobalKey<FormState>();
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
    '0'
  ];

  bool pinVisible = true;
  bool _setLoading = false;

  List<Widget> _buildStars(String enteredPin) {
    List<Widget> stars = [];

    // Set the starColor based on the entered PIN
    for (int i = 0; i < 4; i++) {
      if (i < enteredPin.length) {
        Color starColor = i < enteredPin.length ? Colors.blue : Colors.grey;

        stars.add(
          Icon(
            Icons.star,
            color: starColor,
          ),
        );
      }
    }
    return stars;
  }

  Future<void> setWalletPin({String? pin}) async {
    setState(() {
      _setLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwt = prefs.getString('jwt');
    Map<String, dynamic> token = jsonDecode(jwt!);

    Map<String, String> body = {
      "pin": pin!,
    };

    var url = Uri.parse('$baseUrl/security-pins/validate');
    final postRequestResponse = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token['data']['token']}'
      },
      body: jsonEncode(body),
    );

    print(postRequestResponse.body);

    if (postRequestResponse.statusCode == 200) {
      var jsonResponse = json.decode(postRequestResponse.body);
      var status = jsonResponse['status'];
      var message = jsonResponse['desc'];
      if (status == 'OK') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$message',
              style: TextStyle(color: Colors.white, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(milliseconds: 20),
            margin: const EdgeInsets.only(
              bottom: 10,
              right: 25,
              left: 25,
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WalletScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$message',
              textAlign: TextAlign.center,
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 5),
            margin: const EdgeInsets.only(
              bottom: 10,
              right: 15,
              left: 15,
            ),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _setLoading = false;
          enteredPin = '';
        });
      }
    } else if (postRequestResponse.statusCode == 400) {
      var message = json.decode(postRequestResponse.body)['message'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$message',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.only(
            bottom: 10,
            right: 15,
            left: 15,
          ),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _setLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _setForm,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(30.0), // Add margin for spacing
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.blue, width: 0.5), // Add border
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 40,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildStars(enteredPin),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 15.0,
                    childAspectRatio: (MediaQuery.of(context).size.width - 10) /
                        (MediaQuery.of(context).size.height * 0.5),
                  ),
                  itemCount:
                      _keyboardCharacters.length + 1, // Add 1 for OK button
                  itemBuilder: (BuildContext context, int index) {
                    if (index == _keyboardCharacters.length) {
                      // Render the OK button
                      return InkWell(
                          onTap: () {
                            if (enteredPin.length != 4) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Center(
                                    child: Text('PIN must be 4 digits.'),
                                  ),
                                  duration: const Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.all(15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: Colors.red[400],
                                ),
                              );
                              setState(() {
                                _setLoading = false;
                                enteredPin = '';
                              });

                              return; // Prevent further execution if PIN length is not 4
                            }
                            setState(() {
                              _setLoading = true;
                            });
                            setWalletPin(pin: enteredPin).then((value) {
                              setState(() {
                                _setLoading = false;
                              });
                            });
                          },
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                  vertical: 10), // Add margin for spacing
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blue,
                                    width: 0.5), // Add border
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Center(
                                  child: _setLoading
                                      ? const Center(
                                          child: SizedBox(
                                          height: 15,
                                          width: 15,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor: AlwaysStoppedAnimation(
                                              Colors.blue,
                                            ),
                                          ),
                                        ))
                                      : Text('OK',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue)))));
                    } else {
                      // Render numeric buttons
                      return Center(
                        child: KeyboardKey(
                          character: _keyboardCharacters[index],
                          onPressed: () {
                            setState(() {
                              enteredPin += _keyboardCharacters[index];
                            });
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ));
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
        margin: const EdgeInsets.symmetric(
            horizontal: 6.0, vertical: 10), // Add margin for spacing
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 0.5), // Add border
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          character,
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
