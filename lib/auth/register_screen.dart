// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import '../home/Home.dart';
import '../utils/validators.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignUpScreen> {
  bool changebutton = false;
  bool seepwd = true;
  bool seeconpwd = true;

  final _signUpFormKey = GlobalKey<FormState>();
  var jsonResponses;
  bool isLoading = false;
  late ScaffoldMessengerState scaffoldMessenger;

  TextEditingController fullname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final TextEditingController _conPassController = TextEditingController();

  moveToLogin(BuildContext context) async {
    if (_signUpFormKey.currentState!.validate()) {
      setState(() {
        changebutton = true;
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        changebutton = false;
      });
    }
  }

  Future<void> registerUser(
      {String? fullname,
      String? phone,
      String? email,
      String? password}) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    late String deviceId;

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.androidId; // Use androidId as device ID
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId =
            iosInfo.identifierForVendor; // Use identifierForVendor as device ID
      }
    } on PlatformException {
      deviceId = 'Failed to get device ID.';
    }
    // print('Device ID: $deviceId');

    Map<String, dynamic> body = {
      "fullName": fullname,
      "phoneNumber": phone,
      "email": email,
      "password": password,
      "role": "OWNER",
      "deviceId": deviceId
    };

    var url = Uri.parse('$baseUrl/auth/register');
    final postRequestResponse = await http.Client().post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body));

    print(postRequestResponse.body);
    if (postRequestResponse.statusCode == 200) {
      var jsonResponse = json.decode(postRequestResponse.body);
      var message = jsonResponse['data']['user']['fullName'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$message, registered successfully',
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
          backgroundColor: Color.fromARGB(255, 1, 145, 56),
        ),
      );

      var jsonResponses = postRequestResponse.body;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt', jsonResponses);
      // Start the timer in the initState method
      _timer = Timer(Duration(seconds: 1), () {
        // Check if the widget is still mounted before navigating
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
            (route) => false,
          );
        }
      });
    } else {
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
        isLoading = false;
      });
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var confirmPass;
  Timer? _timer;

  @override
  void dispose() {
    fullname.dispose();
    phone.dispose();
    email.dispose();
    password.dispose();
    _conPassController.dispose();
    _timer?.cancel();

    super.dispose();
  }

  // By defaut, the checkbox is unchecked and "agree" is "false"
  bool agree = false;

  void _launchURL() async {
    const url = 'http://52.23.50.252:9077/privacy';
    //ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchTerms() async {
    const url = 'http://52.23.50.252:9077/terms';
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: SingleChildScrollView(
          child: Form(
            key: _signUpFormKey,
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/logo1.png',
                      height: size.height * .2,
                      width: size.width * .2,
                      fit: BoxFit.cover),

                  // -----------------TextFormFiled For Name ,Username and Password------------------------
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Welcome,',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22),
                            )
                          ])),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Enter your credentials below to sign up.',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600),
                            ),
                          ])),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 15,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFormField(
                              controller: fullname,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: .1, color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(10)),
                                fillColor: Colors.grey.shade50,
                                filled: true,
                                hintText: 'Enter your full name',
                                hintStyle: const TextStyle(fontSize: 12),
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Color.fromARGB(255, 9, 68, 117),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.blueGrey,
                                    width: .2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.blueGrey,
                                    width: .2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Name cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            TextFormField(
                              controller: phone,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: .1, color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(10)),
                                fillColor: Colors.grey.shade50,
                                filled: true,
                                hintText: 'Enter your phone number',
                                hintStyle: const TextStyle(fontSize: 12),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                prefixIcon: const Icon(
                                  Icons.phone,
                                  color: Color.fromARGB(255, 9, 68, 117),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.blueGrey,
                                    width: .1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.blueGrey,
                                    width: .1,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Phone cannot be empty";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            TextFormField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: .1, color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(10)),
                                fillColor: Colors.grey.shade50,
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.blueGrey,
                                    width: .1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.blueGrey,
                                    width: .1,
                                  ),
                                ),
                                hintText: 'Enter your email',
                                hintStyle: const TextStyle(fontSize: 13),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                prefixIcon: const Icon(
                                  Icons.mail,
                                  color: Color.fromARGB(255, 9, 68, 117),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email cannot be empty";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: password,
                              obscureText: seepwd,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade50,
                                filled: true,
                                hintText: "Enter password",
                                hintStyle: const TextStyle(fontSize: 12),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: IconButton(
                                  icon: Icon(seepwd
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      seepwd = !seepwd;
                                    });
                                  },
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: Color.fromARGB(255, 9, 68, 117),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.blueGrey,
                                    width: .1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.blueGrey,
                                    width: .1,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: .1, color: Colors.blueGrey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (String? value) {
                                confirmPass = value;
                                if (value!.isEmpty) {
                                  return "Please enter new password";
                                } else if (value.length < 8) {
                                  return "Password must be at least 8 characters long";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _conPassController,
                              obscureText: seeconpwd,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade50,
                                filled: true,
                                hintText: "Confirm password",
                                hintStyle: const TextStyle(fontSize: 12),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: IconButton(
                                  icon: Icon(seeconpwd
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      seeconpwd = !seeconpwd;
                                    });
                                  },
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: Color.fromARGB(255, 9, 68, 117),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.blueGrey,
                                    width: .1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.blueGrey,
                                    width: .1,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: .1, color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "Please re-enter new password";
                                } else if (value.length < 8) {
                                  return "Password must be atleast 8 characters long";
                                } else if (value != confirmPass) {
                                  return "Password must be same as above";
                                } else {
                                  return null;
                                }
                              },
                            ),

                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            // ------------ Sign Up Container Button -----------
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Checkbox(
                                      checkColor: Colors.lightBlueAccent,
                                      focusColor: Colors.lightBlueAccent,
                                      value: agree,
                                      onChanged: (value) {
                                        setState(() {
                                          agree = value ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        10), // Add space between checkbox and text
                                Expanded(
                                  child: Wrap(
                                    spacing:
                                        5, // Add spacing between text items
                                    children: [
                                      Text(
                                        'I agree to',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      InkWell(
                                        child: Text(
                                          'Terms & Conditions',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 15,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        onTap: () {
                                          _launchTerms();
                                        },
                                      ),
                                      Text(
                                        'and',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      InkWell(
                                        child: Text(
                                          'Privacy Policy',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 15,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        onTap: () {
                                          _launchURL();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            SizedBox(
                                width: size.width,
                                height: size.height * 0.06,
                                child: ElevatedButton(
                                  onPressed: agree
                                      ? () async {
                                          if (_signUpFormKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await Future.delayed(
                                                const Duration(seconds: 1));
                                            registerUser(
                                                    fullname: fullname.text,
                                                    email: email.text,
                                                    phone: phone.text,
                                                    password: password.text)
                                                .then((value) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            });
                                          }
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.all(
                                        2,
                                      )),
                                  child: isLoading
                                      ? const Center(
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white),
                                            ),
                                          ),
                                        )
                                      : const Text("Sign Up",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Baloo2',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                )),

                            SizedBox(
                              height: size.height * 0.013,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Baloo2',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignInScreen()),
                                    );
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                        // decoration: TextDecoration.underline,
                                        fontSize: 16,
                                        fontFamily: 'Baloo2',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                //   ],
                                // ),
                              ],
                            ),
                          ])),

                  const Center(
                    child: Text(
                      'Speack Cashless Mobility',
                      style: TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
