// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
      ),
      body: _vehicleData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _vehicleData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> vehicle = _vehicleData[index];
                return ListTile(
                  title: Text(vehicle['fleetNumber']),
                  subtitle: Text(vehicle['numberPlate']),
                  onTap: () {
                    // Handle vehicle tile tap
                  },
                );
              },
            ),
    );
  }
}
