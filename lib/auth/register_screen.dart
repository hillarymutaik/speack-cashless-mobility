// ignore_for_file: avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/validators.dart';
import 'login_screen.dart';
import 'package:flutter/services.dart';
// import 'package:device_info/device_info.dart';
// import 'dart:io';

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

  Future<dynamic> registerUser(
      {String? fullname,
      String? phone,
      String? email,
      String? password}) async {
    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // late String deviceId;

    // try {
    //   if (Platform.isAndroid) {
    //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //     deviceId = androidInfo.androidId; // Use androidId as device ID
    //   } else if (Platform.isIOS) {
    //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //     deviceId =
    //         iosInfo.identifierForVendor; // Use identifierForVendor as device ID
    //   }
    // } on PlatformException {
    //   deviceId = 'Failed to get device ID.';
    // }
    // print('Device ID: $deviceId');

    Map<String, dynamic> body = {
      "fullName": fullname,
      "phoneNumber": phone,
      "email": email,
      "password": password,
      "role": "OWNER",
      "deviceId": 'deviceId123'
    };

    var url = Uri.parse('$baseUrl/auth/register');
    final postRequestResponse = await http.Client().post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body));
    Map<String, dynamic> singingResponse = {
      'message': jsonDecode(postRequestResponse.body)['message'],
      'success': jsonDecode(postRequestResponse.body)['success'],
      'access_token': jsonDecode(postRequestResponse.body)['data']['token'],
    };
    print(postRequestResponse);
    if (postRequestResponse.statusCode == 200) {
      var jsonResponse = postRequestResponse.body;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt', jsonResponse);
    }
    return singingResponse;
  }

  final TextEditingController _conPassController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var confirmPass;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fullname.dispose();
    phone.dispose();
    email.dispose();
    password.dispose();
    _conPassController.dispose();
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
        backgroundColor: Colors.black,
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
                  Container(
                    height: size.height * 0.04,
                  ),
                  Container(
                    height: size.height * 0.18,
                    width: size.height * 0.18,
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/logo.jpg',
                            ),
                            fit: BoxFit.fill)),
                  ),

                  // -----------------TextFormFiled For Name ,Username and Password------------------------
                  Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              height: size.height * 0.01,
                            ),
                            // ------------ Sign Up Container Button -----------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.5),
                                    child: Checkbox(
                                      checkColor: Colors.blue,
                                      focusColor: Colors.blue.shade300,
                                      value: agree,
                                      onChanged: (value) {
                                        setState(() {
                                          agree = value ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Row(children: [
                                  const Text(
                                    'I agree to ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  InkWell(
                                    child: const Text(
                                      'Terms & Conditions ',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    onTap: () {
                                      _launchTerms();
                                    },
                                  ),
                                  const Text(
                                    'and ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  InkWell(
                                    child: const Text(
                                      'Privacy Policy',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    onTap: () {
                                      _launchURL();
                                    },
                                  ),
                                ])
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
                                              final responseValue =
                                                  value.cast<String, dynamic>();
                                              if (responseValue['success']) {
                                                ScaffoldMessenger.of(
                                                        context)
                                                    .showSnackBar(SnackBar(
                                                        content: const Text(
                                                          'Registered successfully!',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                        duration: const Duration(
                                                            seconds: 2),
                                                        margin: EdgeInsets.only(
                                                            bottom: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.8,
                                                            right: 20,
                                                            left: 20),
                                                        backgroundColor:
                                                            Colors.green));
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SignInScreen()),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: const Text(
                                                          'Invalid credentials. Retry!'),
                                                      backgroundColor:
                                                          responseValue[
                                                                  'success']
                                                              ? Colors.green
                                                              : Colors.red),
                                                );
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              }
                                            });
                                          }
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade400,
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
                                              strokeWidth: 1.5,
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
                                  "Already have an account ?",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Baloo2',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
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
                                        decoration: TextDecoration.underline,
                                        fontSize: 16,
                                        fontFamily: 'Baloo2',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                //   ],
                                // ),
                              ],
                            ),
                          ])),

                  const Center(
                      child: Text(
                    "Powered by Speack",
                    style: TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ))
                ],
              ),
            ),
          ),
        ));
  }
}
