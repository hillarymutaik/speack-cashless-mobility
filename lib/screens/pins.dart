// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class SecurityPinsScreen extends StatefulWidget {
//   const SecurityPinsScreen({super.key});

//   @override
//   State createState() => _SecurityPinsScreenState();
// }

// class _SecurityPinsScreenState extends State<SecurityPinsScreen> {
//   List<Map<String, dynamic>> _securityPinsData = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadSecurityPinsData();
//   }

//   Future<void> _loadSecurityPinsData() async {
//     try {
//       String jsonString = await rootBundle.loadString('assets/pins.json');
//       Map<String, dynamic> data = jsonDecode(jsonString);
//       setState(() {
//         _securityPinsData =
//             List<Map<String, dynamic>>.from(data['security_pins']);
//       });
//     } catch (e) {
//       print("Error retrieving security pins data: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Security Pins'),
//       ),
//       body: _securityPinsData.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _securityPinsData.length,
//               itemBuilder: (context, index) {
//                 Map<String, dynamic> securityPin = _securityPinsData[index];
//                 return InkWell(
//                     onTap: () {
//                       // Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(
//                       //         builder: (ctx) => FleetNumbersScreen()));
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 3),
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 2),
//                       decoration: BoxDecoration(
//                           color: Colors.grey,
//                           border: Border.all(
//                             color: Colors.transparent,
//                           ),
//                           borderRadius: BorderRadius.circular(8)),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 6),
//                         child: Row(
//                           children: [
//                             const Icon(
//                               Icons.car_crash_rounded,
//                               color: Colors.white,
//                             ),
//                             Container(
//                               margin:
//                                   const EdgeInsets.symmetric(horizontal: 12),
//                               width: 1,
//                               height: 24,
//                               color: Colors.white,
//                             ),
//                             Expanded(
//                                 child: Text('ID: ${securityPin['id']}',
//                                     style:
//                                         const TextStyle(color: Colors.white))),
//                             Expanded(
//                                 child: Text('Pin: ${securityPin['pin']}',
//                                     style:
//                                         const TextStyle(color: Colors.white))),
//                             const Icon(
//                               Icons.arrow_forward_ios,
//                               size: 12,
//                               color: Colors.white70,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ));
//               },
//             ),
//     );
//   }
// }
