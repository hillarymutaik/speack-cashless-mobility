import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/validators.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static const routeName = 'search-screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchKey = GlobalKey<FormState>();

  bool _searchLoading = false;
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _regNoController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? tokenzz = "";
  String username = '';
  int? sellerId;
  String fullName = '';
  String email = '';
  void account() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenzz = prefs.getString('jwt')!;
    Map<String, dynamic> token = jsonDecode(tokenzz!);
    setState(() {
      username = '${token['user']['username']}';
      sellerId = int.parse(token['user']['id'].toString());
      fullName = '${token['user']['fullName']}';
      email = '${token['user']['email']}';
    });
  }

  @override
  void initState() {
    super.initState();
    account();
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
        backgroundColor: Colors.green.withOpacity(.7),
        // drawer: const SideMenu(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(
            size: 30,
            color: Colors.white, // Change the color to your desired color
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: const Text(
                'To check vehicle details, you are required to pay a handling fee',
                style: TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.18),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _searchKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 18),
                        child: Text(
                          'Enter search details below:',
                          style: TextStyle(
                              color: Colors.black87.withOpacity(0.5),
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            TextFormField(
                              style: const TextStyle(
                                  color: Color(0xff4c505b),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                              controller: _regNoController,
                              validator: regNoValidator,
                              cursorColor: Colors.red.shade900,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15),
                                  suffixIcon: Icon(
                                    Icons.app_registration_rounded,
                                    color: const Color.fromARGB(255, 2, 32, 71)
                                        .withOpacity(.6),
                                    size: 20,
                                  ),
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Registration number",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                  color: Color(0xff4c505b),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                              obscureText: false,
                              controller: _amountController,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Amount required';
                                }

                                if (double.tryParse(value) == null) {
                                  return 'Enter a valid number';
                                }

                                double minimumAmount =
                                    [1, 2, 3].contains(sellerId) ? 1.0 : 450.0;

                                if (double.parse(value) < minimumAmount) {
                                  return 'Minimum amount is KSH ${minimumAmount.toStringAsFixed(2)}';
                                }

                                return null; // Validation passed
                              },
                              cursorColor: Colors.red.shade900,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Enter amount",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.all(15),
                                suffixIcon: Icon(
                                  Icons.money_rounded,
                                  color: const Color.fromARGB(255, 2, 32, 71)
                                      .withOpacity(.6),
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                  color: Color(0xff4c505b),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                              obscureText: false,
                              controller: _phoneController,
                              validator: phoneValidator,
                              cursorColor: Colors.red.shade900,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "M-PESA number",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.all(15),
                                suffixIcon: Icon(
                                  Icons.phone_android_rounded,
                                  color: const Color.fromARGB(255, 2, 32, 71)
                                      .withOpacity(.6),
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Pay',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Color(0xff4c505b),
                                      fontWeight: FontWeight.w700),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color(0xff4c505b),
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        if (_searchKey.currentState!
                                            .validate()) {
                                          setState(() {
                                            _searchLoading = true;
                                          });
                                          createSearch(
                                                  registrationNo:
                                                      _regNoController.text,
                                                  amount: int.parse(
                                                      _amountController.text),
                                                  phoneNumber:
                                                      _phoneController.text)
                                              .then((value) {
                                            setState(() {
                                              _searchLoading = false;
                                            });
                                          });
                                        } else {
                                          setState(() {
                                            _searchLoading = false;
                                          });
                                        }
                                      },
                                      icon: _searchLoading
                                          ? const Center(
                                              child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                  Colors.white,
                                                ),
                                              ),
                                            ))
                                          : const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                            )),
                                )
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                            ),
                            GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => PaymentScreen(
                                  //               sellerId: sellerId!,
                                  //             )));
                                },
                                // radius: 20,
                                // backgroundColor: Colors.blue.shade900,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 12),
                                  decoration: const BoxDecoration(
                                      color: Color(0xff4c505b),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(6),
                                      )),
                                  child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.transparent,
                                        ),
                                        Text(
                                          'Check Payments',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.white,
                                        )
                                      ]),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: Text('Vehicle Search',
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: Color(0xff4c505b),
                        )))),
          ],
        ),
      ),
    );
  }

  Future<dynamic> createSearch({
    required String registrationNo,
    required int amount,
    required String phoneNumber,
  }) async {
    if (!(await checkNetworkConnectivity())) {
      Future.delayed(const Duration(seconds: 3), () {
        // Hide loading indicator
        setState(() {
          _searchLoading = false;
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

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwt = prefs.getString('jwt');
    Map<String, dynamic> token = jsonDecode(jwt!);
    Map<String, dynamic> body = {
      "registrationNo": registrationNo,
      "policyNo": 'N/A',
      "insuranceType": 'N/A',
      "insuredPerson": 'N/A',
      "insurer": 'N/A',
      "username": username,
      "amount": amount,
      "phoneNumber": phoneNumber,
    };
    var url = Uri.parse('$baseUrl/create_search_vehicle');
    final postRequestResponse = await http.Client().post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${token['access_token']}'
        },
        body: jsonEncode(body));
    // print(postRequestResponse.body);
    if (postRequestResponse.statusCode == 200) {
      // var message = json.decode(postRequestResponse.body)['message'];
      // var sellerId = json.decode(postRequestResponse.body)['id'];

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          'Search request successful. Wait to input M-PESA PIN for payment to proceed.',
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
            right: 10,
            left: 10),
        backgroundColor: const Color(0xff4c505b),
      ));
      // // ignore: use_build_context_synchronously
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => PaymentScreen(
      //               sellerId: sellerId!,
      //             )),
      //     (route) => true);
      // Navigator.of(context).pushReplacementNamed(SearchScreen.routeName);
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

      //Start a separate timer to check if 5 minutes have passed
      Timer(const Duration(minutes: 3), () async {
        // If 5 minutes have passed, navigate to SearchScreen
        // SharedPreferences prefs = await SharedPreferences.getInstance();

        // if (mounted) {
        //   prefs
        //       .remove('jwt')
        //       .then((value) => Navigator.pushAndRemoveUntil(
        //           context,
        //           MaterialPageRoute(builder: (context) => const SignInScreen()),
        //           (route) => false))
        //       .onError((error, stackTrace) =>
        //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //             content: Text('$error'),
        //           )));
        // }
      });
    }
  }
}
