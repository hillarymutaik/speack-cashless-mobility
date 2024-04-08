import 'dart:convert';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../home/Home.dart';
import '../utils/validators.dart';
import 'register_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State createState() => _SignInScreenState();
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _loginKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  bool seepwd = true;

//   // Future<bool> checkNetworkConnectivity() async {
//   //   var connectivityResult = await Connectivity().checkConnectivity();
//   //   return connectivityResult != ConnectivityResult.none;
//   // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
            child: Container(
                height: size.height,
                width: size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: size.height * 0.3,
                        width: size.height * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/logo.jpg',
                                ),
                                fit: BoxFit.cover)),
                      ),
                      Container(
                        height: size.height * 0.025,
                      ),
                      const Text(
                        'Welcome Back,\n',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 22),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Continue with phone number for sign in',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w800),
                                ),
                              ])),
                      Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _loginKey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black54,
                                            blurRadius: 35.0,
                                            offset: Offset(0, 0))
                                      ]),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 71, 178, 228),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                          controller: _usernameController,
                                          validator: phoneValidator,
                                          cursorColor: Colors.blue.shade900,
                                          decoration: InputDecoration(
                                              fillColor: Colors.grey.shade100,
                                              filled: true,
                                              hintText: "Phone number",
                                              contentPadding: EdgeInsets.all(
                                                15,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.text,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 71, 178, 228),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                          obscureText: seepwd,
                                          controller: _passwordController,
                                          validator: passwordValidator,
                                          cursorColor: Colors.blue.shade900,
                                          decoration: InputDecoration(
                                            fillColor: Colors.grey.shade100,
                                            filled: true,
                                            hintText: "Password",
                                            contentPadding: EdgeInsets.all(
                                              15,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            suffixIcon: IconButton(
                                              color: const Color.fromARGB(
                                                      255, 2, 32, 71)
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
                                      ])),
                              Container(
                                height: size.height * 0.025,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Sign In',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 71, 178, 228),
                                        fontSize: 23,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          if (_loginKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            loginUser(
                                                    username:
                                                        _usernameController
                                                            .text,
                                                    password:
                                                        _passwordController
                                                            .text)
                                                .then((value) {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Home()),
                                                  (route) => false);
                                            });
                                          } else {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          }
                                        },
                                        icon: _isLoading
                                            ? const Center(
                                                child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                    Colors.blue,
                                                  ),
                                                ),
                                              ))
                                            : const Icon(
                                                Icons.arrow_forward,
                                                color: Colors.blue,
                                              )),
                                  )
                                ],
                              ),
                              Container(
                                height: size.height * 0.05,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account ?",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Baloo2',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen()),
                                      );
                                    },
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 16,
                                          fontFamily: 'Baloo2',
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 71, 178, 228)),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                height: size.height * 0.05,
                              ),
                              const Center(
                                child: Text(
                                  'Speack Cashless Mobility',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white70,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ]))));
  }

  Future<dynamic> loginUser({String? username, String? password}) async {
    setState(() {
      _isLoading = true;
    });

    // if (!(await checkNetworkConnectivity())) {
    //   _scaffoldKey.currentState?.showSnackBar(
    //     SnackBar(
    //       content: const Text(
    //         'No Internet Connection',
    //         textAlign: TextAlign.center,
    //       ),
    //       behavior: SnackBarBehavior.floating,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //       duration: const Duration(seconds: 5),
    //       margin: EdgeInsets.only(
    //         bottom: MediaQuery.of(context).size.height * 0.04,
    //         right: 15,
    //         left: 15,
    //       ),
    //       backgroundColor: Colors.red,
    //     ),
    //   );

    //   setState(() {
    //     _isLoading = false;
    //   });
    //   return;
    // }

    Map<String, String> body = {
      "phoneNumber": username!,
      "password": password!
    };
    var url = Uri.parse('$baseUrl/auth/login');
    final postRequestResponse = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(body),
    );
    // print(postRequestResponse.body);

    Map<String, dynamic> singingResponse = {
      'token': jsonDecode(postRequestResponse.body)['token'],
    };
    if (postRequestResponse.statusCode == 200) {
      var jsonResponse = json.decode(postRequestResponse.body);
      var message = jsonResponse['data']['user']['fullName'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$message, you are logged in successfully',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 1),
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

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        (route) => false,
      );
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
        _isLoading = false;
      });
    }
    return singingResponse;
  }
}
