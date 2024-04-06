import 'dart:async';
import 'dart:convert';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/fleet_screen.dart';
// import '../screens/pins.dart';
import '../screens/side_menu.dart';
import '../screens/transactions.dart';
import '../screens/vehicles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<HomeScreen> {
  // bool _searchLoading = false;
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

  // String? tokenzz = "";
  // String username = '';
  // int? sellerId;
  // String fullName = '';
  // String email = '';
  // void account() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   tokenzz = prefs.getString('jwt')!;
  //   Map<String, dynamic> token = jsonDecode(tokenzz!);
  //   setState(() {
  //     username = '${token['user']['username']}';
  //     sellerId = int.parse(token['user']['id'].toString());
  //     fullName = '${token['user']['fullName']}';
  //     email = '${token['user']['email']}';
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // account();
    // loadData();
  }

  // Future<bool> checkNetworkConnectivity() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   return connectivityResult != ConnectivityResult.none;
  // }
  // Map<String, dynamic> _data = {};
  // Future<void> loadData() async {
  //   try {
  //     String jsonString = await rootBundle.loadString('assets/data.json');
  //     Map<String, dynamic> data = jsonDecode(jsonString);
  //     setState(() {
  //       _data = data;
  //     });
  //   } catch (e) {
  //     print("Error retrieving data: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SideMenu(),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * .18,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              blurRadius: 5,
                              offset: Offset(2, 2)),
                        ],
                      ),
                      margin: const EdgeInsets.only(bottom: 70),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 80),
                        child: const Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Good afternoon,',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16, // Adjust the font size as needed
                                fontWeight:
                                    FontWeight.bold, // Optionally, make it bold
                              ),
                            ),
                            Text(
                              'Hillary',
                              style: TextStyle(
                                fontSize: 18, // Adjust the font size as needed
                                fontWeight:
                                    FontWeight.bold, // Optionally, make it bold
                                color: Colors
                                    .blue, // Optionally, change the text color
                              ),
                            ),
                          ],
                        )),
                      )),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => FleetNumbersScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black54,
                                blurRadius: 5,
                                offset: Offset(0, 0)),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.car_crash_rounded,
                                color: Colors.black,
                                size: 35,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                width: 1,
                                height: 24,
                                color: Colors.black,
                              ),
                              const Expanded(
                                child: Text(
                                  'Fleets',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => VehiclesScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 10,
                              offset: Offset(0, 0)),
                        ],
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bus_alert_rounded,
                            color: Colors.black,
                            size: 35.0,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            width: 1,
                            height: 24,
                            color: Colors.black,
                          ),
                          const Expanded(
                            child: Text(
                              'Vehicles',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  )),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => TransactionsScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 30),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 5,
                                    offset: Offset(0, 0)),
                              ],
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.pin,
                                  color: Colors.black,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  width: 1,
                                  height: 24,
                                  color: Colors.black,
                                ),
                                const Text(
                                  'Summary',
                                  style: TextStyle(color: Colors.black),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ))),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (ctx) =>
                          //             const SecurityPinsScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 30),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 5,
                                    offset: Offset(0, 0)),
                              ],
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.pin,
                                  color: Colors.black,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  width: 1,
                                  height: 24,
                                  color: Colors.black,
                                ),
                                const Text(
                                  'Pins',
                                  style: TextStyle(color: Colors.black),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        )))
              ]),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => VehiclesScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 5,
                              offset: Offset(0, 0)),
                        ],
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bus_alert_rounded,
                            color: Colors.black,
                            size: 35.0,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            width: 1,
                            height: 24,
                            color: Colors.black,
                          ),
                          const Expanded(
                            child: Text(
                              'Transactions History',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  )),
            ])),
      ),
    );
  }

  // Future<dynamic> createSearch({
  //   required String registrationNo,
  //   required int amount,
  //   required String phoneNumber,
  // }) async {
  //   if (!(await checkNetworkConnectivity())) {
  //     Future.delayed(const Duration(seconds: 3), () {
  //       // Hide loading indicator
  //       setState(() {
  //         _searchLoading = false;
  //       });
  //     });
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
  //       duration: const Duration(seconds: 5),
  //       margin: EdgeInsets.only(
  //         // ignore: use_build_context_synchronously
  //         bottom: MediaQuery.of(context).size.height * 0.04,
  //         right: 15,
  //         left: 15,
  //       ),
  //       backgroundColor: Colors.red,
  //     ));

  //     // Return an empty list when there is no internet connection
  //     return [];
  //   }

  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? jwt = prefs.getString('jwt');
  //   Map<String, dynamic> token = jsonDecode(jwt!);
  //   Map<String, dynamic> body = {
  //     "registrationNo": registrationNo,
  //     "policyNo": 'N/A',
  //     "insuranceType": 'N/A',
  //     "insuredPerson": 'N/A',
  //     "insurer": 'N/A',
  //     "username": username,
  //     "amount": amount,
  //     "phoneNumber": phoneNumber,
  //   };
  //   var url = Uri.parse('$baseUrl/create_search_vehicle');
  //   final postRequestResponse = await http.Client().post(url,
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Authorization': 'Bearer ${token['access_token']}'
  //       },
  //       body: jsonEncode(body));
  //   // print(postRequestResponse.body);
  //   if (postRequestResponse.statusCode == 200) {
  //     // var message = json.decode(postRequestResponse.body)['message'];
  //     // var sellerId = json.decode(postRequestResponse.body)['id'];

  //     // ignore: use_build_context_synchronously
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: const Text(
  //         'Search request successful. Wait to input M-PESA PIN for payment to proceed.',
  //         textAlign: TextAlign.center,
  //       ),
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       duration: const Duration(seconds: 5),
  //       margin: EdgeInsets.only(
  //           // ignore: use_build_context_synchronously
  //           bottom: MediaQuery.of(context).size.height * 0.04,
  //           right: 10,
  //           left: 10),
  //       backgroundColor: const Color(0xff4c505b),
  //     ));
  //     // // ignore: use_build_context_synchronously
  //     // Navigator.pushAndRemoveUntil(
  //     //     context,
  //     //     MaterialPageRoute(
  //     //         builder: (context) => PaymentScreen(
  //     //               sellerId: sellerId!,
  //     //             )),
  //     //     (route) => true);
  //     // Navigator.of(context).pushReplacementNamed(SearchScreen.routeName);
  //   } else if (postRequestResponse.statusCode != 200) {
  //     var message = json.decode(postRequestResponse.body)['message'];
  //     // ignore: use_build_context_synchronously
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(
  //         '$message',
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

  //     //Start a separate timer to check if 5 minutes have passed
  //     Timer(const Duration(minutes: 3), () async {
  //       // If 5 minutes have passed, navigate to SearchScreen
  //       // SharedPreferences prefs = await SharedPreferences.getInstance();

  //       // if (mounted) {
  //       //   prefs
  //       //       .remove('jwt')
  //       //       .then((value) => Navigator.pushAndRemoveUntil(
  //       //           context,
  //       //           MaterialPageRoute(builder: (context) => const SignInScreen()),
  //       //           (route) => false))
  //       //       .onError((error, stackTrace) =>
  //       //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       //             content: Text('$error'),
  //       //           )));
  //       // }
  //     });
  //   }
  // }
}
