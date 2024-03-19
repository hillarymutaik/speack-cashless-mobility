// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Map<String, dynamic>> _transactionData = [];

  @override
  void initState() {
    super.initState();
    _loadTransactionData();
  }

  Future<void> _loadTransactionData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/trans.json');
      Map<String, dynamic> data = jsonDecode(jsonString);
      setState(() {
        _transactionData =
            List<Map<String, dynamic>>.from(data['transactions']);
      });
    } catch (e) {
      print("Error retrieving data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: _transactionData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _transactionData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> transaction = _transactionData[index];
                return ListTile(
                  title: Text('Transaction ID: ${transaction['id']}'),
                  subtitle: Text('Amount: ${transaction['amount']}'),
                  onTap: () {
                    // Handle transaction tile tap
                  },
                );
              },
            ),
    );
  }
}
