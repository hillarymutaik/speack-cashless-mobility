// import 'package:driver_app/blocs/auth/auth_bloc.dart';
// import 'package:driver_app/cubit/guest/guest_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fleet_screen.dart';
import 'transactions.dart';
import 'users.dart';
import 'vehicles.dart';
import 'wallet/pin.dart';
import 'wallet/wallet_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';

// import '../wallet/wallet_otp_request.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String username = '';
  String phone = '';
  String fullname = '';
  String email = '';
  String? token;

  @override
  void initState() {
    super.initState();
    // final authState = context.read<AuthBloc>().state;
    // username = authState.user?.username ?? '';
    // phone = authState.user?.phone ?? '';
    // fullname = authState.user?.fullname ?? '';
    // email = authState.user?.email ?? '';
    // final auth = context.read<AuthBloc>().state;
    // token = auth.token;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black87,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            // accountName: Container(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            //     margin: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
            //     decoration: BoxDecoration(
            //         color: Colors.white70.withOpacity(.1),
            //         border: Border.all(color: Colors.transparent),
            //         borderRadius: BorderRadius.circular(8)),
            //     child: const Text(
            //       'Speack',
            //       style: TextStyle(
            //         fontSize: 16,
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     )),
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
                child: const Text(
                  'Speack Limited',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
            accountName: null,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .025,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: AccountLinkWidget(
                icon: Icon(
                  Icons.dashboard,
                  color: Colors.red.shade900,
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
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: AccountLinkWidget(
                icon: Icon(
                  Icons.wallet_rounded,
                  color: Colors.red.shade900,
                ),
                text: const Text(
                  'Wallet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: (e) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => const PinScreen()));
                  // requestOTP();
                },
              )),

          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: AccountLinkWidget(
                icon: Icon(
                  Icons.people_alt_rounded,
                  color: Colors.red.shade900,
                  // size: 30,
                ),
                text: const Text(
                  'Users',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: (e) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => UserDataScreen()));
                },
              )),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: AccountLinkWidget(
                icon: Icon(
                  Icons.motorcycle_rounded,
                  color: Colors.red.shade900,
                  // size: 30,
                ),
                text: const Text(
                  'Vehicles',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: (e) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => VehiclesScreen()));
                },
              )),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: AccountLinkWidget(
                icon: Icon(
                  Icons.bus_alert_rounded,
                  color: Colors.red.shade900,
                  // size: 30,
                ),
                text: const Text(
                  'Fleets',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: (e) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => FleetNumbersScreen()));
                },
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * .12,
          ),
          const Divider(
            color: Colors.white,
          ),
          // BlocConsumer<AuthBloc, AuthState>( VehiclesScreen
          //   listener: (context, state) {
          //     if (!state.isAuthenticated) {
          //       SystemNavigator.pop();
          //     }
          //   },
          //   builder: (context, state) {
          //     return
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 23),
            decoration: BoxDecoration(
                color: Colors.white70.withOpacity(.1), //Get.theme.primaryColor,
                border: Border.all(
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: AccountLinkWidget(
              icon: const Icon(
                Icons.logout,
                color: Colors.redAccent,
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
                                    color: Color.fromARGB(255, 128, 65, 100),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
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
                                      // height: MediaQuery.of(context)
                                      //         .size
                                      //         .height *
                                      //     0.045,
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.all(
                                        MediaQuery.of(context).size.height *
                                            0.018,
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: Colors.redAccent.withOpacity(
                                              0.8), //Get.theme.primaryColor,
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
                                        // context
                                        //     .read<GuestCubit>()
                                        //     .signOut();
                                      },
                                      child: Container(
                                        // height: MediaQuery.of(context)
                                        //         .size
                                        //         .height *
                                        //     0.045,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.all(
                                          MediaQuery.of(context).size.height *
                                              0.018,
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255,
                                                128,
                                                65,
                                                100), //Get.theme.primaryColor,
                                            border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: const Center(
                                          child: Text("Logout",
                                              maxLines: 2,
                                              softWrap: false,
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                  fontSize: 15,
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
            //   );
            // },
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
              color: Colors.white,
            ),
            Expanded(
              child: text,
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
