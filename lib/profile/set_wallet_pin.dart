import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speack_cashless_mobility/home/Home.dart';

import '../utils/validators.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// import 'otp_screen.dart';

class SetWalletPinScreen extends StatefulWidget {
  @override
  _SetWalletPinScreenState createState() => _SetWalletPinScreenState();
}

class _SetWalletPinScreenState extends State<SetWalletPinScreen> {
  late TextEditingController _newPasswordController;
  late TextEditingController _repeatPasswordController;

  final _setForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    clearTextEditingController();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void clearTextEditingController() {
    _newPasswordController.clear();
    _repeatPasswordController.clear();
  }

  bool seepin = true;
  bool reseepin = true;
  bool _setLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Set PIN',
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
                      backgroundColor:
                          Colors.lightBlueAccent, // Button background color
                      // padding: const EdgeInsets.all(
                      //     5.0), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Button border radius
                      )),
                  onPressed: () {
                    if (_setForm.currentState!.validate()) {
                      setState(() {
                        _setLoading = true;
                      });
                      setWalletPin(pin: _newPasswordController.text)
                          .then((value) {
                        setState(() {
                          _setLoading = false;
                        });
                      });
                    } else {
                      setState(() {
                        _setLoading = false;
                      });
                    }
                  },
                  child: Center(
                      child: _setLoading
                          ? SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text('Save',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white)))))
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _setForm,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                const Text('New PIN'),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _newPasswordController,
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
                const SizedBox(height: 20.0),
                const Text('Repeat PIN'),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _repeatPasswordController,
                  style: TextStyle(
                      fontFamily: 'Baloo2', color: Colors.grey, fontSize: 18),
                  obscureText: reseepin,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: .5, color: Colors.grey)),
                      contentPadding: const EdgeInsets.only(left: 15.0),
                      hintText: '****',
                      hintStyle:
                          TextStyle(fontFamily: 'Baloo2', color: Colors.grey),
                      suffixIcon: IconButton(
                        color: const Color.fromARGB(255, 2, 32, 71)
                            .withOpacity(.6),
                        icon: Icon(
                          reseepin ? Icons.visibility_off : Icons.visibility,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            reseepin = !reseepin;
                          });
                        },
                      )),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Repeat PIN is required';
                    } else if (val != _newPasswordController.text) {
                      return 'PINs do not match';
                    }
                    return null; // Return null if validation passes
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
    var url = Uri.parse('$baseUrl/security-pins');
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
      var message = jsonResponse["desc"];
      var status = jsonResponse["status"];

      if (status == "OK") {
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
          _setLoading = false;
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
}
