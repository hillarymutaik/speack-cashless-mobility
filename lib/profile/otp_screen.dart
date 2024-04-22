import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colors_frave.dart';
import '../utils/validators.dart';
import 'change_pin.dart';
import 'set_wallet_pin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OTPPINScreen extends StatefulWidget {
  @override
  State<OTPPINScreen> createState() => _OTPPINScreenState();
}

class _OTPPINScreenState extends State<OTPPINScreen> {
  late TextEditingController _otpController;
  late TextEditingController _descController;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _otpController = TextEditingController();
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    clearTextEditingController();
    _otpController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void clearTextEditingController() {
    _otpController.clear();
    _descController.clear();
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
        title: const Text('OTP',
            style: TextStyle(fontSize: 18, color: Colors.lightBlueAccent)),
        centerTitle: true,
        leadingWidth: 70,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
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
                      backgroundColor:
                          Colors.lightBlueAccent, // Button background color

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Button border radius
                      )),
                  onPressed: () {
                    if (_keyForm.currentState!.validate()) {
                      setState(() {
                        _pinLoading = true;
                      });
                      otpWalletPin(
                              otpRefId: _otpController.text,
                              desc: _descController.text)
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
                          style: TextStyle(
                              fontSize: 16,
                              color: ColorsFrave.backgroundColor))))
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
                const Text('Enter OTP'),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _otpController,
                  style: TextStyle(
                      fontFamily: 'Baloo2', color: Colors.grey, fontSize: 18),
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: .5, color: Colors.grey)),
                    contentPadding: const EdgeInsets.only(left: 15.0),
                    hintText: '',
                    hintStyle:
                        TextStyle(fontFamily: 'Baloo2', color: Colors.grey),
                    // suffixIcon: IconButton(
                    //   color:
                    //       const Color.fromARGB(255, 2, 32, 71).withOpacity(.6),
                    //   icon: Icon(
                    //     curseepin ? Icons.visibility_off : Icons.visibility,
                    //     size: 20,
                    //   ),
                    //   onPressed: () {
                    //     setState(() {
                    //       curseepin = !curseepin;
                    //     });
                    //   },
                    // ),
                  ),
                  validator: pinValidator,
                ),
                const SizedBox(height: 20.0),
                const Text('Reason'),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _descController,
                  style: TextStyle(
                      fontFamily: 'Baloo2', color: Colors.grey, fontSize: 18),
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: .5, color: Colors.grey)),
                    contentPadding: const EdgeInsets.only(left: 15.0),
                    hintText: '',
                    hintStyle:
                        TextStyle(fontFamily: 'Baloo2', color: Colors.grey),
                    // suffixIcon: IconButton(
                    //   color:
                    //       const Color.fromARGB(255, 2, 32, 71).withOpacity(.6),
                    //   icon: Icon(
                    //     seepin ? Icons.visibility_off : Icons.visibility,
                    //     size: 20,
                    //   ),
                    //   onPressed: () {
                    //     setState(() {
                    //       seepin = !seepin;
                    //     });
                    //   },
                    // ),
                  ),
                  validator: pinValidator,
                ),
                Container(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have a  wallet PIN ?",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Baloo2',
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => SetWalletPinScreen()));
                      },
                      child: const Text(
                        "Set PIN",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 15,
                            fontFamily: 'Baloo2',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 17, 138, 194)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> otpWalletPin(
      {required String otpRefId, required String desc}) async {
    setState(() {
      _pinLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwt = prefs.getString('jwt');
    Map<String, dynamic> token = jsonDecode(jwt!);

    Map<String, String> body = {"otpRefId": otpRefId, "desc": desc};
    var url = Uri.parse('$baseUrl/security-pins/reset/otp');
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
      var otpRefId = jsonResponse['otpRefId'];
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
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.only(
            bottom: 10,
            right: 15,
            left: 15,
          ),
          backgroundColor: Color.fromARGB(255, 1, 145, 56),
        ),
      );
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => ChangePasswordScreen(otpRefId: otpRefId)));
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
