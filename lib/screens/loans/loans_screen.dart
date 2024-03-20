import 'package:flutter/material.dart';

import '../../utils/validators.dart';
import 'components/colors_frave.dart';
import 'components/form_field_frave.dart';
import 'components/text_custom.dart';

class LoansHomeScreen extends StatelessWidget {
  const LoansHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(90.0), // Set the desired height
            child: AppBar(
              elevation: 0,
              backgroundColor: const Color.fromARGB(
                  255, 2, 46, 100), // Set your desired color here
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
                indicatorColor:
                    Colors.white, // Set the active tab indicator color
                unselectedLabelColor: Color.fromARGB(
                    255, 183, 202, 218), // Set the inactive tab label color
                indicatorSize:
                    TabBarIndicatorSize.label, // Set indicatorSize to label
                indicatorWeight: 3.0,
                labelColor:
                    Colors.white, // Set the selected (active) tab text color
                tabs: [
                  Tab(
                      icon: Text(
                    'Applied',
                    style: TextStyle(fontFamily: 'Baloo2', fontSize: 13),
                  )),
                  Tab(
                      icon: Text(
                    'Approved',
                    style: TextStyle(fontFamily: 'Baloo2', fontSize: 13),
                  )),
                  Tab(
                      icon: Text(
                    'Declined',
                    style: TextStyle(fontFamily: 'Baloo2', fontSize: 13),
                  )),
                  Tab(
                      icon: Text(
                    'Repaid',
                    style: TextStyle(fontFamily: 'Baloo2', fontSize: 13),
                  )),
                ],
              ),
            )),
        body: const TabBarView(
          children: [
            AppliedLoans(), // QueueScreen(),
            ApprovedLoans(),
            DeclinedLoans(), //CollectedScreen(),
            ClearedLoansScreen(),
          ],
        ),
      ),
    );
  }
}

class AppliedLoans extends StatefulWidget {
  const AppliedLoans({Key? key});

  @override
  _AppliedLoansState createState() => _AppliedLoansState();
}

class _AppliedLoansState extends State<AppliedLoans> {
  // ClearedModel? appliedLoan;
  // late final HomeBloc homeBloc;

  @override
  void initState() {
    // homeBloc = context.read<HomeBloc>();
    // homeBloc.add(const AppliedData(applied: []));
    super.initState();
  }

  bool isLoading = true; // Add a loading indicator flag

  @override
  Widget build(BuildContext context) {
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
                backgroundColor: const Color.fromARGB(255, 2, 46, 100),
                // Set your desired color here
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
                              horizontal: 24, vertical: 20),
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
                                      child: Container(
                                          padding: const EdgeInsets.all(8),
                                          width: 40,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.grey.shade300,
                                          ),
                                          child: const Text(
                                            'Loan Limit:',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Baloo2',
                                                fontSize: 18),
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        child: InkWell(
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
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.grey.shade300,
                                              ),
                                              child: const Text(
                                                'Ksh 13,000.00',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Baloo2',
                                                    fontSize: 18),
                                              ),
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

              SliverAppBar(
                centerTitle: false,
                floating: true,
                snap: false,
                pinned: true,
                elevation: 0,
                titleSpacing: 0,
                shadowColor: Colors.transparent,
                expandedHeight: 60,
                backgroundColor: const Color.fromARGB(255, 2, 46, 100),
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

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    // appliedLoan = state.applied[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 3),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Name: .name' ?? '',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'Baloo2',
                                        fontSize: 14),
                                  ),
                                  Text(
                                    'Member No: member_number' ?? '',
                                    style: TextStyle(
                                        color: ColorsFrave.primaryColor,
                                        fontFamily: 'Baloo2',
                                        fontSize: 13),
                                  ),
                                ]),
                            const SizedBox(
                              height: 2,
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
                                  backgroundColor: const Color(0xFFF8F8F8),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            const Text(
                              'Amount: amount}',
                              style: TextStyle(
                                  color: ColorsFrave.primaryColor,
                                  fontFamily: 'Baloo2',
                                  fontSize: 12),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Purpose: description}' ?? '',
                                    style: TextStyle(
                                        color: ColorsFrave.primaryColor,
                                        fontFamily: 'Baloo2',
                                        fontSize: 12),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        // _replyLoanSheet(context,
                                        //     appliedLoan!.id);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: const BoxDecoration(
                                              color: ColorsFrave.primaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: ColorsFrave.secundaryColor,
                                          )))
                                ])
                          ],
                        ),
                      ),
                    );
                  },
                  // childCount: state.applied.length,
                ),
              )
            ],
          )
          // }
          ),
      floatingActionButton: SizedBox(
        width: 100.0, // Set the desired width
        height: 40.0,
        // Set the desired height
        child: FloatingActionButton(
            backgroundColor:
                ColorsFrave.primaryColor, // Set your desired color here
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

  void _replyLoanSheet(BuildContext context, int LoanId) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.blueGrey.shade100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        return ReplyApplication(loanId: LoanId);
      },
    );
  }
}

class ReplyApplication extends StatefulWidget {
  final int loanId;
  const ReplyApplication({
    Key? key,
    required this.loanId,
  }) : super(key: key);
  @override
  _ReplyApplicationState createState() => _ReplyApplicationState();
}

class _ReplyApplicationState extends State<ReplyApplication> {
  bool loadingApprove = false;
  bool loadingDecline = false;

  final _globalKey = GlobalKey<FormState>();

  // late final MainCubit approveCubit;
  // late final MainCubit declineCubit;
  @override
  void initState() {
    // approveCubit = context.read<MainCubit>();
    // declineCubit = context.read<MainCubit>();
    super.initState();
  }

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
                child: Column(
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
                    Text('Application No: ${widget.loanId}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 2, 32, 71))),
                    SizedBox(height: size.height * 0.04),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: GestureDetector(
                                  onTap: () async {
                                    if (_globalKey.currentState!.validate()) {
                                      setState(() {
                                        loadingApprove = true;
                                      });
                                      //TODO:UpdateDriverCashAmount
                                      // approveCubit
                                      //     .approveLoan(widget.loanId)
                                      //     .then((value) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: const Text(
                                                  'NO SERVER RESPONSE!',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              duration:
                                                  const Duration(seconds: 3),
                                              margin: EdgeInsets.only(
                                                  // ignore: use_build_context_synchronously
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                  right: 10,
                                                  left: 10),
                                              backgroundColor: Colors.green));

                                      setState(() {
                                        loadingApprove = false;
                                      });
                                    }
                                  },
                                  child: Container(
                                      width: size.width,
                                      height: size.height * 0.06,
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                          child: loadingApprove
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.5,
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            ColorsFrave
                                                                .primaryColor),
                                                  ),
                                                )
                                              : const Text('Approve',
                                                  style: TextStyle(
                                                      fontFamily: 'Baloo2',
                                                      fontSize: 17,
                                                      color: ColorsFrave
                                                          .primaryColor)))))),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: GestureDetector(
                                  onTap: () async {
                                    if (_globalKey.currentState!.validate()) {
                                      setState(() {
                                        loadingDecline = true;
                                      });
                                      //TODO:UpdateDriverCashAmount
                                      // declineCubit
                                      //     .declineLoan(widget.loanId)
                                      //     .then((value) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: const Text(
                                                  'NO SERVER RESPONSE!',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              duration:
                                                  const Duration(seconds: 3),
                                              margin: EdgeInsets.only(
                                                  // ignore: use_build_context_synchronously
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                  right: 10,
                                                  left: 10),
                                              backgroundColor: Colors.green));

                                      setState(() {
                                        loadingDecline = false;
                                      });
                                    }
                                  },
                                  child: Container(
                                      width: size.width,
                                      height: size.height * 0.06,
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                          child: loadingDecline
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.5,
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            Colors.white),
                                                  ),
                                                )
                                              : const Text('Decline',
                                                  style: TextStyle(
                                                      fontFamily: 'Baloo2',
                                                      fontSize: 17,
                                                      color: Colors.white)))))),
                        ]),
                    SizedBox(height: size.height * 0.015),
                  ],
                ))));
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
    Key? key,
  }) : super(key: key);
  @override
  _ApplyLoanSheetState createState() => _ApplyLoanSheetState();
}

class _ApplyLoanSheetState extends State<ApplyLoanSheet> {
  bool loadingCollect = false;
  final _globalKey = GlobalKey<FormState>();
  final TextEditingController _mNoController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _desController = TextEditingController();

  // late final MainCubit applyCubit;

  @override
  void initState() {
    // applyCubit = context.read<MainCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _mNoController.dispose();
    _amountController.dispose();
    _desController.dispose();
    super.dispose();
  }

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
                    TextFormField(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 2, 32, 71),
                            fontSize: 14),
                        controller: _mNoController,
                        // validator: nameValidator,
                        cursorColor: Colors.blueGrey,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey),
                          ),
                          fillColor: Colors.grey.withOpacity(0.15),
                          filled: true,
                          hintText: 'Enter Member No.',
                          hintStyle: const TextStyle(fontSize: 12),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: const Icon(Icons.numbers_rounded,
                              color: Colors.green),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                              width: .05,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                              width: .05,
                            ),
                          ),
                        )),
                    SizedBox(height: size.height * 0.02),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 2, 32, 71),
                            fontSize: 14),
                        controller: _amountController,
                        // validator: costValidator,
                        cursorColor: Colors.blueGrey,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey),
                          ),
                          fillColor: Colors.grey.withOpacity(0.15),
                          filled: true,
                          hintText: 'Enter amount',
                          hintStyle: const TextStyle(fontSize: 12),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: const Icon(Icons.location_city_rounded,
                              color: Colors.green),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                              width: .05,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                              width: .05,
                            ),
                          ),
                        )),
                    SizedBox(height: size.height * 0.02),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 2, 32, 71),
                            fontSize: 14),
                        controller: _desController,
                        // validator: costValidator,
                        cursorColor: Colors.blueGrey,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey),
                          ),
                          fillColor: Colors.grey.withOpacity(0.15),
                          filled: true,
                          hintText: 'purpose',
                          hintStyle: const TextStyle(fontSize: 12),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: const Icon(Icons.location_city_rounded,
                              color: Colors.green),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                              width: .05,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                              width: .05,
                            ),
                          ),
                        )),
                    SizedBox(height: size.height * 0.06),
                    GestureDetector(
                        onTap: () async {
                          if (_globalKey.currentState!.validate()) {
                            setState(() {
                              loadingCollect = true;
                            });
                            //TODO:UpdateDriverCashAmount
                            // applyCubit
                            //     .applyLoan(
                            //         _mNoController.text,
                            //         int.parse(_amountController.text),
                            //         _desController.text)
                            //     .then((value) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text('NO SERVER RESPONSE!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                duration: const Duration(seconds: 3),
                                margin: EdgeInsets.only(
                                    // ignore: use_build_context_synchronously
                                    top: MediaQuery.of(context).size.height *
                                        0.02,
                                    right: 10,
                                    left: 10),
                                backgroundColor: Colors.green));

                            setState(() {
                              loadingCollect = false;
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
                                child: loadingCollect
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
}

class ApprovedLoans extends StatefulWidget {
  const ApprovedLoans({super.key});

  static const routeName = 'approved_loans-screen';

  @override
  _ApprovedScreenState createState() => _ApprovedScreenState();
}

class _ApprovedScreenState extends State<ApprovedLoans> {
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
                backgroundColor: const Color.fromARGB(
                    255, 2, 46, 100), // Set your desired color here
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
                                    'Name: name}' ?? '',
                                    style: TextStyle(
                                        color: ColorsFrave.primaryColor,
                                        fontFamily: 'Baloo2',
                                        fontSize: 15),
                                  ),
                                  Text(
                                    'Member No: member_number}' ?? '',
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
                              'Amount(KSH): .amount}' ?? '',
                              style: TextStyle(
                                  color: ColorsFrave.primaryColor,
                                  fontFamily: 'Baloo2',
                                  fontSize: 13),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Purpose: description}' ?? '',
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

class DeclinedLoans extends StatefulWidget {
  const DeclinedLoans({Key? key});

  @override
  _DeclinedLoansState createState() => _DeclinedLoansState();
}

class _DeclinedLoansState extends State<DeclinedLoans> {
  // ClearedModel? declinedLoan;
  // late final HomeBloc homeBloc;

  @override
  void initState() {
    // homeBloc = context.read<HomeBloc>();
    // homeBloc.add(const DeclinedData(declined: []));
    super.initState();
  }

  bool isLoading = true; // Add a loading indicator flag

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            // homeBloc.add(const DeclinedData(declined: []));
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
                titleSpacing: 0,
                shadowColor: Colors.transparent,
                expandedHeight: 60,
                backgroundColor: const Color.fromARGB(
                    255, 2, 46, 100), // Set your desired color here
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
                                        hintText: 'Search declined',
                                        keyboardType:
                                            TextInputType.text, //.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter loan id';
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
              // (state.declined.isEmpty)
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
              //               text: 'No Loans declined',
              //               fontSize: 16,
              //             ),
              //           ])),
              //         ]),
              //       )
              //     :
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    // declinedLoan = state.declined[index];
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
                                    'Name: .name}' ?? '',
                                    style: TextStyle(
                                        color: ColorsFrave.primaryColor,
                                        fontFamily: 'Baloo2',
                                        fontSize: 15),
                                  ),
                                  Text(
                                    'Member No: member_number}' ?? '',
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
                              'Amount: amount}' ?? '',
                              style: TextStyle(
                                  color: ColorsFrave.primaryColor,
                                  fontFamily: 'Baloo2',
                                  fontSize: 15),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Purpose: description}' ?? '',
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
                  // childCount: state.declined.length,
                ),
              )
            ],
          )),
    );
  }
}

class ClearedLoansScreen extends StatefulWidget {
  const ClearedLoansScreen({Key? key});

  @override
  _ClearedLoansScreenState createState() => _ClearedLoansScreenState();
}

class _ClearedLoansScreenState extends State<ClearedLoansScreen> {
  // ClearedModel? clearedLoan;
  // late final HomeBloc homeBloc;

  @override
  void initState() {
    // homeBloc = context.read<HomeBloc>();
    // homeBloc.add(const ClearedData(cleared: []));
    super.initState();
  }

  bool isLoading = true; // Add a loading indicator flag

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            // homeBloc.add(const ClearedData(cleared: []));
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
                backgroundColor: const Color.fromARGB(
                    255, 2, 46, 100), // Set your desired color here
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
                                        hintText: 'Search declined',
                                        keyboardType:
                                            TextInputType.text, //.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter loan id';
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
              // (state.cleared.isEmpty)
              //     ?
              //     // If the data is empty, show a message widget
              //     SliverList(
              //         delegate: SliverChildListDelegate([
              //           Center(
              //               child: Column(children: [
              //             const SizedBox(
              //               height: 10,
              //             ),
              //             const TextCustom(
              //               text: 'No Loans cleared',
              //               fontSize: 16,
              //             ),
              //           ])),
              //         ]),
              //       )
              //     :
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    // clearedLoan = state.cleared[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 3),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Member No: {clearedLoan?.member_number}' ?? '',
                              style: TextStyle(
                                  color: ColorsFrave.primaryColor,
                                  fontFamily: 'Baloo2',
                                  fontSize: 15),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            const Text(
                              'Source: {clearedLoan?.amount}' ?? '',
                              style: TextStyle(
                                  color: ColorsFrave.primaryColor,
                                  fontFamily: 'Baloo2',
                                  fontSize: 13),
                            ),
                            const Text(
                              'Destination: {clearedLoan?.description}' ?? '',
                              style: TextStyle(
                                  color: ColorsFrave.primaryColor,
                                  fontFamily: 'Baloo2',
                                  fontSize: 13),
                            ),
                            const SizedBox(
                              height: 2,
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
                                  backgroundColor: const Color(0xFFF8F8F8),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Name: {clearedLoan?.name}' ?? '',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Baloo2',
                                        fontSize: 12),
                                  ),
                                ])
                          ],
                        ),
                      ),
                    );
                  },
                  // childCount: state.cleared.length,
                ),
              )
            ],
          )),
      // floatingActionButton: SizedBox(
      //   width: 100.0, // Set the desired width
      //   height: 40.0,
      //   // Set the desired height
      //   child: FloatingActionButton(
      //       backgroundColor: Colors.lightGreen, // Set your desired color here
      //       onPressed: () {
      //         // Navigator.push(context, routeFrave(page: CreateTransScreen()));
      //       },
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(
      //             155.0), // Set a circular radius for all four corners
      //       ),
      //       child: const Text(
      //         'Repay',
      //         style: TextStyle(
      //             color: Colors.black87, fontFamily: 'Baloo2', fontSize: 14),
      //       )), // Set the shape here
      // ),
    );
  }
}
