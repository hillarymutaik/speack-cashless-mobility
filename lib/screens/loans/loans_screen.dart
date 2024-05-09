// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, unused_element

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:shared_preferences/shared_preferences.dart';
import '../../home/Home.dart';
import '../../utils/validators.dart';

class LoanData {
  final double loanLimit;
  final double balance;
  final String reviewedAt;
  final String lastUpdatedAt;

  LoanData({
    required this.loanLimit,
    required this.balance,
    required this.reviewedAt,
    required this.lastUpdatedAt,
  });

  factory LoanData.fromJson(Map<String, dynamic> json) {
    return LoanData(
      loanLimit:
          json['amount'].toString() != null ? json['amount'].toDouble() : 0.0,
      balance:
          json['balance'].toString() != null ? json['balance'].toDouble() : 0.0,
      reviewedAt: json['reviewedAt'] ?? '',
      lastUpdatedAt: json['lastUpdatedAt'] ?? '',
    );
  }
}

class LoansHomeScreen extends StatefulWidget {
  const LoansHomeScreen({super.key});

  @override
  State<LoansHomeScreen> createState() => _AppliedLoansState();
}

class _AppliedLoansState extends State<LoansHomeScreen> {
  LoanData? _loanData;
  bool dataLoading = true;
  bool loansLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLoanData();
    fetchLoans();
  }

  late List<Loan> loans = [];

  Future<void> fetchLoans() async {
    setState(() {
      loansLoading = true; // Set isLoading to true when starting request
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? jwt = prefs.getString('jwt');
      Map<String, dynamic> token = jsonDecode(jwt!);

      final http.Response response = await http.get(
        Uri.parse('$baseUrl/loans/applications'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${token['data']['token']}'
        },
      );

      print("Loans::: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          loans =
              (jsonData as List).map((data) => Loan.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed to load loans');
      }
    } catch (error) {
      // Handle error
      print(error);
    } finally {
      setState(() {
        loansLoading =
            false; // Set isLoading back to false when request completes
      });
    }
  }

  Future<void> _fetchLoanData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwt = prefs.getString('jwt');
    Map<String, dynamic> token = jsonDecode(jwt!);
    setState(() {
      dataLoading = true;
    });

    final http.Response response =
        await http.get(Uri.parse('$baseUrl/loans/limit'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${token['data']['token']}'
    });
    print("Token::: ${token['data']['token']}");
    print("Limit::: ${response.body}");
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final loanData = LoanData.fromJson(jsonData);
      setState(() {
        _loanData = loanData;
        dataLoading =
            false; // Set dataLoading flag to false after fetching data
      });
    } else {
      setState(() {
        dataLoading =
            false; // Set dataLoading flag to false if data fetching fails
      });
      throw Exception('Failed to load loan data');
    }
  }

  String formattedDate(String originalDate) {
    if (_loanData != null && _loanData!.lastUpdatedAt != null) {
      final DateTime dateTime = DateTime.parse(_loanData!.lastUpdatedAt);
      final DateFormat formatter = DateFormat('HH:mm a dd/MM/yyyy');
      return formatter.format(dateTime);
    } else {
      // Handle the case when _loanData or lastUpdatedAt is null
      return ''; // or any default value you prefer
    }
  }

  @override
  Widget build(BuildContext context) {
    String? originalDate;
    if (_loanData != null) {
      originalDate = _loanData!.lastUpdatedAt;
    } else {
      // Handle the case where _loanData is null
      // For example, you can set originalDate to a default value or display an error message
      originalDate = 'N/A'; // Set originalDate to a default value
      // Or display an error message
    }

    String? originalR;
    if (_loanData != null) {
      originalR = _loanData!.reviewedAt;
    } else {
      // Handle the case where _loanData is null
      // For example, you can set originalDate to a default value or display an error message
      originalR = 'N/A'; // Set originalDate to a default value
      // Or display an error message
    }

    String fLast = formattedDate(originalDate);
    formattedDate(originalR);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.lightBlueAccent, // Set your desired color here
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            // homeBloc.add(const AppliedData(applied: []));
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                centerTitle: false,
                floating: true,
                snap: false,
                pinned: true,
                elevation: 0,
                titleSpacing: 0,
                shadowColor: Colors.transparent,
                expandedHeight: 60,
                backgroundColor: Colors.lightBlueAccent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.lightBlueAccent,
                                        ),
                                        child: Center(
                                            child: dataLoading
                                                ? const Center(
                                                    child: SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                        Colors.white,
                                                      ),
                                                    ),
                                                  ))
                                                : Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Loan Limit: KES ${_loanData!.balance.toStringAsFixed(2)}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Baloo2',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                            ]),
                                                        const SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          'Updated ${fLast}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontFamily:
                                                                      'Baloo2',
                                                                  fontSize: 12),
                                                        ),
                                                      ]))),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(
                  top: 5,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (loansLoading) {
                      return Center(
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(
                              Colors.lightBlueAccent,
                            ),
                          ),
                        ), // Show loading indicator
                      );
                    } else {
                      final loan = loans[index];

                      String formatUpdated(String updated) {
                        if (_loanData != null && loan.lastUpdatedAt != null) {
                          final DateTime dateTime =
                              DateTime.parse(_loanData!.lastUpdatedAt);
                          final DateFormat formatter =
                              DateFormat('HH:mm a dd/MM/yyyy');
                          return formatter.format(dateTime);
                        } else {
                          // Handle the case when _loanData or lastUpdatedAt is null
                          return ''; // or any default value you prefer
                        }
                      }

                      String? updatedD;
                      if (_loanData != null) {
                        updatedD = loan.lastUpdatedAt;
                      } else {
                        // Handle the case where _loanData is null
                        // For example, you can set originalDate to a default value or display an error message
                        updatedD = 'N/A'; // Set originalDate to a default value
                        // Or display an error message
                      }

                      String lastUpdates = formattedDate(updatedD);

                      return (loans.isNotEmpty)
                          ? Container(
                              margin: const EdgeInsets.all(
                                15,
                              ),
                              padding: const EdgeInsets.all(
                                16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.background,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.shade100,
                                    blurRadius: 10,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Ref No: ${loan.loanNo}',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontFamily: 'Baloo2',
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Member No: ${loan.userId}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Baloo2',
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Amount: KES ${loan.amountApplied}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Baloo2',
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          'Interest: KES ${loan.interestAmount}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Baloo2',
                                            fontSize: 13,
                                          ),
                                        ),
                                      ]),
                                  SizedBox(height: 5.0),
                                  Text(
                                    'Repayment Amount: KES ${loan.repayableAmount}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Baloo2',
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    'Repayment Balance: KES ${loan.repaymentBalance}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Baloo2',
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Status: ${loan.statusReason}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Baloo2',
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: Colors.greenAccent,
                                          size: 10,
                                        ),
                                        SizedBox(width: 2.0),
                                        Text(
                                          'Updated: $lastUpdates',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Baloo2',
                                            fontSize: 12,
                                          ),
                                        )
                                      ])
                                ],
                              ),
                            )
                          : Center(
                              child: Text(
                                "There are no applications.",
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                    }
                  },
                  childCount: loans.length,
                ),
              )
            ],
          )
          // }
          ),
      floatingActionButton: SizedBox(
        width: 100.0,
        height: 38,
        child: FloatingActionButton(
            backgroundColor: Colors.lightBlueAccent,
            onPressed: () {
              _applyLoanSheet(context);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  15.0), // Set a circular radius for all four corners
            ),
            child: const Text(
              'Apply Loan',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Baloo2',
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            )), // Set the shape here
      ),
    );
  }
}

void _applyLoanSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.blueGrey.shade100,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
    ),
    builder: (BuildContext context) {
      return const ApplyLoanSheet();
    },
  );
}

class ApplyLoanSheet extends StatefulWidget {
  const ApplyLoanSheet({
    super.key,
  });
  @override
  State<ApplyLoanSheet> createState() => _ApplyLoanSheetState();
}

class _ApplyLoanSheetState extends State<ApplyLoanSheet> {
  bool loadingCollect = false;
  final _globalKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    // applyCubit = context.read<MainCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  bool _applyLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
            padding: const EdgeInsets.all(25),
            child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _globalKey,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Container(
                          width: size.width * .15,
                          height: size.height * 0.005,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 2, 46, 99),
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    SizedBox(height: size.height * 0.03),
                    const Text('Apply Loan',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    SizedBox(height: size.height * 0.03),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15),
                        controller: _amountController,
                        validator: loanAmountValidator,
                        cursorColor: Colors.blueGrey,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blueGrey),
                          ),
                          fillColor: Colors.blueGrey.shade50,
                          filled: true,
                          hintText: 'Enter amount',
                          hintStyle: const TextStyle(fontSize: 12),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: const Icon(Icons.numbers_rounded,
                              color: Colors.lightBlueAccent),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.blueGrey,
                              width: .05,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.blueGrey,
                              width: .05,
                            ),
                          ),
                        )),
                    SizedBox(height: size.height * 0.04),
                    GestureDetector(
                        onTap: () {
                          if (_globalKey.currentState!.validate()) {
                            setState(() {
                              _applyLoading = true;
                            });
                            appyLoans(
                                    amount:
                                        double.parse(_amountController.text))
                                .then((value) {
                              setState(() {
                                _applyLoading = false;
                              });
                            });
                          } else {
                            setState(() {
                              _applyLoading = false;
                            });
                          }
                        },
                        child: Container(
                            width: size.width,
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                                child: _applyLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white),
                                        ),
                                      )
                                    : const Text('Apply',
                                        style: TextStyle(
                                            fontFamily: 'Baloo2',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))))),
                    SizedBox(height: size.height * 0.015),
                  ],
                )))));
  }

  Future<void> appyLoans({required double amount}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwt = prefs.getString('jwt');
    Map<String, dynamic> token = jsonDecode(jwt!);

    Map<String, String> body = {
      'amount': amount.toString(),
    };
    var url = Uri.parse('$baseUrl/loans/apply');

    final postRequestResponse = await http.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${token['data']['token']}'
        },
        body: jsonEncode(body));
    print(postRequestResponse.body);

    if (postRequestResponse.statusCode == 200) {
      var jsonResponse = json.decode(postRequestResponse.body);
      var message = jsonResponse['desc'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$message',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.only(
            bottom: 10,
            right: 15,
            left: 15,
          ),
          backgroundColor: const Color(0xff4c505b),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        (route) => false,
      );
    } else {
      var message = json.decode(postRequestResponse.body)['message'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$message',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.only(
            bottom: 10,
            right: 15,
            left: 15,
          ),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }

    setState(() {
      _applyLoading = false;
    });
  }
}

class Loan {
  final int id;
  final double amountApplied;
  final String status;
  final String statusReason;
  final String loanNo;
  final double interestAmount;
  final double repayableAmount;
  final double repaymentBalance;
  final String createdAt;
  final String lastUpdatedAt;
  final int userId;

  Loan({
    required this.id,
    required this.amountApplied,
    required this.status,
    required this.statusReason,
    required this.loanNo,
    required this.interestAmount,
    required this.repayableAmount,
    required this.repaymentBalance,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.userId,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      amountApplied: json['amountApplied'],
      status: json['status'],
      statusReason: json['statusReason'],
      loanNo: json['loanNo'],
      interestAmount: json['interestAmount'],
      repayableAmount: json['repayableAmount'],
      repaymentBalance: json['repaymentBalance'],
      createdAt: json['createdAt'],
      lastUpdatedAt: json['lastUpdatedAt'],
      userId: json['userId'],
    );
  }
}
