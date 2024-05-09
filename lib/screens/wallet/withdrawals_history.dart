// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// import '../../home/home_screen.dart';
import '../../utils/validators.dart';

class DataModel {
  final Map<String, dynamic> additionalProp1;
  final Map<String, dynamic> additionalProp2;
  final Map<String, dynamic> additionalProp3;

  DataModel({
    required this.additionalProp1,
    required this.additionalProp2,
    required this.additionalProp3,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      additionalProp1: json['data']['additionalProp1'] ?? {},
      additionalProp2: json['data']['additionalProp2'] ?? {},
      additionalProp3: json['data']['additionalProp3'] ?? {},
    );
  }
}

class WithdrawalsScreen extends StatefulWidget {
  @override
  State<WithdrawalsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<WithdrawalsScreen> {
  @override
  void initState() {
    super.initState();
    getWithdrawals();
  }

  Future<DataModel>? getWithdrawals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwt = prefs.getString('jwt');
    Map<String, dynamic> token = jsonDecode(jwt!);

    final url =
        '${baseUrl}/transactions/withdrawals/history?page=0&size=1&sort=string';

    try {
      final http.Response response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token['data']['token']}'
      });
      // print("Data::: ${response.body}");

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = jsonDecode(response.body);
        final dataModel = DataModel.fromJson(jsonData);
        return dataModel;
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // If an error occurs during the HTTP request, throw an exception
      throw Exception('Failed to load data: $e');
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
          'Withdrawals History',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: FutureBuilder<DataModel>(
          future: getWithdrawals(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: SizedBox(
                height: 25,
                width: 25,
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
                if (transactionData.additionalProp1.isEmpty) {
                  return Center(
                    child: Text(
                      'No withdrawals',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Total Elements: ${transactionData.additionalProp1}',
                        style: TextStyle(
                            color: Colors.lightBlueAccent, fontSize: 12),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: transactionData.additionalProp1.length,
                          itemBuilder: (context, index) {
                            final transaction =
                                transactionData.additionalProp1[index];
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
