// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../home/home_screen.dart';
import '../utils/validators.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Future<void> _loadTransactionsData() async {
  //   try {
  //     String jsonString = await rootBundle.loadString('assets/trans.json');
  //     Map<String, dynamic> data = jsonDecode(jsonString);
  //     setState(() {
  //       _transactionsData =
  //           List<Map<String, dynamic>>.from(data['transactions']);
  //     });
  //   } catch (e) {
  //     print("Error retrieving transactions data: $e");
  //   }
  // }

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

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat('h:mm a d MMM y');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
        title: const Text(
          'Transactions',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Center(
        child: FutureBuilder<TransactionData>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
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
                      'No transactions',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                            color: Colors.lightBlueAccent, fontSize: 12),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: transactionData.transactions.length,
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        size: 20, // Adjust size as needed
                                      ),
                                    ),
                                    Text(
                                      'Transaction ID: ${transaction.id}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                    Text(
                                      'Name: ${transaction.name}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
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
    );
  }
}
