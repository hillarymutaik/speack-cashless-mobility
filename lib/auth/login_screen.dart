import 'dart:async';
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
  Timer? _timer;
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _timer?.cancel();
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
        backgroundColor: Colors.lightBlueAccent,
        body: SingleChildScrollView(
            child: Container(
                height: size.height,
                width: size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/logo1.png',
                          height: size.height * .25,
                          width: size.width * .25,
                          fit: BoxFit.cover),
                      const Text(
                        'Welcome Back,',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 22),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 3),
                          child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Continue with phone number for sign in',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                ),
                              ])),
                      Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _loginKey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 35),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                                controller: _usernameController,
                                validator: phoneValidator,
                                cursorColor: Colors.blue.shade900,
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade200,
                                    filled: true,
                                    hintText: "Phone number",
                                    contentPadding: EdgeInsets.all(
                                      15,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                                obscureText: seepwd,
                                controller: _passwordController,
                                validator: passwordValidator,
                                cursorColor: Colors.blue.shade900,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  hintText: "Password",
                                  contentPadding: EdgeInsets.all(
                                    15,
                                  ),
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
                              Container(
                                height: size.height * 0.025,
                              ),
                              SizedBox(
                                  width: size.width * .85,
                                  height: size.height * 0.055,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_loginKey.currentState!.validate()) {
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
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Home()),
                                              (route) => false);
                                        });
                                      } else {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black87,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.all(
                                          2,
                                        )),
                                    child: _isLoading
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
                                        : const Text("Login",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Baloo2',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                  )),
                              Container(
                                height: size.height * 0.05,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account?",
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
                                                SignUpScreen()),
                                      );
                                    },
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(
                                          // decoration: TextDecoration.underline,
                                          fontSize: 16,
                                          fontFamily: 'Baloo2',
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 3, 12, 15)),
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
                      )
                    ]))));
  }

  Future<dynamic> loginUser({String? username, String? password}) async {
    setState(() {
      _isLoading = true;
    });

 
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
      // Start the timer in the initState method
      _timer = Timer(Duration(seconds: 1), () {
        // Check if the widget is still mounted before navigating
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
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
        _isLoading = false;
      });
    }
    return singingResponse;
  }
}
