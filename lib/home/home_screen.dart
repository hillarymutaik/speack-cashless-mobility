// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/side_menu.dart';
import '../screens/transactions.dart';
import '../utils/validators.dart';

// Define a class to represent the transaction data
class TransactionData {
  final List<Transaction> transactions;
  final int totalElements;

  TransactionData({required this.transactions, required this.totalElements});

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      transactions: List<Transaction>.from(
          json['data']['transactions'].map((x) => Transaction.fromJson(x))),
      totalElements: json['data']['totalElements'],
    );
  }
}

// Define a class to represent a single transaction
class Transaction {
  // Define properties of a transaction
  // Adjust these according to the actual structure of your transaction data
  final String id;
  final String name;
  // Add more properties as needed

  Transaction({required this.id, required this.name});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      name: json['name'],
      // Parse other properties here
    );
  }
}

class AmountData {
  final double amount;

  AmountData({
    required this.amount,
  });

  factory AmountData.fromJson(Map<String, dynamic> json) {
    return AmountData(
        amount: json['totalAmount'].toString() != null
            ? json['totalAmount'].toDouble()
            : 0.0);
  }
}

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
    getAmount();
    fetchData();
  }

  // Future<bool> checkNetworkConnectivity() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   return connectivityResult != ConnectivityResult.none;
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

  AmountData? _amount;

  bool dataLoading = true;

  bool transLoading = true;

  Future<void> getAmount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwt = prefs.getString('jwt');

    if (jwt == null) {
      // Handle the case where JWT token is not found in SharedPreferences
      print('JWT token not found in SharedPreferences');
      return;
    }

    Map<String, dynamic> token = jsonDecode(jwt);

    setState(() {
      dataLoading = true;
    });

    final String startDate = '2024-04-20';
    final String endDate = '2024-04-20';
    final Uri uri = Uri.parse(
        '$baseUrl/transactions/total-amount-collected?startDate=$startDate&endDate=$endDate');

    try {
      final http.Response response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${token['data']['token']}'
        },
      );

      // print("Response body::: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final amountData = AmountData.fromJson(jsonData);
        if (mounted) {
          setState(() {
            _amount = amountData;
            dataLoading = false;
          });
        }
      } else {
        print('Failed to load loan data. Status code: ${response.statusCode}');
        if (mounted) {
          setState(() {
            dataLoading = false;
          });
        }
      }
    } catch (e) {
      // print('Error fetching loan data: $e');
      try {
        if (mounted) {
          setState(() {
            dataLoading = false;
          });
        }
      } catch (e) {
        // Handle errors
      }
    }
  }

  Future<TransactionData>? fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwt = prefs.getString('jwt');
    Map<String, dynamic> token = jsonDecode(jwt!);

    final url = '${baseUrl}/transactions/filter?page=0&size=1&sort=string';

    try {
      final http.Response response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token['data']['token']}'
      });
      // print("Data::: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final transactionData = TransactionData.fromJson(jsonData);

        // Now you can access transaction data
        // print('Total elements: ${transactionData.totalElements}');
        for (var transaction in transactionData.transactions) {
          print('Transaction ID: ${transaction.id}, Name: ${transaction.name}');
        }
        return TransactionData.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: const SideMenu(),
        appBar: AppBar(
          title: Text(
            _getGreetingMessage(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15, // Adjust the font size as needed
              fontWeight: FontWeight.normal, // Optionally, make it bold
            ),
          ),
          centerTitle: true,
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
                      height: MediaQuery.of(context).size.height * .22,
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
                          bottom: MediaQuery.of(context).size.height * .021),
                      child: Container(
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * .19,
                              left: 30,
                              right: 30),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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
                              ])),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
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
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Collections Today',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      dataLoading
                                          ? const Center(
                                              child: SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                  Colors.lightBlueAccent,
                                                ),
                                              ),
                                            ))
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        Colors.lightBlueAccent,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Text(
                                                    'KES',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  '${_amount?.amount.toStringAsFixed(2) ?? 'N/A'}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[600],
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            )
                                    ]))),
                      ],
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 30, top: 10),
                    child: Text(
                      'Transaction History',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    )),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => TransactionsScreen()));
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 30),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.lightBlueAccent,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.history_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          Text(
                            'Transactions',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 15),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
                      )),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 30, top: 10),
                    child: Text(
                      'Recent Transactions',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
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
                  child: Center(
                    child: FutureBuilder<TransactionData>(
                      future: fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                Colors.lightBlueAccent,
                              ),
                            ),
                          ));
                        } else if (snapshot.hasError) {
                          print('Error: ${snapshot.error}');
                          return Text('Error: ${snapshot.error}');
                        } else {
                          if (snapshot.hasData) {
                            final transactionData = snapshot.data!;
                            // print(
                            //     'Total elements: ${transactionData.totalElements}');
                            if (transactionData.transactions.isEmpty) {
                              return Center(
                                child: Text(
                                  'No transactions found',
                                  style: TextStyle(fontSize: 13),
                                ),
                              );
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Elements: ${transactionData.totalElements}',
                                    style: TextStyle(
                                        color: Colors.lightBlueAccent,
                                        fontSize: 12),
                                  ),
                                  SizedBox(height: 20),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount:
                                          transactionData.transactions.length,
                                      itemBuilder: (context, index) {
                                        final transaction =
                                            transactionData.transactions[index];
                                        return Container(
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
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        Colors.lightBlueAccent,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Icon(
                                                    Icons.summarize_rounded,
                                                    color: Colors.white,
                                                    size:
                                                        20, // Adjust size as needed
                                                  ),
                                                ),
                                                Text(
                                                  'Transaction ID: ${transaction.id}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  'Name: ${transaction.name}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
                          } else {
                            // Handle the case when snapshot doesn't have data
                            return Center(
                              child: Text(
                                'No data available',
                                style: TextStyle(fontSize: 13),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                )
              ])),
        ));
  }
}
