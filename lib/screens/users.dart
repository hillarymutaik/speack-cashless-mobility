// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
        _userData = List<Map<String, dynamic>>.from(data['users']);
      });
    } catch (e) {
      print("Error retrieving data: $e");
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
        title: const Text('Users'),
      ),
      body: _userData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _userData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> user = _userData[index];
                String formattedDate = formatDateTime(user['lastUpdatedAt']);
                return InkWell(
                  onTap: () {
                    // Handle user tap
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(formattedDate,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 11))
                            ]),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Username: ${user['username']}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Text('Full Name: ${user['fullName']}',
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Email: ${user['email']}',
                                  style: const TextStyle(color: Colors.white)),
                            ]),
                        Text('Phone Number: ${user['phoneNumber']}',
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
