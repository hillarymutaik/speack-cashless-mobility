import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/Home.dart';
import '../utils/validators.dart';
// import 'set_wallet_pin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  final String otpRefId;

  const ChangePasswordScreen({super.key, required this.otpRefId});
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late TextEditingController _pinController;
  late TextEditingController _otpController;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _pinController = TextEditingController();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    clearTextEditingController();
    _pinController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void clearTextEditingController() {
    _pinController.clear();
    _otpController.clear();
  }

  bool curseepin = true;
  bool seepin = true;
  bool reseepin = true;
  bool _pinLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Re-set PIN',
            style: TextStyle(fontSize: 18, color: Colors.lightBlueAccent)),
        centerTitle: true,
        leadingWidth: 70,
        leading: InkWell(
          onTap: () => Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => Home()),
              (Route<dynamic> route) => false),
          child: Row(
            children: const [
              SizedBox(width: 20.0),
              Text('Cancel',
                  style: TextStyle(fontSize: 15, color: Colors.lightBlueAccent))
            ],
          ),
        ),
        actions: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Button border radius
                      )),
                  onPressed: () {
                    if (_keyForm.currentState!.validate()) {
                      setState(() {
                        _pinLoading = true;
                      });
                      changeWalletPin(
                              pin: _pinController.text,
                              otp: _otpController.text)
                          .then((value) {
                        setState(() {
                          _pinLoading = false;
                        });
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ProfileScreen()),
                        //     (route) => false);
                      });
                    } else {
                      setState(() {
                        _pinLoading = false;
                      });
                    }
                  },
                  child: _pinLoading
                      ? const Center(
                          child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(
                              Colors.white,
                            ),
                          ),
                        ))
                      : Text('Save',
                          style: TextStyle(fontSize: 15, color: Colors.white))))
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _keyForm,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                const Text('PIN'),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _pinController,
                  style: TextStyle(
                      fontFamily: 'Baloo2', color: Colors.grey, fontSize: 18),
                  obscureText: curseepin,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: .5, color: Colors.grey)),
                    contentPadding: const EdgeInsets.only(left: 15.0),
                    hintText: '****',
                    hintStyle:
                        TextStyle(fontFamily: 'Baloo2', color: Colors.grey),
                    suffixIcon: IconButton(
                      color:
                          const Color.fromARGB(255, 2, 32, 71).withOpacity(.6),
                      icon: Icon(
                        curseepin ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          curseepin = !curseepin;
                        });
                      },
                    ),
                  ),
                  validator: pinValidator,
                ),
                const SizedBox(height: 20.0),
                const Text('OTP'),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _otpController,
                  style: TextStyle(
                      fontFamily: 'Baloo2', color: Colors.grey, fontSize: 18),
                  obscureText: seepin,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: .5, color: Colors.grey)),
                    contentPadding: const EdgeInsets.only(left: 15.0),
                    hintText: '****',
                    hintStyle:
                        TextStyle(fontFamily: 'Baloo2', color: Colors.grey),
                    suffixIcon: IconButton(
                      color:
                          const Color.fromARGB(255, 2, 32, 71).withOpacity(.6),
                      icon: Icon(
                        seepin ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          seepin = !seepin;
                        });
                      },
                    ),
                  ),
                  validator: pinValidator,
                ),
                // Container(
                //   height: 30,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text(
                //       "Don't have a  wallet PIN ?",
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
                //                 builder: (ctx) => SetWalletPinScreen()));
                //       },
                //       child: const Text(
                //         "Set PIN",
                //         style: TextStyle(
                //             decoration: TextDecoration.underline,
                //             fontSize: 15,
                //             fontFamily: 'Baloo2',
                //             fontWeight: FontWeight.bold,
                //             color: Color.fromARGB(255, 17, 138, 194)),
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changeWalletPin(
      {required String pin, required String otp}) async {
    setState(() {
      _pinLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwt = prefs.getString('jwt');
    Map<String, dynamic> token = jsonDecode(jwt!);

    Map<String, String> body = {
      "pin": pin,
      "otp": otp,
      "otpRefId": widget.otpRefId
    };
    var url = Uri.parse('$baseUrl/security-pins/reset');
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

      if (status == 'Ok') {
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
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.only(
              bottom: 10,
              right: 15,
              left: 15,
            ),
            backgroundColor: Color.fromARGB(255, 1, 145, 56),
          ),
        );
        Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(builder: (BuildContext context) => Home()),
            (Route<dynamic> route) => false);
      } else {
        var message = jsonResponse['desc'];

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
          _pinLoading = false;
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
        _pinLoading = false;
      });
    }
  }
}
