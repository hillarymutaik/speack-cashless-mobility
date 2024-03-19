import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/side_menu.dart';
import '../utils/validators.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static const routeName = 'search-screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _searchLoading = false;
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _regNoController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? tokenzz = "";
  String username = '';
  int? sellerId;
  String fullName = '';
  String email = '';
  void account() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenzz = prefs.getString('jwt')!;
    Map<String, dynamic> token = jsonDecode(tokenzz!);
    setState(() {
      username = '${token['user']['username']}';
      sellerId = int.parse(token['user']['id'].toString());
      fullName = '${token['user']['fullName']}';
      email = '${token['user']['email']}';
    });
  }

  @override
  void initState() {
    super.initState();
    account();
    loadData();
  }

  Future<bool> checkNetworkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Map<String, dynamic> _data = {};

  Future<void> loadData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data.json');
      Map<String, dynamic> data = jsonDecode(jsonString);
      setState(() {
        _data = data;
      });
    } catch (e) {
      print("Error retrieving data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/log.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.blue.withOpacity(.5),
        drawer: const SideMenu(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(
            size: 30,
            color: Colors.white, // Change the color to your desired color
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.008),
            child: ListView.builder(
              itemCount: _data.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                String model = _data.keys.elementAt(index);
                List<dynamic> items = _data[model];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        model.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: items.length,
                      itemBuilder: (context, idx) {
                        return ListTile(
                          title: Text(items[idx].toString()),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> createSearch({
    required String registrationNo,
    required int amount,
    required String phoneNumber,
  }) async {
    if (!(await checkNetworkConnectivity())) {
      Future.delayed(const Duration(seconds: 3), () {
        // Hide loading indicator
        setState(() {
          _searchLoading = false;
        });
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          'No Internet Connection',
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 5),
        margin: EdgeInsets.only(
          // ignore: use_build_context_synchronously
          bottom: MediaQuery.of(context).size.height * 0.04,
          right: 15,
          left: 15,
        ),
        backgroundColor: Colors.red,
      ));

      // Return an empty list when there is no internet connection
      return [];
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwt = prefs.getString('jwt');
    Map<String, dynamic> token = jsonDecode(jwt!);
    Map<String, dynamic> body = {
      "registrationNo": registrationNo,
      "policyNo": 'N/A',
      "insuranceType": 'N/A',
      "insuredPerson": 'N/A',
      "insurer": 'N/A',
      "username": username,
      "amount": amount,
      "phoneNumber": phoneNumber,
    };
    var url = Uri.parse('$baseUrl/create_search_vehicle');
    final postRequestResponse = await http.Client().post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${token['access_token']}'
        },
        body: jsonEncode(body));
    // print(postRequestResponse.body);
    if (postRequestResponse.statusCode == 200) {
      // var message = json.decode(postRequestResponse.body)['message'];
      // var sellerId = json.decode(postRequestResponse.body)['id'];

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          'Search request successful. Wait to input M-PESA PIN for payment to proceed.',
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 5),
        margin: EdgeInsets.only(
            // ignore: use_build_context_synchronously
            bottom: MediaQuery.of(context).size.height * 0.04,
            right: 10,
            left: 10),
        backgroundColor: const Color(0xff4c505b),
      ));
      // // ignore: use_build_context_synchronously
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => PaymentScreen(
      //               sellerId: sellerId!,
      //             )),
      //     (route) => true);
      // Navigator.of(context).pushReplacementNamed(SearchScreen.routeName);
    } else if (postRequestResponse.statusCode != 200) {
      var message = json.decode(postRequestResponse.body)['message'];
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '$message',
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.only(
            // ignore: use_build_context_synchronously
            bottom: MediaQuery.of(context).size.height * 0.04,
            right: 15,
            left: 15),
        backgroundColor: Colors.red,
      ));

      //Start a separate timer to check if 5 minutes have passed
      Timer(const Duration(minutes: 3), () async {
        // If 5 minutes have passed, navigate to SearchScreen
        // SharedPreferences prefs = await SharedPreferences.getInstance();

        // if (mounted) {
        //   prefs
        //       .remove('jwt')
        //       .then((value) => Navigator.pushAndRemoveUntil(
        //           context,
        //           MaterialPageRoute(builder: (context) => const SignInScreen()),
        //           (route) => false))
        //       .onError((error, stackTrace) =>
        //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //             content: Text('$error'),
        //           )));
        // }
      });
    }
  }
}
