// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/Home.dart';
import '../../utils/validators.dart';
import 'package:http/http.dart' as http;

class WalletScreen extends StatefulWidget {
  @override
  State createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletScreen> {
  Map<String, dynamic>? _walletData;

  String? _selectedPhoneNumber;

  String? tokenzz;
  String? fullName;

  void account() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenzz = prefs.getString('jwt')!;
    Map<String, dynamic> token = jsonDecode(tokenzz!);
    setState(() {
      _selectedPhoneNumber = '${token['data']['user']['phoneNumber']}';
      fullName = '${token['data']['user']['fullName']}';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadWalletData();
    account();
  }

  Future<void> _loadWalletData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? jwt = prefs.getString('jwt');
      Map<String, dynamic> token = jsonDecode(jwt!);

      final http.Response response = await http.get(
        Uri.parse('$baseUrl/accounts/wallet'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${token['data']['token']}'
        },
      );

      print("Wallet::: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _walletData = data; // Fetching the first wallet only
        });
      } else {
        throw Exception('Failed to load wallet data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors
      print("Error retrieving wallet data: $e");
    }
  }

  final _walletKey = GlobalKey<FormState>();
  bool _isRequesting = false;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
    _phoneController.dispose();
  }

  // Future<bool> checkNetworkConnectivity() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   return connectivityResult != ConnectivityResult.none;
  // }

  String formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return 'N/A';
    }
    DateTime dateTime = DateTime.tryParse(dateTimeString) ?? DateTime.now();
    DateFormat formatter = DateFormat('h:mm a d MMM y');
    return formatter.format(dateTime);
  }

  bool _enterPhoneNumberManually = false;

  final List<String> _phoneNumbers = [];

  Future<void> _openConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Withdrawal'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Dear $fullName, note the minimum withdrawal amount is Kshs 100.00 from your wallet.'),
              ],
            ),
          ),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigator.of(context).pop(); // Close dialog

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text(
                            ' Dear $fullName you have cancelled your withdrawal of KES ${_amountController.text} thank you for using speack cashless mobility.'),
                      ),
                      duration: const Duration(seconds: 5),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      backgroundColor: Colors.red[400], // Set background color
                    ),
                  );

                  Future.delayed(const Duration(seconds: 5), () {
                    Navigator.pushAndRemoveUntil<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => Home(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.grey.shade300), // Set background color

                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.red.shade300), // Set text color
                  textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(fontSize: 16)), // Set text size
                ),
                child: const Text('Cancel'),
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _processTransaction(); // Process transaction
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.grey.shade300), // Set background color

                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue.shade400), // Set text color
                  textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(fontSize: 16)), // Set text size
                ),
                child: Text('OK'),
              ),
            ])
          ],
        );
      },
    );
  }

  void _processTransaction() {
    setState(() {
      _isRequesting = false;
    });

    // Perform your transaction processing here
    // Once done, navigate to the next screen
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Dear $fullName, you have successfully initiated a withdrawal of KES ${_amountController.text} from your wallet. Please wait for a confirmation message as we process your request.',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => Home(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.grey.shade300), // Set background color

                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue.shade400), // Set text color
                  textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(fontSize: 16)), // Set text size
                ),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text('OK')),
              ),
            ])
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedPhoneNumber != null) {
      _phoneNumbers.addAll([_selectedPhoneNumber!]);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text('Wallet',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
      ),
      body: SingleChildScrollView(
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // height: MediaQuery.of(context).size.height * .1,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              blurRadius: 10,
                              offset: Offset(0, 0)),
                        ],
                      ),
                      padding: EdgeInsets.all(
                        20,
                      ),
                      child: Container(
                          // height: MediaQuery.of(context).size.height * .16,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.transparent,
                                    blurRadius: 20,
                                    offset: Offset(0, 0))
                              ]),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          'Fleet No: ${_walletData != null ? _walletData!['vehicleId'] : 'N/A'}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Balance:',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          'KES ${_walletData != null ? _walletData!['currentBalance'] : 'N/A'}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Last Updated: ',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          formatDateTime(
                                              '${_walletData != null ? _walletData!['lastUpdatedAt'] : ''}'),
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                              ])),
                    ),
                    Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                offset: Offset(0, 0)),
                          ],
                        ),
                        child: Column(children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              const TextSpan(
                                text: 'We will send you a ',
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                  text: 'One Time Password ',
                                  style: TextStyle(
                                      color: Colors.lightBlueAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const TextSpan(
                                text: 'to your phone number',
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Form(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            key: _walletKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3, vertical: 3),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 20,
                                              offset: Offset(0, 0))
                                        ]),
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Radio(
                                          value: false,
                                          groupValue: _enterPhoneNumberManually,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _enterPhoneNumberManually = false;
                                              _selectedPhoneNumber =
                                                  null; // Reset selected number
                                            });
                                          },
                                        ),
                                        const Text('Select Phone'),
                                        Radio(
                                          value: true,
                                          groupValue: _enterPhoneNumberManually,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _enterPhoneNumberManually = true;
                                              _selectedPhoneNumber =
                                                  null; // Reset selected number
                                            });
                                          },
                                        ),
                                        const Text('Enter Phone'),
                                      ],
                                    ))),
                                const SizedBox(height: 15.0),
                                _enterPhoneNumberManually
                                    ? TextFormField(
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color:
                                                Color.fromARGB(255, 2, 32, 71),
                                            fontSize: 14),
                                        controller: _phoneController,
                                        validator: phoneValidator,
                                        cursorColor: Colors.blueGrey,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(3),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey),
                                          ),
                                          fillColor:
                                              Colors.grey.withOpacity(0.15),
                                          filled: true,
                                          hintText: 'Enter phone number',
                                          hintStyle:
                                              const TextStyle(fontSize: 12),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          prefixIcon: Icon(
                                            Icons.phone_android,
                                            color: const Color.fromARGB(
                                                    255, 2, 32, 71)
                                                .withOpacity(0.6),
                                          ),
                                          suffix: ((_phoneController.text)
                                                      .length ==
                                                  10)
                                              ? const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.lightBlueAccent,
                                                  // size: 25,
                                                )
                                              : null,
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                              color: Colors.blueGrey,
                                              width: .05,
                                            ),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                              color: Colors.blueGrey,
                                              width: .05,
                                            ),
                                          ),
                                        ))
                                    : DropdownButtonFormField<String>(
                                        value:
                                            _selectedPhoneNumber, // Store the selected phone number
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedPhoneNumber = newValue!;
                                          });
                                        },

                                        items: _phoneNumbers
                                            .toSet() // Convert to a set to remove duplicates
                                            .map<DropdownMenuItem<String>>(
                                          (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value,
                                                  textAlign: TextAlign.center),
                                            );
                                          },
                                        ).toList(),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(3),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey),
                                          ),
                                          fillColor:
                                              Colors.grey.withOpacity(0.15),
                                          filled: true,
                                          hintText: 'Select phone number',
                                          hintStyle:
                                              const TextStyle(fontSize: 12),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          prefixIcon: Icon(
                                            Icons.phone_android,
                                            color: const Color.fromARGB(
                                                    255, 2, 32, 71)
                                                .withOpacity(0.6),
                                          ),
                                          suffixIcon: _selectedPhoneNumber !=
                                                  null
                                              ? const Icon(Icons.check_circle,
                                                  color: Colors.lightBlueAccent)
                                              : null,
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                              color: Colors.blueGrey,
                                              width: .05,
                                            ),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                              color: Colors.blueGrey,
                                              width: .05,
                                            ),
                                          ),
                                        ),
                                      ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.005),
                                TextFormField(
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromARGB(255, 2, 32, 71),
                                        fontSize: 14),
                                    controller: _amountController,
                                    validator: amountValidator,
                                    cursorColor: Colors.blueGrey,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(3),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide:
                                            BorderSide(color: Colors.blueGrey),
                                      ),
                                      fillColor: Colors.grey.withOpacity(0.15),
                                      filled: true,
                                      hintText: 'Enter amount',
                                      hintStyle: const TextStyle(fontSize: 12),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      prefixIcon: Icon(
                                        Icons.money_rounded,
                                        color:
                                            const Color.fromARGB(255, 2, 32, 71)
                                                .withOpacity(0.6),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: Colors.blueGrey,
                                          width: .05,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: Colors.blueGrey,
                                          width: .05,
                                        ),
                                      ),
                                    )),
                                const SizedBox(
                                  height: 36,
                                ),
                                Row(children: [
                                  Expanded(
                                      child: GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              _isRequesting = true;
                                            });
                                            if (_walletKey.currentState!
                                                .validate()) {
                                              _openConfirmationDialog();
                                              setState(() {
                                                _isRequesting = false;
                                              });
                                            } else {
                                              setState(() {
                                                _isRequesting = false;
                                              });
                                            }
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (ctx) => TransactionsScreen()));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 12),
                                            decoration: BoxDecoration(
                                                color: Colors.lightBlueAccent,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color:
                                                          Colors.grey.shade400,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 0))
                                                ]),
                                            child: Center(
                                                child: _isRequesting
                                                    ? const SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2.0,
                                                          valueColor:
                                                              AlwaysStoppedAnimation(
                                                            Colors.white,
                                                          ),
                                                        ))
                                                    : const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward_rounded,
                                                              color: Colors
                                                                  .transparent,
                                                            ),
                                                            Text("Withdraw",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward_rounded,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          ])),
                                          )))
                                ])
                              ],
                            ),
                          ),
                        ])),
                  ]))),
    );
  }
}
  // Future<BalanceModel> getWalletBalance() async {
  //   // Check for network connectivity
  //   if (!(await checkNetworkConnectivity())) {
  //     // Handle no network connectivity
  //     // ignore: use_build_context_synchronously
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: const Text(
  //         'No Internet Connection',
  //         textAlign: TextAlign.center,
  //       ),
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       duration: const Duration(seconds: 3),
  //       margin: EdgeInsets.only(
  //           // ignore: use_build_context_synchronously
  //           bottom: MediaQuery.of(context).size.height * 0.04,
  //           right: 15,
  //           left: 15),
  //       backgroundColor: Colors.red,
  //     ));

  //     throw Exception('No Internet Connection');
  //   }
  //   // Proceed with the HTTP request if there is network connectivity
  //   final http.Response response = await http.get(
  //     Uri.parse(
  //       "${Constants.walletUrl}/wallets?fleetNumber=$username",
  //     ),
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     var responseBody = json.decode(response.body);
  //     return BalanceModel.fromJson(responseBody);
  //   } else {
  //     throw Exception('Failed to load vehicle balance');
  //   }
  // }


