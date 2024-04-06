// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class VehiclesScreen extends StatefulWidget {
  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  List<Map<String, dynamic>> _vehicleData = [];

  @override
  void initState() {
    super.initState();
    _loadVehicleData();
  }

  Future<void> _loadVehicleData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/vehicles.json');
      Map<String, dynamic> data = jsonDecode(jsonString);
      setState(() {
        _vehicleData = List<Map<String, dynamic>>.from(data['vehicles']);
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
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Vehicles',
          style: TextStyle(color: Colors.white),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
      ),
      body: _vehicleData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _vehicleData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> vehicle = _vehicleData[index];
                String formattedDate = formatDateTime(vehicle['lastUpdatedAt']);
                return InkWell(
                  onTap: () {
                    // Handle vehicle tap
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
                        Text('Fleet No: ${vehicle['fleetNumber']}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text('Reg No.: ${vehicle['numberPlate']}',
                            style: const TextStyle(color: Colors.white)),
                        Text('User ID: ${vehicle['userId']}',
                            style: const TextStyle(color: Colors.white)),
                        SizedBox(height: 5),
                        Text(formattedDate,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
