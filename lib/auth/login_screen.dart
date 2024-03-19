import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../home/Home.dart';
import '../home/home_screen.dart';
import '../utils/validators.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const routeName = 'signin-screen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool seepwd = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> checkNetworkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/log.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(),
            Container(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * .27,
                              child: Image.asset(
                                'assets/logo.jpg',
                                fit: BoxFit.fitWidth,
                              ))),
                      const Text(
                        'Welcome Back,\n',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 22),
                      ),
                      const Text(
                        '\nContinue with username for sign in',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w800),
                      ),
                    ])),
            SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.44),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextFormField(
                            // keyboardType: TextInputType.text,
                            style: const TextStyle(
                                color: Color(0xff4c505b),
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                            controller: _usernameController,
                            validator: username,
                            cursorColor: Colors.red.shade900,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Username",
                                // contentPadding: EdgeInsets.symmetric(
                                //   horizontal: 15,
                                // ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            // keyboardType: TextInputType.text,
                            style: const TextStyle(
                                color: Color(0xff4c505b),
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                            obscureText: seepwd,
                            controller: _passwordController,
                            validator: passwordValidator,
                            cursorColor: Colors.red.shade900,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Password",
                              // contentPadding: EdgeInsets.symmetric(
                              //     horizontal: 15, vertical: 2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                color: const Color.fromARGB(255, 2, 32, 71)
                                    .withOpacity(.6),
                                icon: Icon(
                                  seepwd
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    seepwd = !seepwd;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sign In',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white70,
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        loginUser(
                                                username:
                                                    _usernameController.text,
                                                password:
                                                    _passwordController.text)
                                            .then((value) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      } else {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    },
                                    icon: _isLoading
                                        ? Center(
                                            child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                Colors.blue.shade800,
                                              ),
                                            ),
                                          ))
                                        : Icon(
                                            Icons.arrow_forward,
                                            color: Colors.blue.shade800,
                                          )),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
            const Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Speack Cashless Mobility',
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> loginUser({String? username, String? password}) async {
    if (!(await checkNetworkConnectivity())) {
      Future.delayed(const Duration(seconds: 3), () {
        // Hide loading indicator
        setState(() {
          _isLoading = false;
        });
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          'No Internet Connection',
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 5),
        margin: EdgeInsets.only(
          // ignore: use_build_context_synchronously
          bottom: MediaQuery.of(context).size.height * 0.04,
          right: 15,
          left: 15,
        ),
        backgroundColor: Colors.red,
      ));

      // Return an empty list when there is no internet connection
      return [];
    }
    Map<String, dynamic> body = {"username": username, "password": password};
    var url = Uri.parse('$baseUrl/login');
    final postRequestResponse = await http.Client().post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body));
    // print(postRequestResponse.body);
    Map<String, dynamic> singingResponse = {
      'access_token': jsonDecode(postRequestResponse.body)['access_token']
    };
    if (postRequestResponse.statusCode == 200) {
      // var message = json.decode(postRequestResponse.body)['desc'];
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          'Logged in successfully',
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 1),
        margin: EdgeInsets.only(
            // ignore: use_build_context_synchronously
            bottom: MediaQuery.of(context).size.height * 0.04,
            right: 15,
            left: 15),
        backgroundColor: const Color(0xff4c505b),
      ));

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
      var jsonResponse = postRequestResponse.body;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt', jsonResponse);
      return singingResponse;
    } else if (postRequestResponse.statusCode != 200) {
      var message = json.decode(postRequestResponse.body)['message'];
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '$message',
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.only(
            // ignore: use_build_context_synchronously
            bottom: MediaQuery.of(context).size.height * 0.04,
            right: 15,
            left: 15),
        backgroundColor: Colors.red,
      ));
    }
  }
}
