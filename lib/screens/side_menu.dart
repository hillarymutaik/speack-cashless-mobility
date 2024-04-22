// import 'package:driver_app/blocs/auth/auth_bloc.dart';
// import 'package:driver_app/cubit/guest/guest_cubit.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login_screen.dart';
import 'commission/commission_screen.dart';
// import 'fleet_screen.dart';
// import 'users.dart';
// import 'vehicles.dart';
// import 'wallet/wallet_pin.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import '../wallet/wallet_otp_request.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String? tokenzz;
  String? fullname;
  String? email;

  void account() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenzz = prefs.getString('jwt')!;
    Map<String, dynamic> token = jsonDecode(tokenzz!);
    setState(() {
      fullname = '${token['data']['user']['fullName']}';
      email = '${token['data']['user']['email']}';
    });
  }

  @override
  void initState() {
    super.initState();
    account();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black.withOpacity(.9),
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 75, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white70.withOpacity(.1),
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '$fullname',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            accountEmail: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white70
                        .withOpacity(.1), //Get.theme.primaryColor,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '$email',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                )),
            currentAccountPicture: CircleAvatar(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/logo.jpg',
                    ),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.black87,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: AccountLinkWidget(
                icon: Icon(
                  Icons.dashboard,
                  color: Colors.blue.shade200,
                  // size: 30,
                ),
                text: const Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: (e) {
                  // Navigate to the '/profile' route
                  Navigator.pop(context);
                },
              )),

          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: AccountLinkWidget(
                icon: Icon(
                  Icons.percent_rounded,
                  color: Colors.blue.shade200,
                ),
                text: const Text(
                  'Commission',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: (e) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => CommissionScreen()));
                  // requestOTP();
                },
              )),

          // BlocConsumer<AuthBloc, AuthState>( VehiclesScreen
          //   listener: (context, state) {
          //     if (!state.isAuthenticated) {
          //       SystemNavigator.pop();
          //     }
          //   },
          //   builder: (context, state) {
          //     return
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            decoration: BoxDecoration(
                color: Colors.transparent
                    .withOpacity(.1), //Get.theme.primaryColor,
                border: Border.all(
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: AccountLinkWidget(
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
                // size: 30,
              ),
              text: const Text('Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.redAccent,
                  )),
              onTap: (e) async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height * 0.18,
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Are you sure to logout?",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.all(
                                        MediaQuery.of(context).size.height *
                                            0.018,
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color:
                                              Colors.redAccent.withOpacity(0.6),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: const Center(
                                        child: Text("Cancel",
                                            maxLines: 2,
                                            softWrap: false,
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs
                                            .remove('jwt')
                                            .then((value) =>
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SignInScreen())))
                                            .onError((error, stackTrace) =>
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text('$error'),
                                                )));
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.all(
                                          MediaQuery.of(context).size.height *
                                              0.018,
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: Colors
                                                .blue, //Get.theme.primaryColor,
                                            border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: const Center(
                                          child: Text("Yes",
                                              maxLines: 2,
                                              softWrap: false,
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AccountLinkWidget extends StatelessWidget {
  final Icon icon;
  final Widget text;
  final ValueChanged<void> onTap;

  const AccountLinkWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap('');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            icon,
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 1,
              height: 24,
              color: Colors.blue.shade200,
            ),
            Expanded(
              child: text,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Colors.blue.shade200,
            ),
          ],
        ),
      ),
    );
  }
}
