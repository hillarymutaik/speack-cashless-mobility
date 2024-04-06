// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Map<String, dynamic>> _transactionsData = [];

  @override
  void initState() {
    super.initState();
    _loadTransactionsData();
  }

  Future<void> _loadTransactionsData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/trans.json');
      Map<String, dynamic> data = jsonDecode(jsonString);
      setState(() {
        _transactionsData =
            List<Map<String, dynamic>>.from(data['transactions']);
      });
    } catch (e) {
      print("Error retrieving transactions data: $e");
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
        backgroundColor: Colors.blue,
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
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _transactionsData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _transactionsData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> transaction = _transactionsData[index];
                String formattedDate =
                    formatDateTime(transaction['transactionDate']);
                return InkWell(
                  onTap: () {
                    // Handle transaction tap
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(formattedDate,
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.normal)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'Driver Phone: ${transaction['driverPhone']}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              Text('Amount: ${transaction['amount']}',
                                  style: const TextStyle(color: Colors.white))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Status: ${transaction['paymentStatus']}',
                                  style: const TextStyle(color: Colors.white)),
                              Text('Client Name: ${transaction['clientName']}',
                                  style: const TextStyle(color: Colors.white))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'Service Charge: Ksh${transaction['serviceCharge']}',
                                  style: const TextStyle(color: Colors.white)),
                              Text(
                                  'MPESA Rcpt: ${transaction['mpesaReceiptNumber']}',
                                  style: const TextStyle(color: Colors.white))
                            ]),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
