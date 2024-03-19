// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FleetNumbersScreen extends StatefulWidget {
  @override
  State createState() => _FleetNumbersScreenState();
}

class _FleetNumbersScreenState extends State<FleetNumbersScreen> {
  List<Map<String, dynamic>> _fleetNumbersData = [];

  @override
  void initState() {
    super.initState();
    _loadFleetNumbersData();
  }

  Future<void> _loadFleetNumbersData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/fleet.json');
      Map<String, dynamic> data = jsonDecode(jsonString);
      setState(() {
        _fleetNumbersData =
            List<Map<String, dynamic>>.from(data['fleet_numbers']);
      });
    } catch (e) {
      print("Error retrieving fleet numbers data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fleet Numbers'),
      ),
      body: _fleetNumbersData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _fleetNumbersData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> fleetNumber = _fleetNumbersData[index];
                return InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (ctx) => FleetNumbersScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 3),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.car_crash_rounded,
                              color: Colors.white,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              width: 1,
                              height: 24,
                              color: Colors.white,
                            ),
                            Expanded(
                                child: Text('Fleet ID: ${fleetNumber['id']}',
                                    style:
                                        const TextStyle(color: Colors.white))),
                            Expanded(
                                child: Text(
                                    'Fleet No: ${fleetNumber['fleetNumber']}',
                                    style:
                                        const TextStyle(color: Colors.white))),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ),
    );
  }
}
