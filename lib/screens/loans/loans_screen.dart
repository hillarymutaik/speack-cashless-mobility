// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../../home/Home.dart';
import '../../utils/colors_frave.dart';
import '../../utils/form_field_frave.dart';
import '../../utils/validators.dart';
import 'package:http/http.dart' as http;

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
      loanLimit: json['amount'] != null ? json['amount'].toDouble() : 0.0,
      balance: json['balance'] != null ? json['balance'].toDouble() : 0.0,
      reviewedAt: json['reviewedAt'] ?? '',
      lastUpdatedAt: json['lastUpdatedAt'] ?? '',
    );
  }
}

class LoansHomeScreen extends StatelessWidget {
  const LoansHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(90), // Set the desired height
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.blue, // Set your desired color here
              centerTitle: true,
              title: const Text(
                'Loans',
                style: TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              bottom: const TabBar(
                dividerColor: Colors.transparent,
                indicatorColor: Colors.white,
                unselectedLabelColor: Color.fromARGB(255, 183, 202, 218),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 1.8,
                labelColor: Colors.white,
                tabs: [
                  Tab(
                      icon: Text(
                    'Applications',
                    style: TextStyle(fontFamily: 'Baloo2', fontSize: 18),
                  )),
                  Tab(
                      icon: Text(
                    'Rejected',
                    style: TextStyle(fontFamily: 'Baloo2', fontSize: 18),
                  ))
                ],
              ),
            )),
        body: const TabBarView(
          children: [
            AppliedLoans(),
            RejectedLoans(),
          ],
        ),
      ),
    );
  }
}

class AppliedLoans extends StatefulWidget {
  const AppliedLoans({super.key});

  @override
  State<AppliedLoans> createState() => _AppliedLoansState();
}

class _AppliedLoansState extends State<AppliedLoans> {
  // ClearedModel? appliedLoan;
  // late final HomeBloc homeBloc;

  LoanData? _loanData;
  bool dataLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchLoanData();
    fetchLoans();
  }

  late List<Loan> loans = [];

  Future<void> fetchLoans() async {
    final http.Response response = await http.get(
        Uri.parse('http://52.23.50.252:9077/api/loans/applications'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6W3siYXV0aG9yaXR5IjoiT1dORVIifV0sInN1YiI6IjI1NDcyNzkxODk1NSIsImlzcyI6Imh0dHBzOi8vc3BlYWNrLmNvLmtlIiwiaWF0IjoxNzEyMjEyNTIzLCJleHAiOjE3MTIyOTg5MjN9.BSNxf3BsVrhkT4Z90BT27kAnvvzT1gHQkgWNcoDlu7M'
        });
    print("Loans::: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        loans = (jsonData as List).map((data) => Loan.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load loans');
    }
  }

  Future<void> _fetchLoanData() async {
    setState(() {
      dataLoading = true; // Set dataLoading flag to true before fetching data
    });

    final http.Response response = await http
        .get(Uri.parse('http://52.23.50.252:9077/api/loans/limit'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6W3siYXV0aG9yaXR5IjoiT1dORVIifV0sInN1YiI6IjI1NDcyNzkxODk1NSIsImlzcyI6Imh0dHBzOi8vc3BlYWNrLmNvLmtlIiwiaWF0IjoxNzEyMjEyNTIzLCJleHAiOjE3MTIyOTg5MjN9.BSNxf3BsVrhkT4Z90BT27kAnvvzT1gHQkgWNcoDlu7M'
    });
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
    String fReview = formattedDate(originalR);
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            // homeBloc.add(const AppliedData(applied: []));
          },
          child:
              // BlocConsumer<HomeBloc, HomeState>(
              //     listener: (_, __) {},
              //     builder: (context, state) {
              // return
              CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                centerTitle: false,
                floating: true,
                snap: false,
                pinned: true,
                elevation: 0,
                titleSpacing: 0,
                shadowColor: Colors.transparent,
                expandedHeight: 100,
                backgroundColor: Colors.blue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        // width: 40,
                                        // height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                            child: dataLoading
                                                ? const Center(
                                                    child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2.5,
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                        Colors.lightBlue,
                                                      ),
                                                    ),
                                                  ))
                                                : Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                        Row(children: [
                                                          Expanded(
                                                              child: Text(
                                                            'Limit: ${_loanData!.loanLimit.toStringAsFixed(2) ?? "Loading..."}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Baloo2',
                                                                    fontSize:
                                                                        18),
                                                          )),
                                                          Text(
                                                            'Balance: ${_loanData!.balance.toStringAsFixed(2) ?? "Loading..."}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Baloo2',
                                                                    fontSize:
                                                                        18),
                                                          )
                                                        ]),
                                                        const SizedBox(
                                                          height: 6,
                                                        ),
                                                        Row(children: [
                                                          Expanded(
                                                              child: Text(
                                                            'Updated: ${fLast ?? "Loading..."}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontFamily:
                                                                    'Baloo2',
                                                                fontSize: 10),
                                                          )),
                                                          Expanded(
                                                              child: Text(
                                                            'Reviewed: ${fReview ?? "Loading..."}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black45,
                                                                fontFamily:
                                                                    'Baloo2',
                                                                fontSize: 10),
                                                          )),
                                                        ]),
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
              SliverAppBar(
                centerTitle: false,
                floating: true,
                snap: false,
                pinned: true,
                elevation: 0,
                titleSpacing: 0,
                shadowColor: Colors.transparent,
                // expandedHeight: 40,
                backgroundColor: Colors.blue,
                // Set your desired color here
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
                              horizontal: 24, vertical: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: FormFieldFrave(
                                  // controller: _phoneController,
                                  hintText: 'Search application no.',
                                  keyboardType:
                                      TextInputType.text, //.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please application no.';
                                    }
                                    // You can add more advanced email validation logic if needed
                                    return null; // Return null if the input is valid
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              InkWell(
                                  onTap: () {
                                    // if (_parcelKey.currentState!
                                    //     .validate()) {
                                    //   // If the form is valid, perform the desired action
                                    //   _parcelKey.currentState!.save();
                                    // }
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(8),
                                      width: 40,
                                      height: 39,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.grey.shade300,
                                      ),
                                      child: const Icon(
                                        Icons.search_rounded,
                                        color: ColorsFrave.primaryColor,
                                      )))
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
              // (isLoading)
              //     ? SliverList(
              //         delegate: SliverChildListDelegate([
              //           const Center(
              //             child: SizedBox(
              //               width: 20,
              //               height: 20,
              //               child: CircularProgressIndicator(
              //                 strokeWidth: 2.5,
              //                 color: Color.fromARGB(255, 1, 46, 99),
              //               ),
              //             ),
              //           )
              //         ]),
              //       )
              //     :
              // (state.applied.isEmpty)
              //     ?
              // If the data is empty, show a message widget
              // SliverList(
              //     delegate: SliverChildListDelegate([
              //       Center(
              //           child: Column(children: [
              //         const SizedBox(
              //           height: 10,
              //         ),
              //         const TextCustom(
              //           text: 'No applications',
              //           fontSize: 16,
              //         ),
              //       ])),
              //     ]),
              //   )
              // :

              // SliverList(
              //   delegate: SliverChildBuilderDelegate(
              //     (BuildContext context, int index) {
              //       // appliedLoan = state.applied[index];
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(
              //             horizontal: 15, vertical: 3),
              //         child: Container(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 16, vertical: 5),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(8),
              //             color: Theme.of(context).colorScheme.background,
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Theme.of(context)
              //                     .primaryColor
              //                     .withOpacity(0.5),
              //                 spreadRadius: 0,
              //                 blurRadius: 10,
              //                 offset: const Offset(0, 0),
              //               ),
              //             ],
              //           ),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               const Row(
              //                   mainAxisAlignment:
              //                       MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Text(
              //                       'Name: .name',
              //                       style: TextStyle(
              //                           color: Colors.black87,
              //                           fontFamily: 'Baloo2',
              //                           fontSize: 14),
              //                     ),
              //                     Text(
              //                       'Member No: member_number',
              //                       style: TextStyle(
              //                           color: ColorsFrave.primaryColor,
              //                           fontFamily: 'Baloo2',
              //                           fontSize: 13),
              //                     ),
              //                   ]),
              //               const SizedBox(
              //                 height: 2,
              //               ),
              //               SizedBox(
              //                 height: 1.0,
              //                 child: ClipRRect(
              //                   borderRadius: BorderRadius.circular(2.5),
              //                   child: LinearProgressIndicator(
              //                     value: 2 * 0.5,
              //                     color: Theme.of(context)
              //                         .appBarTheme
              //                         .backgroundColor,
              //                     backgroundColor: const Color(0xFFF8F8F8),
              //                   ),
              //                 ),
              //               ),
              //               const SizedBox(
              //                 height: 2,
              //               ),
              //               const Text(
              //                 'Amount: amount',
              //                 style: TextStyle(
              //                     color: ColorsFrave.primaryColor,
              //                     fontFamily: 'Baloo2',
              //                     fontSize: 12),
              //               ),
              //               const SizedBox(
              //                 height: 2,
              //               ),
              //               Row(
              //                   mainAxisAlignment:
              //                       MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     const Text(
              //                       'Purpose: description',
              //                       style: TextStyle(
              //                           color: ColorsFrave.primaryColor,
              //                           fontFamily: 'Baloo2',
              //                           fontSize: 12),
              //                     ),
              //                     GestureDetector(
              //                         onTap: () {
              //                           // _replyLoanSheet(context,
              //                           //     appliedLoan!.id);
              //                         },
              //                         child: Container(
              //                             padding: const EdgeInsets.symmetric(
              //                                 horizontal: 10, vertical: 5),
              //                             decoration: BoxDecoration(
              //                                 color: Colors.blue.shade900,
              //                                 borderRadius:
              //                                     const BorderRadius.all(
              //                                         Radius.circular(10))),
              //                             child: const Icon(
              //                               Icons.arrow_forward_ios_rounded,
              //                               size: 20,
              //                               color: ColorsFrave.backgroundColor,
              //                             )))
              //                   ])
              //             ],
              //           ),
              //         ),
              //       );
              //     },
              //     // childCount: state.applied.length,
              //   ),
              // )

              loans != null
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final loan = loans[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 3,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).colorScheme.background,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5),
                                    spreadRadius: 0,
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
                                        'Name: ${loan.loanNo}',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontFamily: 'Baloo2',
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Member No: ${loan.userId}',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontFamily: 'Baloo2',
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(2.5),
                                      child: LinearProgressIndicator(
                                        value: 2 * 0.5,
                                        color: Theme.of(context)
                                            .appBarTheme
                                            .backgroundColor,
                                        backgroundColor:
                                            const Color(0xFFF8F8F8),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Amount: ${loan.amountApplied}',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'Baloo2',
                                      fontSize: 12,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Purpose: ${loan.statusReason}',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontFamily: 'Baloo2',
                                          fontSize: 12,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // Handle onTap
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade900,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: loans.length,
                      ),
                    )
                  : const Center(
                      child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(
                          Colors.lightBlue,
                        ),
                      ),
                    ))
            ],
          )
          // }
          ),
      floatingActionButton: SizedBox(
        width: 100.0, // Set the desired width
        height: 40.0,
        // Set the desired height
        child: FloatingActionButton(
            backgroundColor: ColorsFrave.primaryColor
                .withOpacity(0.9), // Set your desired color here
            onPressed: () {
              _applyLoanSheet(context);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  155.0), // Set a circular radius for all four corners
            ),
            child: const Text(
              'Apply Loan',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Baloo2', fontSize: 12),
            )), // Set the shape here
      ),
    );
  }

  //  {
  //   "id": 0,
  //   "amountApplied": 0,
  //   "status": "PENDING",
  //   "statusReason": "string",
  //   "loanNo": "string",
  //   "interestAmount": 0,
  //   "repayableAmount": 0,
  //   "repaymentBalance": 0,
  //   "createdAt": "2024-04-04T12:01:48.961Z",
  //   "lastUpdatedAt": "2024-04-04T12:01:48.961Z",
  //   "userId": 0
  // }
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
                  // scrollDirection: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Container(
                          width: size.width * .12,
                          height: size.height * 0.007,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 2, 46, 99),
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    SizedBox(height: size.height * 0.04),
                    const Text('Apply Loan',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 2, 32, 71))),
                    SizedBox(height: size.height * 0.02),
                    SizedBox(height: size.height * 0.02),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 2, 32, 71),
                            fontSize: 14),
                        controller: _amountController,
                        validator: amountValidator,
                        cursorColor: Colors.blueGrey,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blueGrey),
                          ),
                          fillColor: Colors.grey.withOpacity(0.5),
                          filled: true,
                          hintText: 'Enter amount',
                          hintStyle: const TextStyle(fontSize: 12),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: const Icon(Icons.numbers_rounded,
                              color: Colors.blue),
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
                    SizedBox(height: size.height * 0.02),
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
                              color: ColorsFrave.primaryColor,
                              borderRadius: BorderRadius.circular(8),
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
    setState(() {
      _applyLoading = true;
    });

    // if (!(await checkNetworkConnectivity())) {
    //   _scaffoldKey.currentState?.showSnackBar(
    //     SnackBar(
    //       content: const Text(
    //         'No Internet Connection',
    //         textAlign: TextAlign.center,
    //       ),
    //       behavior: SnackBarBehavior.floating,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //       duration: const Duration(seconds: 5),
    //       margin: EdgeInsets.only(
    //         bottom: MediaQuery.of(context).size.height * 0.04,
    //         right: 15,
    //         left: 15,
    //       ),
    //       backgroundColor: Colors.red,
    //     ),
    //   );

    //   setState(() {
    //     _isLoading = false;
    //   });
    //   return;
    // }

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String? jwt = prefs.getString('jwt');
    // Map<String, dynamic> token = jsonDecode(jwt!);
    Map<String, String> body = {
      'amount': amount.toString(),
    };
    var url = Uri.parse('$baseUrl/loans/apply');

    final postRequestResponse = await http.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6W3siYXV0aG9yaXR5IjoiT1dORVIifV0sInN1YiI6IjI1NDcyNzkxODk1NSIsImlzcyI6Imh0dHBzOi8vc3BlYWNrLmNvLmtlIiwiaWF0IjoxNzEyMjEyNTIzLCJleHAiOjE3MTIyOTg5MjN9.BSNxf3BsVrhkT4Z90BT27kAnvvzT1gHQkgWNcoDlu7M'
        },
        body: jsonEncode(body));
    print(postRequestResponse.body);

    if (postRequestResponse.statusCode == 200) {
      var jsonResponse = json.decode(postRequestResponse.body);
      var message = jsonResponse['desc'];
// {
//   "code": "string",
//   "status": "string",
//   "desc": "string",
//   "transactionRefId": "string"
// }
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

class RejectedLoans extends StatefulWidget {
  const RejectedLoans({super.key});

  static const routeName = 'approved_loans-screen';

  @override
  State<RejectedLoans> createState() => _ApprovedScreenState();
}

class _ApprovedScreenState extends State<RejectedLoans> {
  // ClearedModel? approvedLoan;
  // late final HomeBloc homeBloc;

  @override
  void initState() {
    // homeBloc = context.read<HomeBloc>();
    // homeBloc.add(const ApprovedData(approved: []));
    super.initState();
  }

  bool isLoading = true; // Add a loading indicator flag

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            // homeBloc.add(const ApprovedData(approved: []));
          },
          child:

              // BlocConsumer<HomeBloc, HomeState>(
              //     listener: (_, __) {},
              //     builder: (context, state) {
              //       return

              CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                centerTitle: false,
                floating: true,
                snap: false,
                pinned: true,
                titleSpacing: 0,
                shadowColor: Colors.transparent,
                expandedHeight: 60,
                backgroundColor: Colors.blue, // Set your desired color here
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 3,
                                  bottom: 6,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: FormFieldFrave(
                                        // controller: _phoneController,
                                        hintText: 'Search approval no.',
                                        keyboardType:
                                            TextInputType.text, //.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your parcel number';
                                          }
                                          // You can add more advanced email validation logic if needed
                                          return null; // Return null if the input is valid
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          // if (_parcelKey.currentState!
                                          //     .validate()) {
                                          //   // If the form is valid, perform the desired action
                                          //   _parcelKey.currentState!.save();
                                          // }
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.all(8),
                                            width: 40,
                                            height: 39,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: Colors.grey.shade300,
                                            ),
                                            child: const Icon(
                                              Icons.search_rounded,
                                              color: ColorsFrave.primaryColor,
                                            )))
                                  ],
                                ),
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
              // (isLoading)
              //     ? SliverList(
              //         delegate: SliverChildListDelegate([
              //           const Center(
              //             child: SizedBox(
              //               width: 20,
              //               height: 20,
              //               child: CircularProgressIndicator(
              //                 strokeWidth: 2.5,
              //                 color: Color.fromARGB(255, 1, 46, 99),
              //               ),
              //             ),
              //           )
              //         ]),
              //       )
              //     :
              // (state.approved.isEmpty)
              //     ?
              //     // If the data is empty, show a message widget
              //     SliverList(
              //         delegate: SliverChildListDelegate([
              //           Center(
              //               child: Column(children: const [
              //             SizedBox(
              //               height: 10,
              //             ),
              //             TextCustom(
              //               text: 'No loans have been approved',
              //               fontSize: 16,
              //             ),
              //           ])),
              //         ]),
              //       )
              //     :
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    // approvedLoan = state.approved[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.background,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Name: name}',
                                    style: TextStyle(
                                        color: ColorsFrave.primaryColor,
                                        fontFamily: 'Baloo2',
                                        fontSize: 15),
                                  ),
                                  Text(
                                    'Member No: member_number}',
                                    style: TextStyle(
                                        color: ColorsFrave.primaryColor,
                                        fontFamily: 'Baloo2',
                                        fontSize: 13),
                                  )
                                ]),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Amount(KSH): .amount}',
                              style: TextStyle(
                                  color: ColorsFrave.primaryColor,
                                  fontFamily: 'Baloo2',
                                  fontSize: 13),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Purpose: description}',
                              style: TextStyle(
                                  color: ColorsFrave.primaryColor,
                                  fontFamily: 'Baloo2',
                                  fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  // childCount: state.approved.length,
                ),
              )
            ],
          )),
    );
  }
}

class Loan {
  final int id;
  final int amountApplied;
  final String status;
  final String statusReason;
  final String loanNo;
  final int interestAmount;
  final int repayableAmount;
  final int repaymentBalance;
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
