// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserDataScreen extends StatefulWidget {
  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  List<Map<String, dynamic>> _userData = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/users.json');
      Map<String, dynamic> data = jsonDecode(jsonString);
      setState(() {
        _userData = data['users'].cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print("Error retrieving data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: _userData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _userData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> user = _userData[index];
                return ListTile(
                  title: Text(user['fullName']),
                  subtitle: Text(user['email']),
                  trailing: Text(user['phoneNumber']),
                  onTap: () {
                    // Handle user tile tap
                  },
                );
              },
            ),
    );
  }
}
