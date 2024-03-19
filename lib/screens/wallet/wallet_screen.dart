import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../home/home_screen.dart';

class WalletScreen extends StatefulWidget {
  // final String tokenRefId;
  // final String phone;
  // final int amount;

  // const WalletScreen({
  //   Key? key,
  //   required this.tokenRefId,
  //   required this.phone,
  //   required this.amount,
  // }) : super(key: key);

  @override
  State<WalletScreen> createState() => _WithdrawalOtpSreenState();
}

class _WithdrawalOtpSreenState extends State<WalletScreen> {
  late List<TextEditingController> otpControllers;
  final _withdrawKey = GlobalKey<FormState>();
  bool _isWithrawing = false;
  String username = '';
  String? token;
  @override
  void initState() {
    super.initState();
    // final authState = context.read<AuthBloc>().state;
    // username = authState.user?.username ?? '';

    // token = authState.token;
    otpControllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 2, 46, 99).withOpacity(0.1),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Navigator.canPop(context)
                        ? GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back,
                              size: 32,
                              color: const Color.fromARGB(255, 2, 46, 99)
                                  .withOpacity(0.9),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color:
                          const Color.fromARGB(255, 2, 46, 99).withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/logo.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    'Withdrawal Verification',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Enter your Withdrawal OTP code number",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _withdrawKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                otpControllers.length,
                                (index) => Expanded(
                                  child: _textFieldOTP(
                                    first: index == 0,
                                    last: index == otpControllers.length - 1,
                                    controller: otpControllers[index],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isWithrawing = true;
                                    });
                                    if (_withdrawKey.currentState!.validate()) {
                                      withdrawRequest().then((value) {
                                        setState(() {
                                          _isWithrawing = false;
                                        });
                                      });
                                      setState(() {
                                        _isWithrawing = true;
                                      });
                                    } else {
                                      setState(() {
                                        _isWithrawing = false;
                                      });
                                    }
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      const Color.fromARGB(255, 2, 46, 99)
                                          .withOpacity(0.9),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                      child: _isWithrawing
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                  Colors.white,
                                                ),
                                              ),
                                            )
                                          : const Text(
                                              'Withdraw',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ))),
                            )
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Didn't you receive any code?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Resend New Code",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 2, 46, 99),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Widget _textFieldOTP(
      {required bool first,
      required bool last,
      required TextEditingController controller}) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          controller: controller,
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 2, 46, 99),
          ),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.black12),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 2, color: Color.fromARGB(255, 2, 46, 99)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> withdrawRequest() async {
    String otp = otpControllers.map((controller) => controller.text).join('');
    // Map<String, dynamic> body = {"otp": otp, "otpRefId": widget.tokenRefId};
    Map<String, dynamic> body = {
      "fleetNumber": username,
      "amount": 'widget.amount',
      "phoneNumber": 'widget.phone',
      "otp": otp,
      "otpRefId": ''
    };

    var url = Uri.parse('/b2c/make-payments');
    final postRequestResponse = await http.Client().post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(body));

    // print('Withdrawal Response::: ${postRequestResponse.body}');

    if (postRequestResponse.statusCode == 200) {
      var message = json.decode(postRequestResponse.body)['desc'];
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
          backgroundColor: Colors.green));
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
          (route) => false);
    } else if (postRequestResponse.statusCode == 400) {
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
