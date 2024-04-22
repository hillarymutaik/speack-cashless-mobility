import 'dart:convert';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/fleet_screen.dart';
import '../screens/side_menu.dart';
import '../screens/transactions.dart';
import '../screens/vehicles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<HomeScreen> {
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

  String? tokenzz = '';
  String fullname = '';

  void account() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenzz = prefs.getString('jwt')!;
    Map<String, dynamic> token = jsonDecode(tokenzz!);
    setState(() {
      fullname = '${token['data']['user']['fullName']}';
    });
  }

  @override
  void initState() {
    super.initState();
    account();
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

  String _getGreetingMessage() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning,';
    } else if (hour < 17) {
      return 'Good afternoon,';
    } else {
      return 'Good evening,';
    }
  }

  Widget _buildCircularContainer(IconData icon, String description) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.lightBlueAccent,
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
        ),
        SizedBox(height: 6),
        Text(
          description,
          style: TextStyle(color: Colors.grey[600], fontSize: 15),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: const SideMenu(),
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white, size: 30),
        ),
        body: SingleChildScrollView(
          child: Container(
              // height: MediaQuery.of(context).size.height,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .27,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(80)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              blurRadius: 5,
                              offset: Offset(2, 2)),
                        ],
                      ),
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * .13),
                      child: Container(
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * .2,
                              left: 30,
                              right: 30),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getGreetingMessage(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            15, // Adjust the font size as needed
                                        fontWeight: FontWeight
                                            .normal, // Optionally, make it bold
                                      ),
                                    ),
                                    Text(
                                      '$fullname',
                                      style: TextStyle(
                                        fontSize:
                                            16, // Adjust the font size as needed
                                        fontWeight: FontWeight
                                            .bold, // Optionally, make it bold
                                        fontStyle: FontStyle.italic,
                                        color: Colors
                                            .white, // Optionally, change the text color
                                      ),
                                    ),
                                  ],
                                ),
                                // InkWell(
                                //   onTap: () {
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (ctx) => ProfileScreen()));
                                //   },
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       color: Colors.white,
                                //     ),
                                //     padding: const EdgeInsets.all(10),
                                //     child: ClipRRect(
                                //       borderRadius: const BorderRadius.all(
                                //           Radius.circular(100)),
                                //       child: Image.asset(
                                //         'assets/logo.jpg',
                                //         fit: BoxFit.cover,
                                //         height:
                                //             MediaQuery.of(context).size.height *
                                //                 0.04,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ])),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                TransactionsScreen()));
                                  },
                                  child: _buildCircularContainer(
                                      Icons.summarize, 'Summary')),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                FleetNumbersScreen()));
                                  },
                                  child: _buildCircularContainer(
                                      Icons.car_crash_rounded, 'Fleets'))
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                VehiclesScreen()));
                                  },
                                  child: _buildCircularContainer(
                                      Icons.car_rental_rounded, 'Vehilces')),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                TransactionsScreen()));
                                  },
                                  child: _buildCircularContainer(
                                      Icons.history_rounded, 'Transactions'))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 30, top: 10),
                    child: Text(
                      'Amount Collected Today',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (ctx) => TransactionsScreen()));
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 10,
                                          offset: Offset(0, 0)),
                                    ],
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.lightBlueAccent,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        'KES',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      '1,500.00',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                          fontSize: 15),
                                    ),
                                  ],
                                )))),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 30, top: 10),
                    child: Text(
                      'Recent Transactions',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )),
                Container(
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade500,
                                  blurRadius: 10,
                                  offset: Offset(0, 0)),
                            ],
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.lightBlueAccent,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.summarize_rounded,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ),
                              const Text(
                                'Transactions History',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade500,
                                  blurRadius: 10,
                                  offset: Offset(0, 0)),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.lightBlueAccent,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.summarize_rounded,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ),
                              const Text(
                                'Transactions History',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade500,
                                  blurRadius: 10,
                                  offset: Offset(0, 0)),
                            ],
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.lightBlueAccent,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.summarize_rounded,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ),
                              const Text(
                                'Transactions History',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade500,
                                  blurRadius: 10,
                                  offset: Offset(0, 0)),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.lightBlueAccent,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.summarize_rounded,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ),
                              const Text(
                                'Transactions History',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade500,
                                  blurRadius: 10,
                                  offset: Offset(0, 0)),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.lightBlueAccent,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.summarize_rounded,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ),
                              const Text(
                                'Transactions History',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade500,
                                  blurRadius: 10,
                                  offset: Offset(0, 0)),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.lightBlueAccent,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.summarize_rounded,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ),
                              const Text(
                                'Transactions History',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                )
              ])),
        ));
  }
}
