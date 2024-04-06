// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../utils/validators.dart';
import '../transactions.dart';

class CommissionScreen extends StatefulWidget {
  @override
  State createState() => _CommissionScreenState();
}

class _CommissionScreenState extends State<CommissionScreen> {
  Map<String, dynamic>? _walletData;

  @override
  void initState() {
    super.initState();
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/wallet.json');
      Map<String, dynamic> data = jsonDecode(jsonString);
      setState(() {
        _walletData = data['wallets'][0]; // Fetching the first wallet only
      });
    } catch (e) {
      // print("Error retrieving wallets data: $e");
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

  String? _selectedPhoneNumber;

  final List<String> _phoneNumbers = [
    '0727918955',
    '0796010105',
    '0720202020',
  ];

  Future<void> _openConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Withdrawal'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Dear customer, note the minimum withdrawal amount is Kshs 100.00 from your wallet.'),
              ],
            ),
          ),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Center(
                        child: Text(
                            ' Dear [customer name] you have cancelled your withdrawal of ksh. [Amount] thank you for using speack cashless mobility.'),
                      ),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.red[400], // Set background color
                    ),
                  );
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
                  Navigator.of(context).pop(); // Close dialog
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
                child: const Text('OK'),
              ),
            ])
          ],
        );
      },
    );
  }

  void _processTransaction() {
    setState(() {
      _isRequesting = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Center(
          child: Text(
              'Dear [customer name], you have successfully initiated a withdrawal of ksh. [amount] from your wallet. Please wait for a confirmation message as we process your request.'),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.green[400], // Set background color
      ),
    );
    // Perform your transaction processing here
    // Once done, navigate to the next screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransactionsScreen()),
    ).then((_) {
      setState(() {
        _isRequesting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text('Commission',
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
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Container(
                          // height: MediaQuery.of(context).size.height * .1,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 10,
                                  offset: Offset(0, 0)),
                            ],
                          ),
                          margin: const EdgeInsets.only(bottom: 70),
                          padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 15,
                              bottom: MediaQuery.of(context).size.height * .08),
                          child: Container(
                              // height: MediaQuery.of(context).size.height * .16,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Commission:',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              'KSH ${_walletData != null ? _walletData!['currentBalance'] : 'N/A'}',
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
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ])),
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (ctx) => FleetNumbersScreen()));
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height * .12,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 20,
                                        offset: Offset(0, 0))
                                  ]),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Commission:',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              'KSH ${_walletData != null ? _walletData!['currentBalance'] : 'N/A'}',
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
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ])),
                        ),
                      ],
                    ),
                    // Container(
                    //     constraints: const BoxConstraints(maxWidth: 500),
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 20, vertical: 30),
                    //     margin: const EdgeInsets.symmetric(
                    //         horizontal: 10, vertical: 10),
                    //     decoration: const BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.all(Radius.circular(15)),
                    //       boxShadow: [
                    //         BoxShadow(
                    //             color: Colors.grey,
                    //             blurRadius: 5,
                    //             offset: Offset(0, 0)),
                    //       ],
                    //     ),
                    //     child: Column(children: [
                    //       RichText(
                    //         textAlign: TextAlign.center,
                    //         text: TextSpan(children: <TextSpan>[
                    //           const TextSpan(
                    //             text: 'We will send you a ',
                    //             style: TextStyle(
                    //               color: Colors.black38,
                    //               fontSize: 15,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //           TextSpan(
                    //               text: 'One Time Password ',
                    //               style: TextStyle(
                    //                   color: Colors.blue.shade900,
                    //                   fontSize: 18,
                    //                   fontWeight: FontWeight.bold)),
                    //           const TextSpan(
                    //             text: 'to your phone number',
                    //             style: TextStyle(
                    //               color: Colors.black38,
                    //               fontSize: 15,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ]),
                    //       ),
                    //       const SizedBox(
                    //         height: 25,
                    //       ),
                    //       Form(
                    //         autovalidateMode:
                    //             AutovalidateMode.onUserInteraction,
                    //         key: _walletKey,
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Container(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 3, vertical: 3),
                    //                 decoration: BoxDecoration(
                    //                     color: Colors.grey.shade200,
                    //                     borderRadius: BorderRadius.circular(10),
                    //                     boxShadow: const [
                    //                       BoxShadow(
                    //                           color: Colors.white,
                    //                           blurRadius: 20,
                    //                           offset: Offset(0, 0))
                    //                     ]),
                    //                 child: Center(
                    //                     child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   children: [
                    //                     Radio(
                    //                       value: false,
                    //                       groupValue: _enterPhoneNumberManually,
                    //                       onChanged: (bool? value) {
                    //                         setState(() {
                    //                           _enterPhoneNumberManually = false;
                    //                           _selectedPhoneNumber =
                    //                               null; // Reset selected number
                    //                         });
                    //                       },
                    //                     ),
                    //                     const Text('Select Phone'),
                    //                     Radio(
                    //                       value: true,
                    //                       groupValue: _enterPhoneNumberManually,
                    //                       onChanged: (bool? value) {
                    //                         setState(() {
                    //                           _enterPhoneNumberManually = true;
                    //                           _selectedPhoneNumber =
                    //                               null; // Reset selected number
                    //                         });
                    //                       },
                    //                     ),
                    //                     const Text('Enter Phone'),
                    //                   ],
                    //                 ))),
                    //             const SizedBox(height: 15.0),
                    //             _enterPhoneNumberManually
                    //                 ? TextFormField(
                    //                     keyboardType: TextInputType.number,
                    //                     style: const TextStyle(
                    //                         fontWeight: FontWeight.normal,
                    //                         color:
                    //                             Color.fromARGB(255, 2, 32, 71),
                    //                         fontSize: 14),
                    //                     controller: _phoneController,
                    //                     validator: phoneValidator,
                    //                     cursorColor: Colors.blueGrey,
                    //                     decoration: InputDecoration(
                    //                       contentPadding:
                    //                           const EdgeInsets.all(3),
                    //                       border: const OutlineInputBorder(
                    //                         borderRadius: BorderRadius.all(
                    //                             Radius.circular(10)),
                    //                         borderSide: BorderSide(
                    //                             color: Colors.blueGrey),
                    //                       ),
                    //                       fillColor:
                    //                           Colors.grey.withOpacity(0.15),
                    //                       filled: true,
                    //                       hintText: 'Enter phone number',
                    //                       hintStyle:
                    //                           const TextStyle(fontSize: 12),
                    //                       floatingLabelBehavior:
                    //                           FloatingLabelBehavior.always,
                    //                       prefixIcon: Icon(
                    //                         Icons.phone_android,
                    //                         color: const Color.fromARGB(
                    //                                 255, 2, 32, 71)
                    //                             .withOpacity(0.6),
                    //                       ),
                    //                       suffix:
                    //                           ((_phoneController.text).length ==
                    //                                   10)
                    //                               ? const Icon(
                    //                                   Icons.check_circle,
                    //                                   color: Colors.green,
                    //                                   // size: 25,
                    //                                 )
                    //                               : null,
                    //                       focusedBorder:
                    //                           const OutlineInputBorder(
                    //                         borderRadius: BorderRadius.all(
                    //                             Radius.circular(10)),
                    //                         borderSide: BorderSide(
                    //                           color: Colors.blueGrey,
                    //                           width: .05,
                    //                         ),
                    //                       ),
                    //                       enabledBorder:
                    //                           const OutlineInputBorder(
                    //                         borderRadius: BorderRadius.all(
                    //                             Radius.circular(10)),
                    //                         borderSide: BorderSide(
                    //                           color: Colors.blueGrey,
                    //                           width: .05,
                    //                         ),
                    //                       ),
                    //                     ))
                    //                 : DropdownButtonFormField<String>(
                    //                     value:
                    //                         _selectedPhoneNumber, // Store the selected phone number
                    //                     onChanged: (String? newValue) {
                    //                       setState(() {
                    //                         _selectedPhoneNumber = newValue!;
                    //                       });
                    //                     },
                    //                     items: _phoneNumbers
                    //                         .map<DropdownMenuItem<String>>(
                    //                             (String value) {
                    //                       return DropdownMenuItem<String>(
                    //                         value: value,
                    //                         child: Text(value,
                    //                             textAlign: TextAlign.center),
                    //                       );
                    //                     }).toList(),
                    //                     decoration: InputDecoration(
                    //                       contentPadding:
                    //                           const EdgeInsets.all(3),
                    //                       border: const OutlineInputBorder(
                    //                         borderRadius: BorderRadius.all(
                    //                             Radius.circular(10)),
                    //                         borderSide: BorderSide(
                    //                             color: Colors.blueGrey),
                    //                       ),
                    //                       fillColor:
                    //                           Colors.grey.withOpacity(0.15),
                    //                       filled: true,
                    //                       hintText: 'Select phone number',
                    //                       hintStyle:
                    //                           const TextStyle(fontSize: 12),
                    //                       floatingLabelBehavior:
                    //                           FloatingLabelBehavior.always,
                    //                       prefixIcon: Icon(
                    //                         Icons.phone_android,
                    //                         color: const Color.fromARGB(
                    //                                 255, 2, 32, 71)
                    //                             .withOpacity(0.6),
                    //                       ),
                    //                       suffixIcon: _selectedPhoneNumber !=
                    //                               null
                    //                           ? const Icon(Icons.check_circle,
                    //                               color: Colors.green)
                    //                           : null,
                    //                       focusedBorder:
                    //                           const OutlineInputBorder(
                    //                         borderRadius: BorderRadius.all(
                    //                             Radius.circular(10)),
                    //                         borderSide: BorderSide(
                    //                           color: Colors.blueGrey,
                    //                           width: .05,
                    //                         ),
                    //                       ),
                    //                       enabledBorder:
                    //                           const OutlineInputBorder(
                    //                         borderRadius: BorderRadius.all(
                    //                             Radius.circular(10)),
                    //                         borderSide: BorderSide(
                    //                           color: Colors.blueGrey,
                    //                           width: .05,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //             const SizedBox(
                    //               height: 15,
                    //             ),
                    //             SizedBox(
                    //                 height: MediaQuery.of(context).size.height *
                    //                     0.005),
                    //             TextFormField(
                    //                 keyboardType: TextInputType.number,
                    //                 style: const TextStyle(
                    //                     fontWeight: FontWeight.normal,
                    //                     color: Color.fromARGB(255, 2, 32, 71),
                    //                     fontSize: 14),
                    //                 controller: _amountController,
                    //                 validator: amountValidator,
                    //                 cursorColor: Colors.blueGrey,
                    //                 decoration: InputDecoration(
                    //                   contentPadding: const EdgeInsets.all(3),
                    //                   border: const OutlineInputBorder(
                    //                     borderRadius: BorderRadius.all(
                    //                         Radius.circular(10)),
                    //                     borderSide:
                    //                         BorderSide(color: Colors.blueGrey),
                    //                   ),
                    //                   fillColor: Colors.grey.withOpacity(0.15),
                    //                   filled: true,
                    //                   hintText: 'Enter amount',
                    //                   hintStyle: const TextStyle(fontSize: 12),
                    //                   floatingLabelBehavior:
                    //                       FloatingLabelBehavior.always,
                    //                   prefixIcon: Icon(
                    //                     Icons.money_rounded,
                    //                     color:
                    //                         const Color.fromARGB(255, 2, 32, 71)
                    //                             .withOpacity(0.6),
                    //                   ),
                    //                   focusedBorder: const OutlineInputBorder(
                    //                     borderRadius: BorderRadius.all(
                    //                         Radius.circular(10)),
                    //                     borderSide: BorderSide(
                    //                       color: Colors.blueGrey,
                    //                       width: .05,
                    //                     ),
                    //                   ),
                    //                   enabledBorder: const OutlineInputBorder(
                    //                     borderRadius: BorderRadius.all(
                    //                         Radius.circular(10)),
                    //                     borderSide: BorderSide(
                    //                       color: Colors.blueGrey,
                    //                       width: .05,
                    //                     ),
                    //                   ),
                    //                 )),
                    //             const SizedBox(
                    //               height: 36,
                    //             ),
                    //             Row(children: [
                    //               Expanded(
                    //                   child: GestureDetector(
                    //                       onTap: () async {
                    //                         setState(() {
                    //                           _isRequesting = true;
                    //                         });
                    //                         if (_walletKey.currentState!
                    //                             .validate()) {
                    //                           // Navigator.push(
                    //                           //     context,
                    //                           //     MaterialPageRoute(
                    //                           //         builder: (ctx) =>
                    //                           //             TransactionsScreen()));
                    //                           // walletOTPRequest(
                    //                           //         int.parse(
                    //                           //             _amountController
                    //                           //                 .text),
                    //                           //         _phoneController.text)
                    //                           //     .then((value) {
                    //                           //   setState(() {
                    //                           //     _isRequesting = false;
                    //                           //   });
                    //                           // });
                    //                           _openConfirmationDialog();
                    //                           setState(() {
                    //                             _isRequesting = false;
                    //                           });
                    //                         } else {
                    //                           setState(() {
                    //                             _isRequesting = false;
                    //                           });
                    //                         }
                    //                         // Navigator.push(
                    //                         //     context,
                    //                         //     MaterialPageRoute(
                    //                         //         builder: (ctx) => TransactionsScreen()));
                    //                       },
                    //                       child: Container(
                    //                         padding: const EdgeInsets.symmetric(
                    //                             horizontal: 15, vertical: 12),
                    //                         decoration: BoxDecoration(
                    //                             color: Colors.blue,
                    //                             borderRadius:
                    //                                 BorderRadius.circular(10),
                    //                             boxShadow: [
                    //                               BoxShadow(
                    //                                   color:
                    //                                       Colors.grey.shade400,
                    //                                   blurRadius: 10,
                    //                                   offset: Offset(0, 0))
                    //                             ]),
                    //                         child: Center(
                    //                             child: _isRequesting
                    //                                 ? const SizedBox(
                    //                                     height: 20,
                    //                                     width: 20,
                    //                                     child:
                    //                                         CircularProgressIndicator(
                    //                                       strokeWidth: 2.0,
                    //                                       valueColor:
                    //                                           AlwaysStoppedAnimation(
                    //                                         Colors.white,
                    //                                       ),
                    //                                     ))
                    //                                 : const Row(
                    //                                     mainAxisAlignment:
                    //                                         MainAxisAlignment
                    //                                             .spaceBetween,
                    //                                     crossAxisAlignment:
                    //                                         CrossAxisAlignment
                    //                                             .center,
                    //                                     children: [
                    //                                         Icon(
                    //                                           Icons
                    //                                               .arrow_forward_rounded,
                    //                                           color: Colors
                    //                                               .transparent,
                    //                                         ),
                    //                                         Text("Withdraw",
                    //                                             style:
                    //                                                 TextStyle(
                    //                                               fontSize: 15,
                    //                                               fontWeight:
                    //                                                   FontWeight
                    //                                                       .bold,
                    //                                               color: Colors
                    //                                                   .white,
                    //                                             )),
                    //                                         Icon(
                    //                                           Icons
                    //                                               .arrow_forward_rounded,
                    //                                           color:
                    //                                               Colors.white,
                    //                                         )
                    //                                       ])),
                    //                       )))
                    //             ])
                    //           ],
                    //         ),
                    //       ),
                    //     ])),
                  ]))),
    );
  }
}
