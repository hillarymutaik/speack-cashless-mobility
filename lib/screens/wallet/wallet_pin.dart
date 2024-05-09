import 'package:flutter/material.dart';
import 'package:speack_cashless_mobility/utils/validators.dart';

import '../../home/Home.dart';
// import '../../profile/otp_screen.dart';
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
  ];

  bool pinVisible = true;
  bool _setLoading = false;

  List<Widget> _buildStars(String enteredPin) {
    List<Widget> stars = [];

    // Set the starColor based on the entered PIN
    for (int i = 0; i < 4; i++) {
      if (i < enteredPin.length) {
        Color starColor =
            i < enteredPin.length ? Colors.lightBlueAccent : Colors.grey;

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

    // print(postRequestResponse.body);

    if (postRequestResponse.statusCode == 200) {
      var jsonResponse = json.decode(postRequestResponse.body);
      var status = jsonResponse['status'];
      var message = jsonResponse['desc'];
      if (status == 'OK') {
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
    return WillPopScope(
        onWillPop: () async {
          // Navigate to the homepage instead of closing the app
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => Home(),
            ),
            (Route<dynamic> route) => false,
          );
          // Return false to prevent the default back button behavior
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 70,
              leading: InkWell(
                onTap: () => Navigator.pushAndRemoveUntil<void>(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => Home()),
                    (Route<dynamic> route) => false),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 25.0,
                ),
              ),
              centerTitle: true,
              title: const Text('Enter Your Wallet PIN',
                  style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              iconTheme:
                  const IconThemeData(color: Colors.lightBlueAccent, size: 30),
            ),
            body: Form(
              key: _setForm,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding:
                          const EdgeInsets.all(25.0), // Add margin for spacing
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.lightBlueAccent,
                            width: 0.5), // Add border
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        size: 40,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildStars(enteredPin),
                    ),
                    const SizedBox(height: 10.0),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5.0,
                            crossAxisSpacing: 15.0,
                            childAspectRatio:
                                (MediaQuery.of(context).size.width - 10) /
                                    (MediaQuery.of(context).size.height * 0.5),
                          ),
                          itemCount: _keyboardCharacters.length +
                              3, // Add 3 for Cancel, 0, and OK buttons
                          itemBuilder: (BuildContext context, int index) {
                            if (index == _keyboardCharacters.length) {
                              // Render the Cancel button
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (enteredPin.isNotEmpty) {
                                      // Remove the last character from the entered PIN
                                      enteredPin = enteredPin.substring(
                                          0, enteredPin.length - 1);
                                    }
                                  });
                                },
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.lightBlueAccent,
                                        width: 0.5),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              );
                            } else if (index ==
                                _keyboardCharacters.length + 1) {
                              // Render the numeric button "0"
                              return Center(
                                child: KeyboardKey(
                                  character: '0',
                                  onPressed: () {
                                    setState(() {
                                      enteredPin += '0';
                                    });
                                  },
                                ),
                              );
                            } else if (index ==
                                _keyboardCharacters.length + 2) {
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
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                                      horizontal: 6.0, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.lightBlueAccent,
                                        width: 0.5),
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
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                  Colors.lightBlueAccent,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Text(
                                            'OK',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: enteredPin.length != 4
                                                  ? Colors.grey
                                                  : Colors.lightBlueAccent,
                                            ),
                                          ),
                                  ),
                                ),
                              );
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     const Text(
                    //       "Forgot your wallet PIN ?",
                    //       style: TextStyle(
                    //           fontSize: 13,
                    //           fontFamily: 'Baloo2',
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.black),
                    //     ),
                    //     TextButton(
                    //       onPressed: () {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (ctx) => OTPPINScreen()));
                    //       },
                    //       child: const Text(
                    //         "Reset PIN",
                    //         style: TextStyle(
                    //             decoration: TextDecoration.underline,
                    //             fontSize: 13,
                    //             fontFamily: 'Baloo2',
                    //             fontWeight: FontWeight.bold,
                    //             color: Colors.lightBlueAccent),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // Container(
                    //   height: 20,
                    // ),
                  ],
                ),
              ),
            )));
  }
}

// Update the KeyboardKey widget
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
        margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.lightBlueAccent, width: 0.5),
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

// In the PinScreen build method, update the Cancel button


